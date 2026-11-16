library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uprogALU is
    port(
        clk          : in  std_logic;
        btnC         : in  std_logic;                    -- reset button (middle of the five), active high
        FromBuss : in  unsigned(21 downto 0);
        styr_alu     : in  unsigned(3 downto 0);
        AR_out       : out unsigned(21 downto 0); 
        SR_out       : out unsigned(21 downto 0)         -- bit3=carry, bit2=overflow, bit1=sign, bit0=zero
    );
end entity;

architecture behavioral of uprogALU is
    signal AR : unsigned(21 downto 0) := (others => '0');
    signal SR : unsigned(3 downto 0) := (others => '0');
    -- Computation Variables
    signal res_full : unsigned(22 downto 0); -- 9 bits to capture carry out of MSB
    -- signal res   : unsigned(7 downto 0);
    -- Signal Flags
    signal carry    : std_logic;
    signal zero     : std_logic;
    signal sign     : std_logic;
    signal overflow : std_logic;
    type cos_lut_t is array (0 to 359) of signed(21 downto 0);
        constant cos_lut : cos_lut_t := (
            0 => to_signed( 511, 22),    -- cos(0°) = +1.000
            1 => to_signed( 511, 22),    -- cos(1°) = +1.000
            2 => to_signed( 511, 22),    -- cos(2°) = +0.999
            3 => to_signed( 510, 22),    -- cos(3°) = +0.999
            4 => to_signed( 510, 22),    -- cos(4°) = +0.998
            5 => to_signed( 509, 22),    -- cos(5°) = +0.996
            6 => to_signed( 508, 22),    -- cos(6°) = +0.995
            7 => to_signed( 507, 22),    -- cos(7°) = +0.993
            8 => to_signed( 506, 22),    -- cos(8°) = +0.990
            9 => to_signed( 505, 22),    -- cos(9°) = +0.988
           10 => to_signed( 503, 22),    -- cos(10°) = +0.985
           11 => to_signed( 502, 22),    -- cos(11°) = +0.982
           12 => to_signed( 500, 22),    -- cos(12°) = +0.978
           13 => to_signed( 498, 22),    -- cos(13°) = +0.974
           14 => to_signed( 496, 22),    -- cos(14°) = +0.970
           15 => to_signed( 494, 22),    -- cos(15°) = +0.966
           16 => to_signed( 491, 22),    -- cos(16°) = +0.961
           17 => to_signed( 489, 22),    -- cos(17°) = +0.956
           18 => to_signed( 486, 22),    -- cos(18°) = +0.951
           19 => to_signed( 483, 22),    -- cos(19°) = +0.946
           20 => to_signed( 480, 22),    -- cos(20°) = +0.940
           21 => to_signed( 477, 22),    -- cos(21°) = +0.934
           22 => to_signed( 474, 22),    -- cos(22°) = +0.927
           23 => to_signed( 470, 22),    -- cos(23°) = +0.921
           24 => to_signed( 467, 22),    -- cos(24°) = +0.914
           25 => to_signed( 463, 22),    -- cos(25°) = +0.906
           26 => to_signed( 459, 22),    -- cos(26°) = +0.899
           27 => to_signed( 455, 22),    -- cos(27°) = +0.891
           28 => to_signed( 451, 22),    -- cos(28°) = +0.883
           29 => to_signed( 447, 22),    -- cos(29°) = +0.875
           30 => to_signed( 443, 22),    -- cos(30°) = +0.866
           31 => to_signed( 438, 22),    -- cos(31°) = +0.857
           32 => to_signed( 433, 22),    -- cos(32°) = +0.848
           33 => to_signed( 429, 22),    -- cos(33°) = +0.839
           34 => to_signed( 424, 22),    -- cos(34°) = +0.829
           35 => to_signed( 419, 22),    -- cos(35°) = +0.819
           36 => to_signed( 413, 22),    -- cos(36°) = +0.809
           37 => to_signed( 408, 22),    -- cos(37°) = +0.799
           38 => to_signed( 403, 22),    -- cos(38°) = +0.788
           39 => to_signed( 397, 22),    -- cos(39°) = +0.777
           40 => to_signed( 391, 22),    -- cos(40°) = +0.766
           41 => to_signed( 386, 22),    -- cos(41°) = +0.755
           42 => to_signed( 380, 22),    -- cos(42°) = +0.743
           43 => to_signed( 374, 22),    -- cos(43°) = +0.731
           44 => to_signed( 368, 22),    -- cos(44°) = +0.719
           45 => to_signed( 361, 22),    -- cos(45°) = +0.707
           46 => to_signed( 355, 22),    -- cos(46°) = +0.695
           47 => to_signed( 349, 22),    -- cos(47°) = +0.682
           48 => to_signed( 342, 22),    -- cos(48°) = +0.669
           49 => to_signed( 335, 22),    -- cos(49°) = +0.656
           50 => to_signed( 328, 22),    -- cos(50°) = +0.643
           51 => to_signed( 322, 22),    -- cos(51°) = +0.629
           52 => to_signed( 315, 22),    -- cos(52°) = +0.616
           53 => to_signed( 308, 22),    -- cos(53°) = +0.602
           54 => to_signed( 300, 22),    -- cos(54°) = +0.588
           55 => to_signed( 293, 22),    -- cos(55°) = +0.574
           56 => to_signed( 286, 22),    -- cos(56°) = +0.559
           57 => to_signed( 278, 22),    -- cos(57°) = +0.545
           58 => to_signed( 271, 22),    -- cos(58°) = +0.530
           59 => to_signed( 263, 22),    -- cos(59°) = +0.515
           60 => to_signed( 256, 22),    -- cos(60°) = +0.500
           61 => to_signed( 248, 22),    -- cos(61°) = +0.485
           62 => to_signed( 240, 22),    -- cos(62°) = +0.469
           63 => to_signed( 232, 22),    -- cos(63°) = +0.454
           64 => to_signed( 224, 22),    -- cos(64°) = +0.438
           65 => to_signed( 216, 22),    -- cos(65°) = +0.423
           66 => to_signed( 208, 22),    -- cos(66°) = +0.407
           67 => to_signed( 200, 22),    -- cos(67°) = +0.391
           68 => to_signed( 191, 22),    -- cos(68°) = +0.375
           69 => to_signed( 183, 22),    -- cos(69°) = +0.358
           70 => to_signed( 175, 22),    -- cos(70°) = +0.342
           71 => to_signed( 166, 22),    -- cos(71°) = +0.326
           72 => to_signed( 158, 22),    -- cos(72°) = +0.309
           73 => to_signed( 149, 22),    -- cos(73°) = +0.292
           74 => to_signed( 141, 22),    -- cos(74°) = +0.276
           75 => to_signed( 132, 22),    -- cos(75°) = +0.259
           76 => to_signed( 124, 22),    -- cos(76°) = +0.242
           77 => to_signed( 115, 22),    -- cos(77°) = +0.225
           78 => to_signed( 106, 22),    -- cos(78°) = +0.208
           79 => to_signed(  98, 22),    -- cos(79°) = +0.191
           80 => to_signed(  89, 22),    -- cos(80°) = +0.174
           81 => to_signed(  80, 22),    -- cos(81°) = +0.156
           82 => to_signed(  71, 22),    -- cos(82°) = +0.139
           83 => to_signed(  62, 22),    -- cos(83°) = +0.122
           84 => to_signed(  53, 22),    -- cos(84°) = +0.105
           85 => to_signed(  45, 22),    -- cos(85°) = +0.087
           86 => to_signed(  36, 22),    -- cos(86°) = +0.070
           87 => to_signed(  27, 22),    -- cos(87°) = +0.052
           88 => to_signed(  18, 22),    -- cos(88°) = +0.035
           89 => to_signed(   9, 22),    -- cos(89°) = +0.017
           90 => to_signed(   0, 22),    -- cos(90°) = +0.000
           91 => to_signed(  -9, 22),    -- cos(91°) = -0.017
           92 => to_signed( -18, 22),    -- cos(92°) = -0.035
           93 => to_signed( -27, 22),    -- cos(93°) = -0.052
           94 => to_signed( -36, 22),    -- cos(94°) = -0.070
           95 => to_signed( -45, 22),    -- cos(95°) = -0.087
           96 => to_signed( -53, 22),    -- cos(96°) = -0.105
           97 => to_signed( -62, 22),    -- cos(97°) = -0.122
           98 => to_signed( -71, 22),    -- cos(98°) = -0.139
           99 => to_signed( -80, 22),    -- cos(99°) = -0.156
          100 => to_signed( -89, 22),    -- cos(100°) = -0.174
          101 => to_signed( -98, 22),    -- cos(101°) = -0.191
          102 => to_signed(-106, 22),    -- cos(102°) = -0.208
          103 => to_signed(-115, 22),    -- cos(103°) = -0.225
          104 => to_signed(-124, 22),    -- cos(104°) = -0.242
          105 => to_signed(-132, 22),    -- cos(105°) = -0.259
          106 => to_signed(-141, 22),    -- cos(106°) = -0.276
          107 => to_signed(-149, 22),    -- cos(107°) = -0.292
          108 => to_signed(-158, 22),    -- cos(108°) = -0.309
          109 => to_signed(-166, 22),    -- cos(109°) = -0.326
          110 => to_signed(-175, 22),    -- cos(110°) = -0.342
          111 => to_signed(-183, 22),    -- cos(111°) = -0.358
          112 => to_signed(-191, 22),    -- cos(112°) = -0.375
          113 => to_signed(-200, 22),    -- cos(113°) = -0.391
          114 => to_signed(-208, 22),    -- cos(114°) = -0.407
          115 => to_signed(-216, 22),    -- cos(115°) = -0.423
          116 => to_signed(-224, 22),    -- cos(116°) = -0.438
          117 => to_signed(-232, 22),    -- cos(117°) = -0.454
          118 => to_signed(-240, 22),    -- cos(118°) = -0.469
          119 => to_signed(-248, 22),    -- cos(119°) = -0.485
          120 => to_signed(-255, 22),    -- cos(120°) = -0.500
          121 => to_signed(-263, 22),    -- cos(121°) = -0.515
          122 => to_signed(-271, 22),    -- cos(122°) = -0.530
          123 => to_signed(-278, 22),    -- cos(123°) = -0.545
          124 => to_signed(-286, 22),    -- cos(124°) = -0.559
          125 => to_signed(-293, 22),    -- cos(125°) = -0.574
          126 => to_signed(-300, 22),    -- cos(126°) = -0.588
          127 => to_signed(-308, 22),    -- cos(127°) = -0.602
          128 => to_signed(-315, 22),    -- cos(128°) = -0.616
          129 => to_signed(-322, 22),    -- cos(129°) = -0.629
          130 => to_signed(-328, 22),    -- cos(130°) = -0.643
          131 => to_signed(-335, 22),    -- cos(131°) = -0.656
          132 => to_signed(-342, 22),    -- cos(132°) = -0.669
          133 => to_signed(-349, 22),    -- cos(133°) = -0.682
          134 => to_signed(-355, 22),    -- cos(134°) = -0.695
          135 => to_signed(-361, 22),    -- cos(135°) = -0.707
          136 => to_signed(-368, 22),    -- cos(136°) = -0.719
          137 => to_signed(-374, 22),    -- cos(137°) = -0.731
          138 => to_signed(-380, 22),    -- cos(138°) = -0.743
          139 => to_signed(-386, 22),    -- cos(139°) = -0.755
          140 => to_signed(-391, 22),    -- cos(140°) = -0.766
          141 => to_signed(-397, 22),    -- cos(141°) = -0.777
          142 => to_signed(-403, 22),    -- cos(142°) = -0.788
          143 => to_signed(-408, 22),    -- cos(143°) = -0.799
          144 => to_signed(-413, 22),    -- cos(144°) = -0.809
          145 => to_signed(-419, 22),    -- cos(145°) = -0.819
          146 => to_signed(-424, 22),    -- cos(146°) = -0.829
          147 => to_signed(-429, 22),    -- cos(147°) = -0.839
          148 => to_signed(-433, 22),    -- cos(148°) = -0.848
          149 => to_signed(-438, 22),    -- cos(149°) = -0.857
          150 => to_signed(-443, 22),    -- cos(150°) = -0.866
          151 => to_signed(-447, 22),    -- cos(151°) = -0.875
          152 => to_signed(-451, 22),    -- cos(152°) = -0.883
          153 => to_signed(-455, 22),    -- cos(153°) = -0.891
          154 => to_signed(-459, 22),    -- cos(154°) = -0.899
          155 => to_signed(-463, 22),    -- cos(155°) = -0.906
          156 => to_signed(-467, 22),    -- cos(156°) = -0.914
          157 => to_signed(-470, 22),    -- cos(157°) = -0.921
          158 => to_signed(-474, 22),    -- cos(158°) = -0.927
          159 => to_signed(-477, 22),    -- cos(159°) = -0.934
          160 => to_signed(-480, 22),    -- cos(160°) = -0.940
          161 => to_signed(-483, 22),    -- cos(161°) = -0.946
          162 => to_signed(-486, 22),    -- cos(162°) = -0.951
          163 => to_signed(-489, 22),    -- cos(163°) = -0.956
          164 => to_signed(-491, 22),    -- cos(164°) = -0.961
          165 => to_signed(-494, 22),    -- cos(165°) = -0.966
          166 => to_signed(-496, 22),    -- cos(166°) = -0.970
          167 => to_signed(-498, 22),    -- cos(167°) = -0.974
          168 => to_signed(-500, 22),    -- cos(168°) = -0.978
          169 => to_signed(-502, 22),    -- cos(169°) = -0.982
          170 => to_signed(-503, 22),    -- cos(170°) = -0.985
          171 => to_signed(-505, 22),    -- cos(171°) = -0.988
          172 => to_signed(-506, 22),    -- cos(172°) = -0.990
          173 => to_signed(-507, 22),    -- cos(173°) = -0.993
          174 => to_signed(-508, 22),    -- cos(174°) = -0.995
          175 => to_signed(-509, 22),    -- cos(175°) = -0.996
          176 => to_signed(-510, 22),    -- cos(176°) = -0.998
          177 => to_signed(-510, 22),    -- cos(177°) = -0.999
          178 => to_signed(-511, 22),    -- cos(178°) = -0.999
          179 => to_signed(-511, 22),    -- cos(179°) = -1.000
          180 => to_signed(-511, 22),    -- cos(180°) = -1.000
          181 => to_signed(-511, 22),    -- cos(181°) = -1.000
          182 => to_signed(-511, 22),    -- cos(182°) = -0.999
          183 => to_signed(-510, 22),    -- cos(183°) = -0.999
          184 => to_signed(-510, 22),    -- cos(184°) = -0.998
          185 => to_signed(-509, 22),    -- cos(185°) = -0.996
          186 => to_signed(-508, 22),    -- cos(186°) = -0.995
          187 => to_signed(-507, 22),    -- cos(187°) = -0.993
          188 => to_signed(-506, 22),    -- cos(188°) = -0.990
          189 => to_signed(-505, 22),    -- cos(189°) = -0.988
          190 => to_signed(-503, 22),    -- cos(190°) = -0.985
          191 => to_signed(-502, 22),    -- cos(191°) = -0.982
          192 => to_signed(-500, 22),    -- cos(192°) = -0.978
          193 => to_signed(-498, 22),    -- cos(193°) = -0.974
          194 => to_signed(-496, 22),    -- cos(194°) = -0.970
          195 => to_signed(-494, 22),    -- cos(195°) = -0.966
          196 => to_signed(-491, 22),    -- cos(196°) = -0.961
          197 => to_signed(-489, 22),    -- cos(197°) = -0.956
          198 => to_signed(-486, 22),    -- cos(198°) = -0.951
          199 => to_signed(-483, 22),    -- cos(199°) = -0.946
          200 => to_signed(-480, 22),    -- cos(200°) = -0.940
          201 => to_signed(-477, 22),    -- cos(201°) = -0.934
          202 => to_signed(-474, 22),    -- cos(202°) = -0.927
          203 => to_signed(-470, 22),    -- cos(203°) = -0.921
          204 => to_signed(-467, 22),    -- cos(204°) = -0.914
          205 => to_signed(-463, 22),    -- cos(205°) = -0.906
          206 => to_signed(-459, 22),    -- cos(206°) = -0.899
          207 => to_signed(-455, 22),    -- cos(207°) = -0.891
          208 => to_signed(-451, 22),    -- cos(208°) = -0.883
          209 => to_signed(-447, 22),    -- cos(209°) = -0.875
          210 => to_signed(-443, 22),    -- cos(210°) = -0.866
          211 => to_signed(-438, 22),    -- cos(211°) = -0.857
          212 => to_signed(-433, 22),    -- cos(212°) = -0.848
          213 => to_signed(-429, 22),    -- cos(213°) = -0.839
          214 => to_signed(-424, 22),    -- cos(214°) = -0.829
          215 => to_signed(-419, 22),    -- cos(215°) = -0.819
          216 => to_signed(-413, 22),    -- cos(216°) = -0.809
          217 => to_signed(-408, 22),    -- cos(217°) = -0.799
          218 => to_signed(-403, 22),    -- cos(218°) = -0.788
          219 => to_signed(-397, 22),    -- cos(219°) = -0.777
          220 => to_signed(-391, 22),    -- cos(220°) = -0.766
          221 => to_signed(-386, 22),    -- cos(221°) = -0.755
          222 => to_signed(-380, 22),    -- cos(222°) = -0.743
          223 => to_signed(-374, 22),    -- cos(223°) = -0.731
          224 => to_signed(-368, 22),    -- cos(224°) = -0.719
          225 => to_signed(-361, 22),    -- cos(225°) = -0.707
          226 => to_signed(-355, 22),    -- cos(226°) = -0.695
          227 => to_signed(-349, 22),    -- cos(227°) = -0.682
          228 => to_signed(-342, 22),    -- cos(228°) = -0.669
          229 => to_signed(-335, 22),    -- cos(229°) = -0.656
          230 => to_signed(-328, 22),    -- cos(230°) = -0.643
          231 => to_signed(-322, 22),    -- cos(231°) = -0.629
          232 => to_signed(-315, 22),    -- cos(232°) = -0.616
          233 => to_signed(-308, 22),    -- cos(233°) = -0.602
          234 => to_signed(-300, 22),    -- cos(234°) = -0.588
          235 => to_signed(-293, 22),    -- cos(235°) = -0.574
          236 => to_signed(-286, 22),    -- cos(236°) = -0.559
          237 => to_signed(-278, 22),    -- cos(237°) = -0.545
          238 => to_signed(-271, 22),    -- cos(238°) = -0.530
          239 => to_signed(-263, 22),    -- cos(239°) = -0.515
          240 => to_signed(-256, 22),    -- cos(240°) = -0.500
          241 => to_signed(-248, 22),    -- cos(241°) = -0.485
          242 => to_signed(-240, 22),    -- cos(242°) = -0.469
          243 => to_signed(-232, 22),    -- cos(243°) = -0.454
          244 => to_signed(-224, 22),    -- cos(244°) = -0.438
          245 => to_signed(-216, 22),    -- cos(245°) = -0.423
          246 => to_signed(-208, 22),    -- cos(246°) = -0.407
          247 => to_signed(-200, 22),    -- cos(247°) = -0.391
          248 => to_signed(-191, 22),    -- cos(248°) = -0.375
          249 => to_signed(-183, 22),    -- cos(249°) = -0.358
          250 => to_signed(-175, 22),    -- cos(250°) = -0.342
          251 => to_signed(-166, 22),    -- cos(251°) = -0.326
          252 => to_signed(-158, 22),    -- cos(252°) = -0.309
          253 => to_signed(-149, 22),    -- cos(253°) = -0.292
          254 => to_signed(-141, 22),    -- cos(254°) = -0.276
          255 => to_signed(-132, 22),    -- cos(255°) = -0.259
          256 => to_signed(-124, 22),    -- cos(256°) = -0.242
          257 => to_signed(-115, 22),    -- cos(257°) = -0.225
          258 => to_signed(-106, 22),    -- cos(258°) = -0.208
          259 => to_signed( -98, 22),    -- cos(259°) = -0.191
          260 => to_signed( -89, 22),    -- cos(260°) = -0.174
          261 => to_signed( -80, 22),    -- cos(261°) = -0.156
          262 => to_signed( -71, 22),    -- cos(262°) = -0.139
          263 => to_signed( -62, 22),    -- cos(263°) = -0.122
          264 => to_signed( -53, 22),    -- cos(264°) = -0.105
          265 => to_signed( -45, 22),    -- cos(265°) = -0.087
          266 => to_signed( -36, 22),    -- cos(266°) = -0.070
          267 => to_signed( -27, 22),    -- cos(267°) = -0.052
          268 => to_signed( -18, 22),    -- cos(268°) = -0.035
          269 => to_signed(  -9, 22),    -- cos(269°) = -0.017
          270 => to_signed(   0, 22),    -- cos(270°) = -0.000
          271 => to_signed(   9, 22),    -- cos(271°) = +0.017
          272 => to_signed(  18, 22),    -- cos(272°) = +0.035
          273 => to_signed(  27, 22),    -- cos(273°) = +0.052
          274 => to_signed(  36, 22),    -- cos(274°) = +0.070
          275 => to_signed(  45, 22),    -- cos(275°) = +0.087
          276 => to_signed(  53, 22),    -- cos(276°) = +0.105
          277 => to_signed(  62, 22),    -- cos(277°) = +0.122
          278 => to_signed(  71, 22),    -- cos(278°) = +0.139
          279 => to_signed(  80, 22),    -- cos(279°) = +0.156
          280 => to_signed(  89, 22),    -- cos(280°) = +0.174
          281 => to_signed(  98, 22),    -- cos(281°) = +0.191
          282 => to_signed( 106, 22),    -- cos(282°) = +0.208
          283 => to_signed( 115, 22),    -- cos(283°) = +0.225
          284 => to_signed( 124, 22),    -- cos(284°) = +0.242
          285 => to_signed( 132, 22),    -- cos(285°) = +0.259
          286 => to_signed( 141, 22),    -- cos(286°) = +0.276
          287 => to_signed( 149, 22),    -- cos(287°) = +0.292
          288 => to_signed( 158, 22),    -- cos(288°) = +0.309
          289 => to_signed( 166, 22),    -- cos(289°) = +0.326
          290 => to_signed( 175, 22),    -- cos(290°) = +0.342
          291 => to_signed( 183, 22),    -- cos(291°) = +0.358
          292 => to_signed( 191, 22),    -- cos(292°) = +0.375
          293 => to_signed( 200, 22),    -- cos(293°) = +0.391
          294 => to_signed( 208, 22),    -- cos(294°) = +0.407
          295 => to_signed( 216, 22),    -- cos(295°) = +0.423
          296 => to_signed( 224, 22),    -- cos(296°) = +0.438
          297 => to_signed( 232, 22),    -- cos(297°) = +0.454
          298 => to_signed( 240, 22),    -- cos(298°) = +0.469
          299 => to_signed( 248, 22),    -- cos(299°) = +0.485
          300 => to_signed( 256, 22),    -- cos(300°) = +0.500
          301 => to_signed( 263, 22),    -- cos(301°) = +0.515
          302 => to_signed( 271, 22),    -- cos(302°) = +0.530
          303 => to_signed( 278, 22),    -- cos(303°) = +0.545
          304 => to_signed( 286, 22),    -- cos(304°) = +0.559
          305 => to_signed( 293, 22),    -- cos(305°) = +0.574
          306 => to_signed( 300, 22),    -- cos(306°) = +0.588
          307 => to_signed( 308, 22),    -- cos(307°) = +0.602
          308 => to_signed( 315, 22),    -- cos(308°) = +0.616
          309 => to_signed( 322, 22),    -- cos(309°) = +0.629
          310 => to_signed( 328, 22),    -- cos(310°) = +0.643
          311 => to_signed( 335, 22),    -- cos(311°) = +0.656
          312 => to_signed( 342, 22),    -- cos(312°) = +0.669
          313 => to_signed( 349, 22),    -- cos(313°) = +0.682
          314 => to_signed( 355, 22),    -- cos(314°) = +0.695
          315 => to_signed( 361, 22),    -- cos(315°) = +0.707
          316 => to_signed( 368, 22),    -- cos(316°) = +0.719
          317 => to_signed( 374, 22),    -- cos(317°) = +0.731
          318 => to_signed( 380, 22),    -- cos(318°) = +0.743
          319 => to_signed( 386, 22),    -- cos(319°) = +0.755
          320 => to_signed( 391, 22),    -- cos(320°) = +0.766
          321 => to_signed( 397, 22),    -- cos(321°) = +0.777
          322 => to_signed( 403, 22),    -- cos(322°) = +0.788
          323 => to_signed( 408, 22),    -- cos(323°) = +0.799
          324 => to_signed( 413, 22),    -- cos(324°) = +0.809
          325 => to_signed( 419, 22),    -- cos(325°) = +0.819
          326 => to_signed( 424, 22),    -- cos(326°) = +0.829
          327 => to_signed( 429, 22),    -- cos(327°) = +0.839
          328 => to_signed( 433, 22),    -- cos(328°) = +0.848
          329 => to_signed( 438, 22),    -- cos(329°) = +0.857
          330 => to_signed( 443, 22),    -- cos(330°) = +0.866
          331 => to_signed( 447, 22),    -- cos(331°) = +0.875
          332 => to_signed( 451, 22),    -- cos(332°) = +0.883
          333 => to_signed( 455, 22),    -- cos(333°) = +0.891
          334 => to_signed( 459, 22),    -- cos(334°) = +0.899
          335 => to_signed( 463, 22),    -- cos(335°) = +0.906
          336 => to_signed( 467, 22),    -- cos(336°) = +0.914
          337 => to_signed( 470, 22),    -- cos(337°) = +0.921
          338 => to_signed( 474, 22),    -- cos(338°) = +0.927
          339 => to_signed( 477, 22),    -- cos(339°) = +0.934
          340 => to_signed( 480, 22),    -- cos(340°) = +0.940
          341 => to_signed( 483, 22),    -- cos(341°) = +0.946
          342 => to_signed( 486, 22),    -- cos(342°) = +0.951
          343 => to_signed( 489, 22),    -- cos(343°) = +0.956
          344 => to_signed( 491, 22),    -- cos(344°) = +0.961
          345 => to_signed( 494, 22),    -- cos(345°) = +0.966
          346 => to_signed( 496, 22),    -- cos(346°) = +0.970
          347 => to_signed( 498, 22),    -- cos(347°) = +0.974
          348 => to_signed( 500, 22),    -- cos(348°) = +0.978
          349 => to_signed( 502, 22),    -- cos(349°) = +0.982
          350 => to_signed( 503, 22),    -- cos(350°) = +0.985
          351 => to_signed( 505, 22),    -- cos(351°) = +0.988
          352 => to_signed( 506, 22),    -- cos(352°) = +0.990
          353 => to_signed( 507, 22),    -- cos(353°) = +0.993
          354 => to_signed( 508, 22),    -- cos(354°) = +0.995
          355 => to_signed( 509, 22),    -- cos(355°) = +0.996
          356 => to_signed( 510, 22),    -- cos(356°) = +0.998
          357 => to_signed( 510, 22),    -- cos(357°) = +0.999
          358 => to_signed( 511, 22),    -- cos(358°) = +0.999
          359 => to_signed( 511, 22)     -- cos(359°) = +1.000
      
        );
begin   

    res_full <= '0' & AR when styr_alu = "0000" else
          ('0' & AR) + ('0' & FromBuss) when styr_alu = "0001" else                              -- ADD
          ('0' & AR) - ('0' & FromBuss) when styr_alu = "0010" else                              -- SUB
          '0' & (AR and  FromBuss) when styr_alu = "0011" else                                   -- AND
          '0' & (AR or   FromBuss) when styr_alu = "0100" else                                   -- OR
          '0' & (AR xor  FromBuss) when styr_alu = "0101" else                                   -- XOR
          '0' & (not AR) when styr_alu = "0110" else                                             -- NOT
          '0' & FromBuss when styr_alu = "0111" else                                             -- Load From Buss
          (others => '0') when styr_alu = "1000" else                                            -- 0
          '0' & AR(20 downto 0) & '0' when styr_alu = "1001" else                                -- left shift, no carry bleed                                                                    -- Left Shift
          AR(0) & '0' & AR(21 downto 1) when styr_alu = "1010" else                              -- Logic Right Shift
          AR(0) & AR(21) & AR(21 downto 1) when styr_alu = "1011" else                           -- Arithmetic Right Shift
          '0' & unsigned(cos_lut(to_integer(((AR mod 360) + 360) mod 360))) when styr_alu = "1100" else       -- Cos
          '0' & unsigned(cos_lut(to_integer(((AR + 270) mod 360 + 360) mod 360))) when styr_alu = "1101" else  -- Sin
          resize(AR * FromBuss, 23) when styr_alu = "1110" else                                  -- MULT (low 22 bits + carry=0)                              -- MULT
          '0' & AR;
    
    carry <= res_full(22);
    zero <= '1' when res_full(21 downto 0) = 0 else '0';
    sign <= res_full(21);
    overflow <=
        (not AR(21) and not FromBuss(21) and res_full(21))       -- pos+pos=neg
        or (AR(21) and FromBuss(21) and not res_full(21))        -- neg+neg=pos
        when styr_alu = "0001" else                              -- ADD

        (not AR(21) and FromBuss(21) and res_full(21))           -- pos-neg=neg
        or (AR(21) and not FromBuss(21) and not res_full(21))    -- neg-pos=pos
        when styr_alu = "0010" else                              -- SUB
        '0';
    
    process(clk)
    begin
        if rising_edge(clk) then
            if btnC = '1' then
                AR <= (others => '0');
                SR <= (others => '0');
            else
                AR <= res_full(21 downto 0);
                SR(0) <= zero;      -- zero flag
                SR(1) <= sign;      -- negative flag
                SR(2) <= overflow;  -- overflow flag
                SR(3) <= carry;     -- carry flag

            end if;
        end if;
    end process;
    
    AR_out <= AR;
    SR_out <= (21 downto 4 => '0') & SR;

end behavioral;