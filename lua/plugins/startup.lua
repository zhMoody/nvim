local startup = requirePlugin "dashboard"
if not startup then
  vim.notify "Cannot find dashboard"
  return
end

startup.setup {
  theme = "doom",
  config = {
    -- header = {
    --     [[]],
    --     [[]],
    --     [[]],
    --     [[]],
    --     [[                          :;+S@#%%%%%%%%%SSSSSS%*;*##+                                                   ]],
    --     [[                      :+*?%%SSSS%%%%%%%%%%%%%%%SSSSSSS##?+:                                              ]],
    --     [[                 :+?%SSS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SS%?+                                            ]],
    --     [[                 +%SSS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%S%*:                                       ]],
    --     [[              :?SS%%%%%%%%%%%%%%%%%%%%%%%%%%SS%%%%%%%%%%%%%%%%%%%S%%+                                    ]],
    --     [[             ?SS%%%%%%%%%%%%%%%%%%%%%%%%%%?*++*??%%%%%%%%???%%%%%%%%SS*:                                 ]],
    --     [[           ;%S%%%%%%%%%%%%%%%%%??%%%%%%%+:,,,,,,:+?S%%%?+;:,,:+?%%%%%%SS?:                               ]],
    --     [[          ;%%%%%%%%%%%%%%%%%%?**?%%%%%?:,,,::;;;;:,;%S;,,::;::::*S%%%%%%SS+                              ]],
    --     [[         +%%%%%%%%%%%%%%%*?%%%%%%%%%%%+:;;;;::,,,,,,*S,...,,,:::+S%%%%%%%%#%:                            ]],
    --     [[        :%%%%%%%%%%%%%%++*%%%%%%%%%%%%+,,,,,,,,,,,:,+%,,++;:,,,,:S%%%%%%%%%#S:                           ]],
    --     [[       :?%%%%%%%%%%%%%%?%%%%%%%%%%%%SS?:.,,,,,,:%?+:+*::;*%;,,,,+S%%%%%%%%%%#S:                          ]],
    --     [[       *%%%%%%%%%%%%%%%%%%%%%???*++;;;;+;:s,s,,,::;;;*%?*+;,,,:+:,,:+*?%%%%%%#%                          ]],
    --     [[      ;%%?%%%%%%%%%%%%%%%?+;:,,,,,,,,,,,:;+;;:;;;;:+S%%%%%%?;::,,,,,,,,+%SSSSS@+                         ]],
    --     [[      ?%?%%%%%%%%%%%%%%*;::::,,,,,,,,,,,,,,,,,,,,,:%S;*%%%%%;,,,,,,,,,,,:;?S%?#?                         ]],
    --     [[     :?%?%%%%%%%SSSSS?+:;;:::,,,,,,,,,,,,,,,,,,,,,,;%S%%%%S?:,,,,,,,,,,,,,,+S%%S                         ]],
    --     [[     ;%%%%%%%%S%%%%*:,.,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;*%?+;,,,,,,,,,,,,,,:;;*#SS                         ]],
    --     [[     ;%?%%%%%%%%%?:,:;;;;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;:.,,,,,,,,,,,,,,,,,,,*@%                         ]],
    --     [[     ;%%%%%%%%%SS;;*+::,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:;:,,,,,,,,,,,,,,,,,,,.+@%                         ]],
    --     [[     ;%%%%%%%%SS+:,,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,;;,,,,,,,,,,,,,,,,,,::,*@%                         ]],
    --     [[     :%%?%%SS%S;.,..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,+:,,,,,,,,,,,,,,,,,,,:+S@?                         ]],
    --     [[      ?S??%%%S*,,,,;;;,,,,,,,.,,,,,:::;;;;;;;;;;;::,,:;,.,,,,,,,,,,,,,,,,,,.;@#:                         ]],
    --     [[      +S??%%%S;,:++;,,,..,,:;+*?%%SSSSSSSSSSSSSSSSS%%%*+:,,,,,,,,,,,,,,,,,,,*#;                          ]],
    --     [[       %S?%%%%+++:,,,,,;+?%SSSSSSSSSSSSSSSSSSSSSSSSSSSSSS%?+:,,,,,,,,,,,,,.:S;                           ]],
    --     [[       ;S%?%%#+,,,,,;?SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS?+,,,,,,,,,,,:%+                            ]],
    --     [[        +#S%SS;,,,:?##SSSSS%%SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS%:,,,,,,,,:S:                             ]],
    --     [[         *#S?%?,,:%#%%???******???%SSSSSSSSSSSSSSSSSSSSSSSSSSS%#*,,,,,,,S;                               ]],
    --     [[        :%SS#%%*,;#?****************??*??%SSSSSSSSSSSSSSSSSSSSS#+,,,,,:S:                                ]],
    --     [[       ;?%?%%SS#*,?S**********************?%SSSSSSSSSSSSSSSSSSS+,,,,:S:                                  ]],
    --     [[      +%%%%%%%%S@?;*%??%?**************???*?%SSSSSSSSSSSSSSSS*:,,,:S:                                    ]],
    --     [[     *%%%%%%%%%%S##?++?%S?*************?***?*%SSSSSSSSSSSS%+:,,:S:                                       ]],
    --     [[   :?%%S%%%%%%%%%%%SS%?*?%?****************?*?SSSSSSSS%?+:,:;;:                                          ]],
    --     [[   ?%?%S%%%%%%%%%%%%%S?*%S%****************???%S%??+;;:;+?%#*                                            ]],
    --     [[  *S?%%S%?%%%%%%%%%%%%;.,:*?***************???S?++*?????+;%#+                                            ]],
    --     [[ ;S?%%%SS?%%%%%%%%%%%%+.,,:*?***********?****?%??**+;:,,.:SS;                                            ]],
    --     [[ ?%?%%%%S%?%%%%%%%%%%%?:,,,,+*?***********??*;,,...,.,,,,+#S;                                            ]],
    --     [[;S?%%%%%SS%?%%%%%%%%%?%S*;++;;*%%%??????%S?;::,,::::::;;;;;;:,,,                                         ]],
    --     [[+%?%%%%%%SS%?%%%%%%%SSS#%,,::::;+++*******;;;;;;;;;??;:,,,,.,,,,:,                                       ]],
    --     [[*%?%%%%%%%%SSS%*++;:;;+?%+,.,,,,....,,,...,,,,,,,;;:,.,,,,,,,,,,,,:,                                     ]],
    --     [[?%%%%%%%%%%?*;,,,,,,,,,.,;+;,,,,,,,,,,,,,,,,,,,,++,.,,,,,,,,,,,,,,,:                                     ]],
    --     [[*%?%%%%%%%*:,.,,,,,,,,,,,.,++,.,,,,,,,,,,,,,,,,+;.,,,,,,,,,,,,,,,,,::                                    ]],
    --     [[+%?%%%%%%*,.,,,,,,,,,,,,,,,,++:,,,,,,,,,,,::::?;.,,,,,,,,,,,,,,,,,,:;                                    ]],
    --     [[;S?%%%%%*,.,,,,,,,,,,,,,,,,,,*+:;::;;;;;;:::,:?:,,,,,,,,,,,,,,,,,,,;;                                    ]],
    --     [[ ?S?%%%%;,,,,,,,,,,,,,,,,,,,.++.............,;*,,,,,,,,,,,,,,,,,,.;?                                     ]],
    --     [[ ;#%??%?:.,,,,,,,,,,,,,,,,,,,+%;;::::;;;++**?S*,,,,,,,,,,,,,,,,,,;%:                                     ]],
    --     [[  ;SS?%?:.,,,,,,,,,,,,,,,,,,,*#%%S%%%%%%%%%%?%%:,,,,,,,,,,,,,,.,*%:                                      ]],
    --     [[   :?SS%;,,,,,,,,,,,,,,,,,,,:S%??%%%%%%%%%SSS%SS+,.,,,,,,,,.,:*?+                                        ]],
    --     [[     :+%S+,.,,,,,,,,,,,,,,,,?#%SS%%%????**++++++%%+:,,,,,::+**;                                          ]],
    --     [[        :**:,.,,,,,,,,,,.,:%#?+;:                :+*++;++*+;                                             ]],
    --     [[          :++;:,,,.,,,,:;?%*                                                                             ]],
    --     [[             ;**++++++*?*;                                                                               ]],
    -- },
    header = {
      [[]],
      [[]],
     [[                                                                         ]],
     [[                                                                         ]],
     [[                       :---:                                             ]],
     [[                      -+***+=:                                           ]],
     [[                     -**###**+:                                          ]],
     [[                     -###+*##*-                                          ]],
     [[                     :*#*-+##*:                                          ]],
     [[                      :---==+:                                           ]],
     [[                    :=*=====:                                            ]],
     [[                  ::#%@*===*-                                            ]],
     [[                -*#-#@@%+=*%%-:                                          ]],
     [[                *%%+*@@@@%@%%=*-                                         ]],
     [[               *%%@*+@@%@@@%%=#%*-                                       ]],
     [[              =%%%@#+@@%%@@%%=%%%%-                                      ]],
     [[             =%%%%@#+@@@%%@%#=%@@@*:                                     ]],
     [[            =%@%%%@#*@@@@%%%#+@@@%%#=:                                   ]],
     [[           =%@%@@@@**@@@@@#@**@@@%%@@+::::                               ]],
     [[         :+%@@@%@@@+*@@@@@%@+%%*%@@@%%%#**++-:                           ]],
     [[        :*@@@%++@@@=#@@@@@@%+@* :=#%@@@%##%#*-                           ]],
     [[       -%@@%+:-%@@%=%@@@@@@*#%:   :-+##+=-==+-  :                        ]],
     [[      =%@@#:  *@@@#=@@@@@@%*%-       -===-=+=-: :                        ]],
     [[     -%@@*   -%@@@*+@@@@@@#*-       :========-::                         ]],
     [[   :#@#:      +##*#**#**##*:         :+**+++++-                          ]],
     [[   -%%-       +************-          =******=                           ]],
     [[  :-==       :+*+**********:           =****=: :::                       ]],
     [[: :-::        -+++******++++:          ::   ::::::                       ]],
     [[:::::         =+++*****+++++=:        ::::::::::::                       ]],
     [[::::         :=+==+**##**++++-        ::::::::::::                       ]],
     [[:::::        :====++-:*#****++:    :::::::::::::::                       ]],
     [[::::::        :====+-  :*****++=   :::::::::::::::                       ]],
     [[:::::::       :====+:   -***++++:  :::::::::::::::                       ]],
     [[::::::::: :::: ====+-    -***+++-   ::::::::::::::                       ]],
     [[:::::::::: ::: -===+-     -***+++: :::::::::::::::                       ]],
     [[::::::::::: :: -===+=       =#*+++- ::::::::::::::                       ]],
     [[::::::::::::   -+++++      :+***+=: ::::::::::::::                       ]],
     [[:::::::::::::  =++**-      -****+: :::::::::::::::                       ]],
     [[:::::::::::::: =+**+   ::  :****+:::::::::::::::::                       ]],
     [[-::::--::::::::-+**+ ::::: :***#= ::::::::::::::::                       ]],
     [[:::::::::::::::=+**= ::  : -****- ::::::::::::::::                       ]],
     [[::-------------=+**=:::::::=****::::::::::::::::::                       ]],
     [[----------------+**=-------+**#+------------------                       ]],
     [[----------------+**--------+***=------------------                       ]],
     [[----------------***--------+***-------------------                       ]],
     [[----------------+*+--------***=:------------------                       ]],
     [[]],
     [[]],
    },
    -- header = {
    --   [[]],
    --   [[]],
    --   [[]],
    --   [[]],
    --   [[]],
    --   [[]],
    --   [[        ▄▄▄▄▄███████████████████▄▄▄▄▄      ]],
    --   [[      ▄██████████▀▀▀▀▀▀▀▀▀▀██████▀████▄    ]],
    --   [[     █▀████████▄             ▀▀████ ▀██▄   ]],
    --   [[    █▄▄██████████████████▄▄▄         ▄██▀  ]],
    --   [[     ▀█████████████████████████▄    ▄██▀   ]],
    --   [[       ▀████▀▀▀▀▀▀▀▀▀▀▀▀█████████▄▄██▀     ]],
    --   [[         ▀███▄              ▀██████▀       ]],
    --   [[           ▀██████▄        ▄████▀          ]],
    --   [[              ▀█████▄▄▄▄▄▄▄███▀            ]],
    --   [[                ▀████▀▀▀████▀              ]],
    --   [[                  ▀███▄███▀                ]],
    --   [[                     ▀█▀                   ]],
    --   [[]],
    --   [[]],
    -- },

    -- header = {
    --       [[]],
    --       [[]],
    --       [[]],
    --       [[]],
    --       [[]],
    --       [[]],
    --       [[                     _oo0oo_                    ]],
    --       [[                    o8888888o                   ]],
    --       [[                    88"   "88                   ]],
    --       [[                    (| -_- |)                   ]],
    --       [[                    0\  =  /0                   ]],
    --       [[                  ___/`---'\___                 ]],
    --       [[                 ' \\|     |// '                ]],
    --       [[               / \\|||  :  |||// \              ]],
    --       [[              / _||||| -:- |||||- \             ]],
    --       [[             |   | \\\  - /// |   |             ]],
    --       [[             | \_|  ''\---/''  |_/ |            ]],
    --       [[             \   -\__  '-'  ___/-  /            ]],
    --       [[           ___'   '  /-- --\  `   '___          ]],
    --       [[         "" '<  ` ___\_<|>_/___ ' >' ""         ]],
    --       [[       | | :  `- \` ;`\ _ /`; `/ - ` : | |      ]],
    --       [[       \  \ `_    \_ __\ /__ _/    -` /  /      ]],
    --       [[   =====`- ____` ___ \_____/___ -`___ -'=====   ]],
    --       [[                     `=---='                    ]],
    --       [[]],
    --       [[  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ]],
    --       [[      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       ]],
    --       [[          ~~~~~~~~~~~~~~~~~~~~~~~~~             ]],
    --       [[]],
    --       [[       佛祖保佑     永不宕机     永无BUG        ]],
    --       [[]],
    --       [[]],
    --   },
    center = {
      {
        icon = "  ",
        desc = "Projects                            ",
        action = "Telescope projects",
      },
    },
    footer = {},
  },
}
