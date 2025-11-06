-------------------------------------------------------------------------------
-- Design unit header --
-- LCD Module for Tianma TM080TDHG01-40 Display Controller
-- Provides video output generation, backlight PWM control, and initialization sequence
-- Target display: 1280x800 @ 60Hz, LVDS interface
-- Video format: YCbCr420 -> YCbCr444 -> RGB conversion pipeline
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
library work;
use work.common_lib.all;
use work.vimon10_lib.all;
use work.lcd_lib.all;

entity lcd_module is
	generic( 
		-- LCD timing parameters
		hsize       : integer:=1280;              -- Horizontal active pixels
		hblank      : integer:=160;              -- Horizontal blanking period
		vsize       : integer:=800;               -- Vertical active lines
		vblank      : integer:=23;               -- Vertical blanking period
		hpicture    : integer:=960;              -- Active picture width
		vpicture    : integer:=540;              -- Active picture height
		vfild       : integer:=32;                -- Vertical front porch/fill pixels
		rgb_ground  : type_rgb_color:=rgb_sienna -- Border color
		);
	port(
		-- Control and clock signals
		reset        : in STD_LOGIC;                      -- System reset
		sclk, pclk   : in std_logic;                     -- Serial clock (225MHz) and pixel clock (64.286MHz)
		EN           : in std_logic;                      -- Module enable
		backlight    : in type_backlight;                 -- Backlight brightness level (0-128)
		err, vsync   : out std_logic;                      -- Error output and vertical sync
		
		-- Position counters
		Vcount, Hcount : out integer;                     -- Current vertical and horizontal position
		
		-- Video content control
		no_signal    : in std_logic;                      -- No video signal detected flag
		grafics_act  : in boolean;                         -- Graphics overlay active
		grafics_color: in type_rgb_color;                  -- Graphics overlay color
		
		-- LVDS output to display
		lcd_a_clk    : out std_logic;                     -- LVDS clock output
		lcd_a        : out std_logic_vector(3 downto 0);   -- LVDS data outputs (4 channels)
		
		-- LCD panel control signals
		LCD_EN_VDD, LCD_RST, LCD_EN, LCD_PWM : out STD_LOGIC; -- Power, Reset, Enable, PWM
		
		-- Video memory interface (dual-buffer for video data)
		mem_a        : out std_logic_vector(9 downto 0);  -- Memory address (10-bit, with bank select in MSB)
		mem_wr       : out std_logic;                     -- Memory write enable
		mem_d        : out std_logic_vector(31 downto 0); -- Memory data to write
		mem_q        : in std_logic_vector(95 downto 0)   -- Memory data read (96-bit YCbCr420 pixel pair)
		);
end lcd_module;

architecture main of lcd_module is	  	
	
	-------------------------------------------------------------------------------
	-- PWM Backlight Control Parameters
	-------------------------------------------------------------------------------
	constant fps          : integer := 60;                        -- Frame rate (60 FPS)
--	constant PWMfreq      : integer := 18517;                     -- 12987KHz -71db
--	constant PWMfreq      : integer := 26000;                     -- 18094KHz -48db
	constant PWMfreq      : integer := 27000;                     -- 18844KHz -53db
--	constant PWMfreq      : integer := 28000;                     -- 19688KHz -47db
--	constant PWMfreq      : integer := 29000;                     -- 20625KHz -51db
--	constant PWMfreq      : integer := 30000;                     -- 21562KHz -48db
--	constant PWMfreq      : integer := 32000;                     -- 22594KHz -49db
	constant PWMsize      : integer := 99;                        -- PWM resolution steps (0-99, giving 100 levels)
	-- Calculate how many pixel clocks per PWM period
	-- max_PWMcount = total_pixels_per_frame / (PWMfreq/fps * PWMsize)
	-- This synchronizes PWM with video frame to avoid flickering
	constant max_PWMcount : integer := ((hsize+hblank)*(vsize+vblank)) / (PWMfreq/fps*PWMsize);
	constant corr_PWMcount: integer := ((hsize+hblank)*(vsize+vblank)) mod (PWMfreq/fps*PWMsize);
	signal PWM_ena        : std_logic;                            -- PWM enable signal (active after LCD init)
	constant picture_dalay: integer := 8;                        -- Picture display delay (pixels)
	
	-------------------------------------------------------------------------------
	-- Video Memory Buffer Management
	-------------------------------------------------------------------------------
	constant adrBuff_status  : integer := 0;                     -- Memory address for status word
	constant adrBuff_start   : integer := 1;                     -- Memory address for frame start
	constant status_signature: std_logic_vector(15 downto 0) := x"428F"; -- Status magic number
	
	-------------------------------------------------------------------------------
	-- State Machine and Video Timing Signals
	-------------------------------------------------------------------------------
	signal lcd, stream      : type_LCD;                               -- LCD output data structure
	type state_type is (Vpause,Hpause,Start1,Start2,Start3,Line,error);
	signal state            : state_type := Vpause;                   -- Video generation state machine
	
	constant max_adrBuff    : integer := 8192*2-1;                   -- Maximum buffer address (dual-buffer: 8192*2 words)
	signal adrBuff          : integer range 0 to 2**10-1 := 0;
	signal count_adrBuff    : integer range 0 to 2**10-1 := 0;	
	constant max_intDcount  : integer := hsize*2-1;
	signal intDcount        : integer range 0 to max_intDcount := 0;  -- Dynamic pattern counter for "no signal"
	signal intHcount        : integer range 0 to hblank+hsize-1 := 0; -- Horizontal position counter
	signal store0Request    : integer range 0 to vblank+vsize-1 := 0;
	signal store1Request    : integer range 0 to vblank+vsize-1 := 0;
	signal intVcount        : integer range 0 to vblank+vsize-1 := 0;
	signal intVAcount       : integer range 0 to vblank+vsize-1 := 0; -- Requested line numbers for buffer validation
	
	-- Timing and region detection flags
	signal Frame         : boolean := false;                       -- Frame: start of new frame
	signal Vstart        : boolean := false;                       -- Vertical active region start
	signal Vstop         : boolean := false;                       -- Vertical active region end
	signal Hstart        : boolean := false;                       -- Horizontal active region start
	signal Hstop         : boolean := false;                       -- Horizontal active region end
	signal req_act       : boolean := false;                       -- Active request region for buffer management
	signal edgingv_act   : boolean := false;                       -- Vertical edge/border region
	signal edgingh_act   : boolean := false;                       -- Horizontal edge/border region
	signal picturev_act  : boolean := false;                       -- Vertical picture region (active video area)
	signal pictureh_act  : boolean := false;                       -- Horizontal picture region (active video area)
	signal status_buffer : boolean := false;                       -- Buffer status validation
	
	signal adrBuffHi     : std_logic := '0';                        -- Buffer bank selection (for dual-buffer ping-pong)
	signal numBuff       : std_logic := '0';
	signal Hphase        : integer range 0 to 3 := 0;             -- Horizontal phase for 4:2:0 chroma subsampling
	signal YCC420stream  : std_logic_vector(47 downto 0) := (others=>'0'); -- YCbCr 4:2:0 pixel data (48-bit)
	signal err_sequence  : std_logic;                              -- Video sequence error flag
	
	-------------------------------------------------------------------------------
	-- Video Color Conversion Pipeline
	-------------------------------------------------------------------------------
	signal YCC444stream : type_ycc_color := ycc_black;             -- YCbCr 4:4:4 intermediate
	signal RGBstream    : type_rgb_color := rgb_black;             -- RGB output
	signal genY         : std_logic_vector(7 downto 0);           -- Generated Y component for "no signal" pattern
	
begin 
	-- Assign internal signals to outputs
	err    <= err_sequence;
	Vcount <= intVcount;
	Hcount <= intHcount;
	
	-------------------------------------------------------------------------------
	-- LCD Panel Initialization Sequence Process (EN_proc)
	-- Controls LCD power, reset, enable, and PWM enable signals
	-- Executes once per video frame when Frame='1'
	-- Sequence timing (in frames at 60 FPS):
	--   Frame 0:  All signals LOW
	--   Frame 1:  Power ON (LCD_EN_VDD='1'), Reset HIGH (LCD_RST='1')
	--   Frame 10: Reset released (LCD_RST='0')
	--   Frame 15: LCD enabled (LCD_EN='1')
	--   Frame 30: PWM enabled (PWM_ena='1')
	-------------------------------------------------------------------------------
	EN_proc: process (reset, pclk, Frame)
		variable max_count : integer := 32;  -- Maximum frame count for init sequence
		variable count     : integer range 0 to max_count-1;
	begin
		if reset='1' then 
			count      := 0;
			LCD_EN_VDD <= '0';  -- Power OFF
			LCD_RST    <= '0';  -- Reset OFF
			LCD_EN     <= '0';  -- LCD disabled
			PWM_ena    <= '0';  -- PWM disabled
		elsif rising_edge(pclk) and Frame then 
			case count is
				when 00 => LCD_EN_VDD <= '0'; LCD_RST <= '0'; LCD_EN <= '0'; PWM_ena <= '0';  -- Initial state
				when 01 => LCD_EN_VDD <= '1'; LCD_RST <= '1'; LCD_EN <= '0'; PWM_ena <= '0';  -- Power on, assert reset
				when 10 => LCD_EN_VDD <= '1'; LCD_RST <= '0'; LCD_EN <= '0'; PWM_ena <= '0';  -- Release reset, hold reset low for 9 frames
				when 15 => LCD_EN_VDD <= '1'; LCD_RST <= '0'; LCD_EN <= '1'; PWM_ena <= '0';  -- Enable LCD panel
				when 30 => LCD_EN_VDD <= '1'; LCD_RST <= '0'; LCD_EN <= '1'; PWM_ena <= '1';  -- Enable backlight PWM
				when others => null;
			end case;
			if EN='1' then
				if count /= max_count-1 then
					count := count+1;
				end if;
			else 
				count := 0;  -- Reset count if EN goes low
			end if;
		end if;
	end process EN_proc; 
	
	-------------------------------------------------------------------------------
	-- Backlight PWM Control Process (PWM_proc)
	-- Generates PWM signal synchronized with video frame timing
	-- PWM duty cycle determines brightness level (backlight parameter)
	-- 
	-- Mechanism:
	--   - PWM period is synchronized with video frame (60 Hz)
	--   - Within each frame, PWM toggles based on backlight value
	--   - count_pwm: PWM step counter (0 to max_count_pwm)
	--   - count: pixel clock divider for PWM frequency
	--   - PWM HIGH when count_pwm=0
	--   - PWM LOW when count_pwm reaches (BACKLIGHT_MARGIN_MIN + backlight)
	--
	-- Brightness range: 0% to 100%
	--   - backlight=0:   Duty = BACKLIGHT_MARGIN_MIN / (BACKLIGHT_MARGIN_MIN+BACKLIGHT_MAX-2)
	--   - backlight=100: Duty = (BACKLIGHT_MARGIN_MIN+100) / (BACKLIGHT_MARGIN_MIN+BACKLIGHT_MAX-2)
	-------------------------------------------------------------------------------
	PWM_proc: process (pclk)
		constant max_count_pwm : integer := BACKLIGHT_MARGIN_MIN+BACKLIGHT_MAX-2;  -- Total PWM steps (15+128-2 = 141)
		variable count_pwm     : integer range 0 to max_count_pwm;                  -- Current PWM step
		variable count        : integer range 0 to corr_PWMcount+max_PWMcount-1;   -- Pixel clock divider
		variable count_pwm_inc: boolean := false;                                   -- PWM increment flag
	begin
		if rising_edge(pclk) then 
			-- Generate PWM signal based on current step
			if count_pwm = 0 then
				LCD_PWM <= PWM_ena;  -- Start of PWM period: output enable signal
			elsif count_pwm = BACKLIGHT_MARGIN_MIN+backlight then
				LCD_PWM <= '0';  -- Turn off when reaching brightness threshold
			end if;
			
			-- Reset PWM counter at start of each video frame
			if Frame then
				count_pwm := 0;
			elsif count_pwm_inc then
				if count_pwm = max_count_pwm then
					count_pwm := 0;  -- Wrap around at end of period
				else 
					count_pwm := count_pwm+1;  -- Increment PWM step
				end if;
			end if;
			
			count_pwm_inc := count=0;  -- Increment PWM when pixel clock divider reaches zero
			
			-- Pixel clock divider to achieve desired PWM frequency
			if Frame then
				count := max_PWMcount-1;  -- Reset at start of frame
			elsif count = 0 then
				count := max_PWMcount-1;  -- Reset counter
			else
				count := count-1;  -- Decrement divider
			end if;
		end if;
	end process PWM_proc; 
	
	-------------------------------------------------------------------------------
	-- LVDS Output Serializer
	-- Converts parallel RGB data with sync signals to LVDS format
	-- sclk: 225 MHz serial clock for LVDS transmission
	-- pclk: 64.286 MHz pixel clock for data capture
	-------------------------------------------------------------------------------
	LCDserializer1 : entity work.LCDserializer 
		port map(
			reset    => '0',
			sclk     => sclk,           -- 225 MHz serial clock
			pclk     => pclk,           -- 64.286 MHz pixel clock
			lcd      => lcd,            -- RGB + sync data
			lvds_clk => lcd_a_clk,      -- LVDS clock output
			lvds_out => lcd_a           -- LVDS data outputs (4 channels)
		);	
	
	-------------------------------------------------------------------------------
	-- Video Memory Address and Control Interface
	-------------------------------------------------------------------------------
	mem_a(9)         <= adrBuffHi;                              -- MSB selects buffer bank (0 or 1)
	mem_a(8 downto 0) <= conv_std_logic_vector(adrBuff, 9);     -- Lower 9 bits = address within bank
	numBuff          <= conv_std_logic_vector(intVAcount, 1)(0); -- Current active buffer (ping-pong)
	
	-------------------------------------------------------------------------------
	-- Status Word Generation for Frame Buffer Management
	-- Memory data structure (32-bit word):
	--   [31:16] - Status signature (x"428F")
	--   [15:4]  - Next line request or line counter
	--   [3]     - Write flag for status register
	--   [2]     - Buffer select bit
	--   [1]     - Last line indicator
	--   [0]     - End of frame marker
	-------------------------------------------------------------------------------
	mem_d(31 downto 16) <= status_signature;                    -- Frame buffer status magic number
	mem_d(15)           <= '0';
	mem_d(14)           <= '0';
	mem_d(3)            <= '0';
	
	-------------------------------------------------------------------------------
	-- Main Video Processing Process (main_proc)
	-- Handles video timing, memory addressing, state machine, and pixel data flow
	-- State machine controls video frame generation: Vsync->Hsync->Line processing
	-- Manages dual-buffer ping-pong for video data reading
	-------------------------------------------------------------------------------
	main_proc: process (pclk)
	begin
		if rising_edge(pclk) then 
			-------------------------------------------------------------------------------
			-- Generate Y component for "no signal" pattern (checkerboard)
			-- Alternates between high/low based on position (H+V+D) counter
			-------------------------------------------------------------------------------
			if conv_std_logic_vector(intHcount+intVcount+intDcount, 16)(10) = '0' then
				genY <= "00" & conv_std_logic_vector(intHcount+intVcount+intDcount, 16)(9 downto 4);
			else
				genY <= "00" & not conv_std_logic_vector(intHcount+intVcount+intDcount, 16)(9 downto 4);
			end if;
			
			-------------------------------------------------------------------------------
			-- Generate status word for video memory (dual-buffer management)
			-- Contains line request number, buffer select, frame end marker
			-------------------------------------------------------------------------------
			if intVAcount = vpicture then
				mem_d(13 downto 4) <= conv_std_logic_vector(0, 10);  -- No more lines
				mem_d(2)           <= '0';
				mem_d(1)           <= '0';
				mem_d(0)           <= '1';                               -- End of frame marker
			else
				mem_d(13 downto 4) <= conv_std_logic_vector(intVAcount+1, 10);  -- Request next line
				mem_d(2)           <= not numBuff;                      -- Buffer select (ping-pong)
				mem_d(1)           <= boolean_to_data(intVAcount=vpicture-1);  -- Last line flag
				mem_d(0)           <= '0';
			end if;
			
			-------------------------------------------------------------------------------
			-- Generate timing flags for video regions and state machine
			-------------------------------------------------------------------------------
			Vstart        <= intVcount=1 and intHcount=hblank+hsize-2;  -- Start of active vertical region
			Vstop         <= intVcount=vsize+1 and intHcount=hblank+hsize-2;  -- End of active vertical region
			Hstart        <= intHcount=hblank-4;  -- Start of active horizontal region
			Hstop         <= intHcount=hblank+hsize-2;  -- End of active horizontal region
			vsync         <= boolean_to_data(intVcount=0);  -- Vertical sync pulse
			req_act       <= intVcount>=vfild-1 and intVcount<vpicture+vfild-1;  -- Active request region for buffer
			picturev_act  <= intVcount>=vfild and intVcount<vpicture+vfild;  -- Active video in vertical direction
			edgingv_act   <= intVcount<vfild or intVcount>=vfild+vpicture;  -- Vertical edge/border region
			edgingh_act   <= intHcount<hblank+(hsize-hpicture)/2 or intHcount>=hblank+hsize-(hsize-hpicture)/2;  -- Horizontal edge/border
			pictureh_act  <= intHcount>=hblank+(hsize-hpicture)/2-picture_dalay and intHcount<hblank+hsize-(hsize-hpicture)/2-picture_dalay;  -- Active video horizontally
			
			-------------------------------------------------------------------------------
			-- Validate buffer status by comparing requested line number
			-------------------------------------------------------------------------------
			if numBuff='0' then
				status_buffer<=mem_q(31 downto 16)=conv_std_logic_vector(store1Request,16);	  
			else
				status_buffer<=mem_q(15 downto 0)=conv_std_logic_vector(store0Request,16);	  
			end if;
			
			-------------------------------------------------------------------------------
			-- Update dynamic pattern counter for "no signal" checkerboard
			-- Increments by 16 at start of each frame to create moving pattern
			-------------------------------------------------------------------------------
			if intVcount=0 and intHcount=0 then 
				if  intDcount=max_intDcount then	
					intDcount<=0;	
				else
					intDcount<=intDcount+16;  -- Step by 16 for pattern animation
				end if;
			end if;
			
			-------------------------------------------------------------------------------
			-- Update vertical line counter (intVcount)
			-- Tracks current line in frame (0 to vblank+vsize-1)
			-------------------------------------------------------------------------------
			if intHcount=0 then 
				if  intVcount=vblank+vsize-1 then	
					intVcount<=0;  -- Wrap to start of frame
				else
					intVcount<=intVcount+1;  -- Next line
				end if;
			end if;
			
			-------------------------------------------------------------------------------
			-- Update active video line counter (intVAcount)
			-- Only increments during active video region (inside picture)
			-------------------------------------------------------------------------------
			if intHcount=0 then
				if intVcount=vfild-1 then 
					intVAcount<=0;  -- Reset at start of active region
				elsif picturev_act then
					intVAcount<=intVAcount+1;  -- Increment during active video
				end if;
			end if;
			
			-------------------------------------------------------------------------------
			-- Update horizontal pixel counter (intHcount)
			-- Tracks horizontal position: 0 to hblank+hsize-1
			-------------------------------------------------------------------------------
			if intHcount=hblank+hsize-1 then	 
				intHcount<=0;  -- Wrap to start of next line
			else
				intHcount<=intHcount+1;  -- Next pixel
			end if;	
			
			-------------------------------------------------------------------------------
			-- Video Generation State Machine
			-- States: Vpause -> Hpause -> Start1 -> Start2 -> Line -> Hpause
			-- Controls frame timing, memory access, and pixel data generation
			-------------------------------------------------------------------------------
			case state is 
				-------------------------------------------------------------------------------
				-- State: Hpause - Horizontal blanking period
				-- Prepares for next line, writes status to memory
				-------------------------------------------------------------------------------
				when Hpause =>  
					lcd<=(rgb_black,hs);  -- Output horizontal sync
					adrBuffHi<=boolean_to_data(intHcount>5);  -- Switch to status address
					adrBuff<=adrBuff_status;  -- Address: status register
					if intHcount=2 then	
						if numBuff='0' then
							store0Request<=intVAcount;  -- Request line from buffer 0
						else
							store1Request<=intVAcount;  -- Request line from buffer 1
						end if;
					end if;	 
					mem_wr<=boolean_to_data(intHcount=2 and req_act);  -- Write status during request region
					Frame<=false;  -- Clear frame start flag
					if Hstart then	
						state<=Start1;  -- Transition to line start
					end if;	
				
				-------------------------------------------------------------------------------
				-- State: Start1 - Line start validation
				-- Checks buffer status for data readiness
				-------------------------------------------------------------------------------
				when Start1 =>
					lcd<=(rgb_black,cl);  -- Clear state
					if not status_buffer and not edgingv_act then
						err_sequence<='1';  -- Set error if buffer not ready (except in edge regions)
					end if;
					state<=Start2;  -- Continue to next start state
				
				-------------------------------------------------------------------------------
				-- State: Start2 - Line data preparation
				-- Sets up memory addressing for active line data
				-------------------------------------------------------------------------------
				when Start2 =>
					err_sequence<='0';  -- Clear error flag
					lcd<=(rgb_black,cl);  -- Clear state
					Hphase<=0;  -- Reset horizontal chroma phase
					adrBuffHi<=numBuff;  -- Select active buffer bank
					adrBuff<=adrBuff_start;  -- Address: start of line data
					state<=Line;  -- Transition to active line processing
				
				-------------------------------------------------------------------------------
				-- State: Line - Active line processing
				-- Outputs pixel data, reads from memory, handles overlays
				-------------------------------------------------------------------------------
				when Line =>  
					lcd.sync<=de;  -- Data enable (active video)
					
					-- Pixel color selection priority: graphics overlay > border > video
					if grafics_act then 
						lcd.color<=grafics_color;  -- Graphics overlay has priority
					elsif edgingh_act or edgingv_act then 
						lcd.color<=rgb_ground;  -- Border/border region
					else
						lcd.color<=RGBstream;  -- Regular video data
					end if;	   
					
					-- YCbCr 4:2:0 data generation
					-- Format: [Cb(47-40)] [Cr(39-32)] [Y11(31-24)] [Y10(23-16)] [Y01(15-8)] [Y00(7-0)]
					if no_signal='1' then
						-- Generate checkerboard pattern when no signal
						YCC420stream<= ycc_black.Cb & ycc_black.Cr & genY & genY & genY & genY;
					elsif picturev_act and pictureh_act and Hphase=1 then  
						-- Read second pixel pair from 96-bit word (Y11,Y10,Cb,Cr)
						adrBuff<=adrBuff+1;  -- Increment memory address
						YCC420stream<= mem_q(95 downto 80) & mem_q(63 downto 48) & mem_q(31 downto 16);
						Hphase<=0;  -- Next phase will be Y00,Y01
					else
						-- Read first pixel pair from 96-bit word (Y00,Y01,Cb,Cr)
						YCC420stream<= mem_q(79 downto 64) & mem_q(47 downto 32) & mem_q(15 downto 0);
						Hphase<=1;  -- Next phase will be Y11,Y10
					end if;	
					
					-- State transitions
					if Vstop then	
						state<=Vpause;  -- End of vertical active region
					elsif Hstop then	
						state<=Hpause;  -- End of horizontal active region (next line)
					end if;	
				
				-------------------------------------------------------------------------------
				-- State: Vpause - Vertical blanking period
				-- Between frames, resets for next frame start
				-------------------------------------------------------------------------------
				when Vpause =>  
					lcd<=(rgb_black,vs);  -- Output vertical sync
					if Vstart then
						Frame<=true;  -- Set frame start flag (triggers PWM reset)
						state<=Hpause;  -- Start next frame
					end if;	
				
				-------------------------------------------------------------------------------
				-- State: error - Error recovery state
				-- Resets all state and returns to Vpause
				-------------------------------------------------------------------------------
				when others =>	--err_cycle
					lcd<=(rgb_black,cl);  -- Clear state
					adrBuffHi<='0';  -- Reset buffer selection
					adrBuff<=0;  -- Reset address
					mem_wr<='0';  -- Disable memory write
					YCC420stream<=(others=>'0');  -- Clear video data
					Hphase<=0;  -- Reset phase
					state<=Vpause;  -- Return to vertical pause
				
			end case;		
		end if;
	end process main_proc; 	
	
	-------------------------------------------------------------------------------
	-- Video Color Space Conversion Pipeline
	-- Converts YCbCr 4:2:0 (subsampled chroma) to RGB for display output
	--
	-- Pipeline: YCbCr 4:2:0 -> YCbCr 4:4:4 -> RGB
	--   - YCC420_to_YCC444div2: Expands chroma from 4:2:0 to 4:4:4 format
	--     (Chroma upsampling - duplicates Cb/Cr for every pixel)
	--   - ycc2rgb: Converts YCbCr to RGB using standard ITU-R BT.601 coefficients
	-------------------------------------------------------------------------------
	div2_ycc : entity work.YCC420_to_YCC444div2 
	port map(
		clock => pclk,                        -- Pixel clock (64.286 MHz)
		YCC420 => YCC420stream(47 downto 0), -- Input: YCbCr 4:2:0 (48-bit: 4 pixels)
		YCbCr => YCC444stream                 -- Output: YCbCr 4:4:4 (24-bit per pixel)
		);
	
	conv_ycc_to_rgb : entity work.ycc2rgb 
	port map (
		clock => pclk,        -- Pixel clock (64.286 MHz)
		YCbCr => YCC444stream, -- Input: YCbCr 4:4:4 (24-bit)
		RGB => RGBstream      -- Output: RGB 24-bit
		);
end main; 
