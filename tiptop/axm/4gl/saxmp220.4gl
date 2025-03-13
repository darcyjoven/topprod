# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: axmp220.4gl
# Descriptions...: 出通單整批處理作業
# Date & Author..: No.TQC-730022 07/03/19 By rainy
# Modify.........: NO.TQC-740217 07/04/23 BY yiting 未確認單據執行拋轉，不成功應SHOW ERROR MESSAGE
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-780007 07/08/01 By rainy 拋出貨單日期錯誤
# Modify.........: No.TQC-780059 07/08/17 By rainy TO_DATE IFX不支援
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-810045 08/03/01 By rainy 項目管理:單身新增專案/WBS/活動3欄位
# Modify.........: No.FUN-7C0017 08/03/06 By bnlent 增加行業別規範化修改 
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840360 08/04/21 By Mandy r.c2不過,因為g_ogb1少加一些欄位
# Modify.........: No.MOD-850217 08/05/26 By Smapmin 依oaz67參數設定,決定轉INVOICE功能要不要呈現
# Modify.........: No.MOD-870180 08/07/15 By Smapmin 出通轉出貨時,未將Invoice帶入
# Modify.........: No.MOD-870182 08/07/15 By Smapmin 單身若為多訂單,單頭訂單單號應清空
# Modify.........: No.MOD-870327 08/07/30 By Smapmin 回寫出通單單頭的Invoice單號是在Invoice單確認時，而axmp220產生的Invoice是未確認的，
#                                                    所以此時不應回寫出通單單頭的Invoice單號
# Modify.........: No.FUN-870146 08/07/31 By xiaofeizhu "轉出貨單"：如出通單需做批/序號管理(oaz81="Y")且料件需做批/序號管理，則一并拋轉單身批/序號資料
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-870007 09/08/06 By Zhangyajun 流通零售功能修改
# Modify.........: No.TQC-970375 09/08/06 By lilingyu 已經生產出貨單不可再次拋轉出貨單
# Modify.........: No.TQC-970373 09/08/07 By liuxqa call axmr500時，多增加一個參數。
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980271 09/09/01 By Smapmin 1.針對不匯總的情況下將
#                                                      出通的"備註/出貨地址檔/出貨單身庫存異動明細"帶到出貨.暫不考慮匯總的狀況.
#                                                    2.出貨日期應該照當下的選擇日期來新增.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/10 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.TQC-9A0161 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0043 09/11/06 By wujie   5.2SQL转标准语法
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-9C0073 10/01/06 By chenls 程序精簡
# Modify.........: No:MOD-A30086 10/03/15 By Smapmin 延續MOD-850217,由oaz67判斷轉invoice的功能應出現於出通單或出貨單整批處理作業.
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No:MOD-A50075 10/06/15 By Smapmin 修正TQC-970375
# Modify.........: No:MOD-A80240 10/08/31 By Smapmin 選擇完出通單後,按轉出貨單功能鈕,出現單別選擇視窗後按放棄,程式會死當
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin ogb50欄位預設值修正
# Modify.........: No.FUN-AC0077 10/12/25 By wangxin oga57欄位預設值修正
# Modify.........: No.MOD-B10020 11/01/07 By Summer 程式右上方 'X'離開鈕沒有反應 
# Modify.........: No:FUN-B50054 11/05/12 By shiwuying 单身增加抽成代号ogb40
# Modify.........: No:TQC-B90052 11/09/06 By jason g_ogb1變數加上 ogbiicd028,ogbiicd029
# Modify.........: No:MOD-B90173 11/11/22 By Vampire 外部參數少tm.d
# Modify.........: No:FUN-BB0083 11/12/22 By xujing 增加數量欄位小數取位
# Modify.........: No:MOD-C20145 12/02/22 By Vampire 判斷oga032如果為空,才重抓occ02給值
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30289 12/04/03 By bart 1.所有程式的備品比率、Spare Part、TapeReel隱藏bart2.增加End User欄位
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t600sub_y_chk參數
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             
# Modify.........: No:FUN-C30085 12/07/10 By nanbing CR改串GR
# Modify.........: No:TQC-C50046 12/08/28 By zhuhao 點擊出通單明細按鈕傳值修改
# Modify.........: No:TQC-C80100 12/08/28 By dongsz 參數類型修改
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:TQC-D10066 13/01/17 By SunLM  g_ogb1数组的顺序与saxmt600.global的g_ogb数组顺序不一致  
# Modify.........: No:MOD-CB0013 13/02/01 By Elise g_ogb1,g_ogb1_t定義的欄位數與FOREACH ogb_curs INTO g_ogb1[g_cnt].*不符
# Modify.........: No.MOD-D30013 13/03/07 By Elise 人員編號開窗 修正為oga14
# Modify.........: No.MOD-D20168 13/03/07 By Elise 轉 INVOICE 時，請多回給 ofaconf = 'N' 預設值
# Modify.........: No.FUN-D30083 13/03/25 By Elise 拋轉出貨單刻號、BIN資料需帶入
# Modify.........: No.MOD-D30253 13/03/28 By Vampire axmp210 MOD-8A0275 增加  oea1015 = ' '的情況,axmp220 也需一併調整否則會撈不到資料
# Modify.........: No.MOD-D40011 13/04/02 By Elise 拋轉時增加寫入帳單客戶與出貨客戶資料

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
 
DEFINE g_oga1   DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  oga02     LIKE oga_file.oga02,   #出通日期
                  oga01     LIKE oga_file.oga01,   
                  oga16     LIKE oga_file.oga16,   
                  oga00     LIKE oga_file.oga00,
                  oga08     LIKE oga_file.oga08,
                  oga03     LIKE oga_file.oga03,
                  oga032    LIKE oga_file.oga032,
                  oga04     LIKE oga_file.oga04,
                  occ02     LIKE occ_file.occ02,
                  oea10     LIKE oea_file.oea10,
                  oga23     LIKE oga_file.oga23,
                  oga21     LIKE oga_file.oga21,
                  oga27     LIKE oga_file.oga27,
                  oga30     LIKE oga_file.oga30,
                  oga10     LIKE oga_file.oga10,
                  oga14     LIKE oga_file.oga14,
                  gen02     LIKE gen_file.gen02,
                  ogaconf   LIKE oga_file.ogaconf,
                  ogapost   LIKE oga_file.ogapost,
                  oga55     LIKE oga_file.oga55
               END RECORD,
       g_oga1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  oga02     LIKE oga_file.oga02,   #出通日期
                  oga01     LIKE oga_file.oga01,   
                  oga16     LIKE oga_file.oga16,   
                  oga00     LIKE oga_file.oga00,
                  oga08     LIKE oga_file.oga08,
                  oga03     LIKE oga_file.oga03,
                  oga032    LIKE oga_file.oga032,
                  oga04     LIKE oga_file.oga04,
                  occ02     LIKE occ_file.occ02,
                  oea10     LIKE oea_file.oea10,
                  oga23     LIKE oga_file.oga23,
                  oga21     LIKE oga_file.oga21,
                  oga27     LIKE oga_file.oga27,
                  oga30     LIKE oga_file.oga30,
                  oga10     LIKE oga_file.oga10,
                  oga14     LIKE oga_file.oga14,
                  gen02     LIKE gen_file.gen02,
                  ogaconf   LIKE oga_file.ogaconf,
                  ogapost   LIKE oga_file.ogapost,
                  oga55     LIKE oga_file.oga55
               END RECORD,
#TQC-D10066 mark begin--------------------------------               
#       g_ogb1   DYNAMIC ARRAY OF RECORD
#                  ogb03     LIKE ogb_file.ogb03,
#                  ogb1005   LIKE ogb_file.ogb1005,
#                  ogb31     LIKE ogb_file.ogb31,
#                  ogb32     LIKE ogb_file.ogb32,
##FUN-AB0061 -----------add start----------------                   
#                  ogb48    LIKE ogb_file.ogb48, 
#                  ogb49    LIKE ogb_file.ogb49,
#                  #ogb50    LIKE ogb_file.ogb50,#FUN-AC0055 mark
##FUN-AB0061 -----------add end----------------      
#                  ogb04     LIKE ogb_file.ogb04,
#                  att00     LIKE imx_file.imx00,  
#                  att01     LIKE imx_file.imx03,                                                                                              
#                  att01_c   LIKE imx_file.imx03,                                                                                              
#                  att02     LIKE imx_file.imx03,                                                                                              
#                  att02_c   LIKE imx_file.imx03,                                                                                              
#                  att03     LIKE imx_file.imx03,                                                                                              
#                  att03_c   LIKE imx_file.imx03,                                                                                              
#                  att04     LIKE imx_file.imx03,                                                                                              
#                  att04_c   LIKE imx_file.imx03,                                                                                              
#                  att05     LIKE imx_file.imx03,                                                                                              
#                  att05_c   LIKE imx_file.imx03,                                                                                              
#                  att06     LIKE imx_file.imx03,                                                                                              
#                  att06_c   LIKE imx_file.imx03,                                                                                              
#                  att07     LIKE imx_file.imx03,                                                                                              
#                  att07_c   LIKE imx_file.imx03,                                                                                              
#                  att08     LIKE imx_file.imx03,                                                                                              
#                  att08_c   LIKE imx_file.imx03,                                                                                              
#                  att09     LIKE imx_file.imx03,                                                                                              
#                  att09_c   LIKE imx_file.imx03,                                                                                              
#                  att10     LIKE imx_file.imx03,                                                                                              
#                  att10_c   LIKE imx_file.imx03,   
#                  ogb06     LIKE ogb_file.ogb06,
#                  ima021    LIKE ima_file.ima021,
#                  ima1002   LIKE ima_file.ima1002,
#                  ima135    LIKE ima_file.ima135, 
#                  ogb11     LIKE ogb_file.ogb11,  
#                  ogb1001   LIKE ogb_file.ogb1001,
#                  ogb40     LIKE ogb_file.ogb40,   #FUN-B50054
#                  ogb1012   LIKE ogb_file.ogb1012,
#                  ogb17     LIKE ogb_file.ogb17,
#                  ogb09     LIKE ogb_file.ogb09,
#                  ogb091    LIKE ogb_file.ogb091,
#                  ogb092    LIKE ogb_file.ogb092, 
#                  ogb1003   LIKE ogb_file.ogb1003,      
#                  ogb19     LIKE ogb_file.ogb19,  
#                  ogb05     LIKE ogb_file.ogb05,
#                  ogb12     LIKE ogb_file.ogb12,
#                  ogb913    LIKE ogb_file.ogb913,
#                  ogb914    LIKE ogb_file.ogb914,
#                  ogb915    LIKE ogb_file.ogb915,
#                  ogb910    LIKE ogb_file.ogb910,
#                  ogb911    LIKE ogb_file.ogb911,
#                  ogb912    LIKE ogb_file.ogb912,
#                  ogb916    LIKE ogb_file.ogb916,
#                  ogb917    LIKE ogb_file.ogb917,
#                  ogb52     LIKE ogb_file.ogb52,  #FUN-C50097 ADD
#                  ogb50     LIKE ogb_file.ogb50,  #FUN-C50097 ADD
#                  ogb51     LIKE ogb_file.ogb51,  #FUN-C50097 ADD
#                  ogb54     LIKE ogb_file.ogb54,  #FUN-C50097 ADD
#                  ogb53     LIKE ogb_file.ogb53,  #FUN-C50097 ADD
#                  ogb55     LIKE ogb_file.ogb55,  #FUN-C50097 ADD                                    
#                  ogb12b    LIKE ogb_file.ogb12,
#                  ogb915b   LIKE ogb_file.ogb915,
#                  ogb912b   LIKE ogb_file.ogb912,
#                  ogb65     LIKE ogb_file.ogb65,
#                  ogb01a    LIKE ogb_file.ogb01,
#                  ogb01b    LIKE ogb_file.ogb01,
#                   ogb41     LIKE ogb_file.ogb41,
#                   ogb42     LIKE ogb_file.ogb42,
#                   ogb43     LIKE ogb_file.ogb43,
#                  ogb1004   LIKE ogb_file.ogb1004,
#                  ogb1002   LIKE ogb_file.ogb1002,
#                  ogb37     LIKE ogb_file.ogb37,#FUN-AB0061
#                  ogb13     LIKE ogb_file.ogb13,  
#                  ogb1006   LIKE ogb_file.ogb1006,
#                  ogb14     LIKE ogb_file.ogb14,  
#                  ogb14t    LIKE ogb_file.ogb14t,
#                  ogb930    LIKE ogb_file.ogb930, 
#                  gem02c    LIKE gem_file.gem02 , 
#                  ogb908    LIKE ogb_file.ogb908,
#                  ogbiicd01 LIKE ogbi_file.ogbiicd01,
#                  ogbiicd02 LIKE ogbi_file.ogbiicd02,
#                  ogbiicd03 LIKE ogbi_file.ogbiicd03,
#                  ogbiicd04 LIKE ogbi_file.ogbiicd04,
#                  ogbud01 LIKE ogb_file.ogbud01,
#                  ogbud02 LIKE ogb_file.ogbud02,
#                  ogbud03 LIKE ogb_file.ogbud03,
#                  ogbud04 LIKE ogb_file.ogbud04,
#                  ogbud05 LIKE ogb_file.ogbud05,
#                  ogbud06 LIKE ogb_file.ogbud06,
#                  ogbud07 LIKE ogb_file.ogbud07,
#                  ogbud08 LIKE ogb_file.ogbud08,
#                  ogbud09 LIKE ogb_file.ogbud09,
#                  ogbud10 LIKE ogb_file.ogbud10,
#                  ogbud11 LIKE ogb_file.ogbud11,
#                  ogbud12 LIKE ogb_file.ogbud12,
#                  ogbud13 LIKE ogb_file.ogbud13,
#                  ogbud14 LIKE ogb_file.ogbud14,
#                  ogbud15 LIKE ogb_file.ogbud15,
#                  ogb44   LIKE ogb_file.ogb44,  #No.FUN-870007
#                  ogb45   LIKE ogb_file.ogb45,  #No.FUN-870007
#                  ogb46   LIKE ogb_file.ogb46,  #No.FUN-870007
#                  ogb47   LIKE ogb_file.ogb47,  #No.FUN-870007
#                  ogbiicd028 LIKE ogbi_file.ogbiicd028,   #TQC-B90052
#                  ogbiicd029 LIKE ogbi_file.ogbiicd029,   #TQC-B90052
#                  ogbiicd07 LIKE ogbi_file.ogbiicd07      #FUN-C30289
#               END RECORD,
#       g_ogb1_t RECORD
#                  ogb03     LIKE ogb_file.ogb03,
#                  ogb1005   LIKE ogb_file.ogb1005,
#                  ogb31     LIKE ogb_file.ogb31,
#                  ogb32     LIKE ogb_file.ogb32,
##FUN-AB0061 -----------add start----------------                   
#                  ogb48    LIKE ogb_file.ogb48, 
#                  ogb49    LIKE ogb_file.ogb49,
#                  #ogb50    LIKE ogb_file.ogb50,#FUN-AC0055 mark
##FUN-AB0061 -----------add end----------------      
#                  ogb04     LIKE ogb_file.ogb04,
#                  att00     LIKE imx_file.imx00,  
#                  att01     LIKE imx_file.imx03,                                                                                              
#                  att01_c   LIKE imx_file.imx03,                                                                                              
#                  att02     LIKE imx_file.imx03,                                                                                              
#                  att02_c   LIKE imx_file.imx03,                                                                                              
#                  att03     LIKE imx_file.imx03,                                                                                              
#                  att03_c   LIKE imx_file.imx03,                                                                                              
#                  att04     LIKE imx_file.imx03,                                                                                              
#                  att04_c   LIKE imx_file.imx03,                                                                                              
#                  att05     LIKE imx_file.imx03,                                                                                              
#                  att05_c   LIKE imx_file.imx03,                                                                                              
#                  att06     LIKE imx_file.imx03,                                                                                              
#                  att06_c   LIKE imx_file.imx03,                                                                                              
#                  att07     LIKE imx_file.imx03,                                                                                              
#                  att07_c   LIKE imx_file.imx03,                                                                                              
#                  att08     LIKE imx_file.imx03,                                                                                              
#                  att08_c   LIKE imx_file.imx03,                                                                                              
#                  att09     LIKE imx_file.imx03,                                                                                              
#                  att09_c   LIKE imx_file.imx03,                                                                                              
#                  att10     LIKE imx_file.imx03,                                                                                              
#                  att10_c   LIKE imx_file.imx03,   
#                  ogb06     LIKE ogb_file.ogb06,
#                  ima021    LIKE ima_file.ima021,
#                  ima1002   LIKE ima_file.ima1002,
#                  ima135    LIKE ima_file.ima135, 
#                  ogb11     LIKE ogb_file.ogb11,  
#		              ogb1001   LIKE ogb_file.ogb1001,
#                  ogb40     LIKE ogb_file.ogb40,   #FUN-B50054
#                  ogb1012   LIKE ogb_file.ogb1012,
#                  ogb17     LIKE ogb_file.ogb17,
#                  ogb09     LIKE ogb_file.ogb09,
#                  ogb091    LIKE ogb_file.ogb091,
#                  ogb092    LIKE ogb_file.ogb092, 
#                  ogb1003   LIKE ogb_file.ogb1003,      
#                  ogb19     LIKE ogb_file.ogb19,  
#                  ogb05     LIKE ogb_file.ogb05,
#                  ogb12     LIKE ogb_file.ogb12,
#                  ogb913    LIKE ogb_file.ogb913,
#                  ogb914    LIKE ogb_file.ogb914,
#                  ogb915    LIKE ogb_file.ogb915,
#                  ogb910    LIKE ogb_file.ogb910,
#                  ogb911    LIKE ogb_file.ogb911,
#                  ogb912    LIKE ogb_file.ogb912,
#                  ogb916    LIKE ogb_file.ogb916,
#                  ogb917    LIKE ogb_file.ogb917,
#                  ogb52     LIKE ogb_file.ogb52,  #FUN-C50097 ADD
#                  ogb50     LIKE ogb_file.ogb50,  #FUN-C50097 ADD
#                  ogb51     LIKE ogb_file.ogb51,  #FUN-C50097 ADD 
#                  ogb54     LIKE ogb_file.ogb54,  #FUN-C50097 ADD
#                  ogb53     LIKE ogb_file.ogb53,  #FUN-C50097 ADD
#                  ogb55     LIKE ogb_file.ogb55,  #FUN-C50097 ADD                                    
#                  ogb12b    LIKE ogb_file.ogb12,
#                  ogb915b   LIKE ogb_file.ogb915,
#                  ogb912b   LIKE ogb_file.ogb912,
#                  ogb65     LIKE ogb_file.ogb65,
#                  ogb01a    LIKE ogb_file.ogb01,
#                  ogb01b    LIKE ogb_file.ogb01,
#                  ogb41     LIKE ogb_file.ogb41,
#                  ogb42     LIKE ogb_file.ogb42,
#                  ogb43     LIKE ogb_file.ogb43,
#                  ogb1004   LIKE ogb_file.ogb1004,
#                  ogb1002   LIKE ogb_file.ogb1002,
#                  ogb37     LIKE ogb_file.ogb37,  #FUN-AB0061
#                  ogb13     LIKE ogb_file.ogb13,  
#                  ogb1006   LIKE ogb_file.ogb1006,
#                  ogb14     LIKE ogb_file.ogb14,  
#                  ogb14t    LIKE ogb_file.ogb14t,
#                  ogb930    LIKE ogb_file.ogb930, 
#                  gem02c    LIKE gem_file.gem02 , 
#                  ogb908    LIKE ogb_file.ogb908,
#                  ogbiicd01 LIKE ogbi_file.ogbiicd01,
#                  ogbiicd02 LIKE ogbi_file.ogbiicd02,
#                  ogbiicd03 LIKE ogbi_file.ogbiicd03,
#                  ogbiicd04 LIKE ogbi_file.ogbiicd04,
#                  ogbud01 LIKE ogb_file.ogbud01,
#                  ogbud02 LIKE ogb_file.ogbud02,
#                  ogbud03 LIKE ogb_file.ogbud03,
#                  ogbud04 LIKE ogb_file.ogbud04,
#                  ogbud05 LIKE ogb_file.ogbud05,
#                  ogbud06 LIKE ogb_file.ogbud06,
#                  ogbud07 LIKE ogb_file.ogbud07,
#                  ogbud08 LIKE ogb_file.ogbud08,
#                  ogbud09 LIKE ogb_file.ogbud09,
#                  ogbud10 LIKE ogb_file.ogbud10,
#                  ogbud11 LIKE ogb_file.ogbud11,
#                  ogbud12 LIKE ogb_file.ogbud12,
#                  ogbud13 LIKE ogb_file.ogbud13,
#                  ogbud14 LIKE ogb_file.ogbud14,
#                  ogbud15 LIKE ogb_file.ogbud15,
#                  ogb44   LIKE ogb_file.ogb44,  #No.FUN-870007
#                  ogb45   LIKE ogb_file.ogb45,  #No.FUN-870007
#                  ogb46   LIKE ogb_file.ogb46,  #No.FUN-870007
#                  ogb47   LIKE ogb_file.ogb47,  #No.FUN-870007
#                  ogbiicd028 LIKE ogbi_file.ogbiicd028,   #TQC-B90052
#                  ogbiicd029 LIKE ogbi_file.ogbiicd029,   #TQC-B90052
#                  ogbiicd07 LIKE ogbi_file.ogbiicd07      #FUN-C30289
#               END RECORD,
#TQC-D10066 mark end------------------
#TQC-D10066 add begin-----------------
       g_ogb1   DYNAMIC ARRAY OF RECORD
          ogb03     LIKE ogb_file.ogb03,         
          ogb1005   LIKE ogb_file.ogb1005,       
          ogb31     LIKE ogb_file.ogb31,         
          ogb32     LIKE ogb_file.ogb32,         
          ogb48    LIKE ogb_file.ogb48,          
          ogb49    LIKE ogb_file.ogb49,          
          ogb04     LIKE ogb_file.ogb04,         
          att00     LIKE imx_file.imx00,         
          att01     LIKE imx_file.imx03,         
          att01_c   LIKE imx_file.imx03,         
          att02     LIKE imx_file.imx03,         
          att02_c   LIKE imx_file.imx03,         
          att03     LIKE imx_file.imx03,         
          att03_c   LIKE imx_file.imx03,         
          att04     LIKE imx_file.imx03,         
          att04_c   LIKE imx_file.imx03,         
          att05     LIKE imx_file.imx03,         
          att05_c   LIKE imx_file.imx03,         
          att06     LIKE imx_file.imx03,         
          att06_c   LIKE imx_file.imx03,         
          att07     LIKE imx_file.imx03,         
          att07_c   LIKE imx_file.imx03,         
          att08     LIKE imx_file.imx03,         
          att08_c   LIKE imx_file.imx03,         
          att09     LIKE imx_file.imx03,         
          att09_c   LIKE imx_file.imx03,         
          att10     LIKE imx_file.imx03,         
          att10_c   LIKE imx_file.imx03,         
          ogb06     LIKE ogb_file.ogb06,         
          ima021    LIKE ima_file.ima021,        
          ima1002   LIKE ima_file.ima1002,       
          ima135    LIKE ima_file.ima135,        
          ogb11     LIKE ogb_file.ogb11,         
          ogb40     LIKE ogb_file.ogb40,         
          ogb1012   LIKE ogb_file.ogb1012,       
          ogb17     LIKE ogb_file.ogb17,         
          ogb09     LIKE ogb_file.ogb09,         
          ogb091    LIKE ogb_file.ogb091,        
          ogb092    LIKE ogb_file.ogb092,        
          ogb1001   LIKE ogb_file.ogb1001,       
          azf03_1   LIKE azf_file.azf03,         
          ogb1003   LIKE ogb_file.ogb1003,       
          ogb19     LIKE ogb_file.ogb19,         
          ogb05     LIKE ogb_file.ogb05,         
          ogb12     LIKE ogb_file.ogb12,         
          ogb913    LIKE ogb_file.ogb913,        
          ogb914    LIKE ogb_file.ogb914,        
          ogb915    LIKE ogb_file.ogb915,        
          ogb910    LIKE ogb_file.ogb910,        
          ogb911    LIKE ogb_file.ogb911,        
          ogb912    LIKE ogb_file.ogb912,        
          ogb916    LIKE ogb_file.ogb916,        
          ogb917    LIKE ogb_file.ogb917,        
          ogb52     LIKE ogb_file.ogb52,         
          ogb50     LIKE ogb_file.ogb50,         
          ogb51     LIKE ogb_file.ogb51,         
          ogb54     LIKE ogb_file.ogb54,         
          ogb53     LIKE ogb_file.ogb53,         
          ogb55     LIKE ogb_file.ogb55,         
          ogb12b    LIKE ogb_file.ogb12,         
          ogb915b   LIKE ogb_file.ogb915,        
          ogb912b   LIKE ogb_file.ogb912,        
          ogb65     LIKE ogb_file.ogb65,         
          azf03_2   LIKE azf_file.azf03,         
          ogb01a    LIKE ogb_file.ogb01,         
          ogb01b    LIKE ogb_file.ogb01,         
          ogb41     LIKE ogb_file.ogb41,         
          ogb42     LIKE ogb_file.ogb42,         
          ogb43     LIKE ogb_file.ogb43,         
          ogb1004   LIKE ogb_file.ogb1004,       
          ogb1002   LIKE ogb_file.ogb1002,       
          ogb37     LIKE ogb_file.ogb37,         
          ogb13     LIKE ogb_file.ogb13,         
          ogb1006   LIKE ogb_file.ogb1006,       
          ogb14     LIKE ogb_file.ogb14,         
          ogb14t    LIKE ogb_file.ogb14t,        
          ogb930    LIKE ogb_file.ogb930,        
          gem02c    LIKE gem_file.gem02 ,        
          ogb908    LIKE ogb_file.ogb908,        
          ogbiicd01 LIKE ogbi_file.ogbiicd01,    
          ogbiicd02 LIKE ogbi_file.ogbiicd02,    
          ogbiicd03 LIKE ogbi_file.ogbiicd03,    
          ogbiicd04 LIKE ogbi_file.ogbiicd04,    
          ogbud01 LIKE ogb_file.ogbud01,         
          ogbud02 LIKE ogb_file.ogbud02,         
          ogbud03 LIKE ogb_file.ogbud03,         
          ogbud04 LIKE ogb_file.ogbud04,         
          ogbud05 LIKE ogb_file.ogbud05,         
          ogbud06 LIKE ogb_file.ogbud06,         
          ogbud07 LIKE ogb_file.ogbud07,         
          ogbud08 LIKE ogb_file.ogbud08,         
          ogbud09 LIKE ogb_file.ogbud09,         
          ogbud10 LIKE ogb_file.ogbud10,         
          ogbud11 LIKE ogb_file.ogbud11,         
          ogbud12 LIKE ogb_file.ogbud12,         
          ogbud13 LIKE ogb_file.ogbud13,         
          ogbud14 LIKE ogb_file.ogbud14,         
          ogbud15 LIKE ogb_file.ogbud15,         
          ogb44   LIKE ogb_file.ogb44,           
          ogb45   LIKE ogb_file.ogb45,           
          ogb46   LIKE ogb_file.ogb46,           
          ogb47   LIKE ogb_file.ogb47,           
          ogbiicd028 LIKE ogbi_file.ogbiicd028,  
          ogbiicd029 LIKE ogbi_file.ogbiicd029,  
          ogbiicd07  LIKE ogbi_file.ogbiicd07    
       END RECORD,
       g_ogb1_t   RECORD
          ogb03     LIKE ogb_file.ogb03,         
          ogb1005   LIKE ogb_file.ogb1005,       
          ogb31     LIKE ogb_file.ogb31,         
          ogb32     LIKE ogb_file.ogb32,         
          ogb48    LIKE ogb_file.ogb48,          
          ogb49    LIKE ogb_file.ogb49,          
          ogb04     LIKE ogb_file.ogb04,         
          att00     LIKE imx_file.imx00,         
          att01     LIKE imx_file.imx03,         
          att01_c   LIKE imx_file.imx03,         
          att02     LIKE imx_file.imx03,         
          att02_c   LIKE imx_file.imx03,         
          att03     LIKE imx_file.imx03,         
          att03_c   LIKE imx_file.imx03,         
          att04     LIKE imx_file.imx03,         
          att04_c   LIKE imx_file.imx03,         
          att05     LIKE imx_file.imx03,         
          att05_c   LIKE imx_file.imx03,         
          att06     LIKE imx_file.imx03,         
          att06_c   LIKE imx_file.imx03,         
          att07     LIKE imx_file.imx03,         
          att07_c   LIKE imx_file.imx03,         
          att08     LIKE imx_file.imx03,         
          att08_c   LIKE imx_file.imx03,         
          att09     LIKE imx_file.imx03,         
          att09_c   LIKE imx_file.imx03,         
          att10     LIKE imx_file.imx03,         
          att10_c   LIKE imx_file.imx03,         
          ogb06     LIKE ogb_file.ogb06,         
          ima021    LIKE ima_file.ima021,        
          ima1002   LIKE ima_file.ima1002,       
          ima135    LIKE ima_file.ima135,        
          ogb11     LIKE ogb_file.ogb11,         
          ogb40     LIKE ogb_file.ogb40,         
          ogb1012   LIKE ogb_file.ogb1012,       
          ogb17     LIKE ogb_file.ogb17,         
          ogb09     LIKE ogb_file.ogb09,         
          ogb091    LIKE ogb_file.ogb091,        
          ogb092    LIKE ogb_file.ogb092,        
          ogb1001   LIKE ogb_file.ogb1001,       
          azf03_1   LIKE azf_file.azf03,         
          ogb1003   LIKE ogb_file.ogb1003,       
          ogb19     LIKE ogb_file.ogb19,         
          ogb05     LIKE ogb_file.ogb05,         
          ogb12     LIKE ogb_file.ogb12,         
          ogb913    LIKE ogb_file.ogb913,        
          ogb914    LIKE ogb_file.ogb914,        
          ogb915    LIKE ogb_file.ogb915,        
          ogb910    LIKE ogb_file.ogb910,        
          ogb911    LIKE ogb_file.ogb911,        
          ogb912    LIKE ogb_file.ogb912,        
          ogb916    LIKE ogb_file.ogb916,        
          ogb917    LIKE ogb_file.ogb917,        
          ogb52     LIKE ogb_file.ogb52,         
          ogb50     LIKE ogb_file.ogb50,         
          ogb51     LIKE ogb_file.ogb51,         
          ogb54     LIKE ogb_file.ogb54,         
          ogb53     LIKE ogb_file.ogb53,         
          ogb55     LIKE ogb_file.ogb55,         
          ogb12b    LIKE ogb_file.ogb12,         
          ogb915b   LIKE ogb_file.ogb915,        
          ogb912b   LIKE ogb_file.ogb912,        
          ogb65     LIKE ogb_file.ogb65,         
          azf03_2   LIKE azf_file.azf03,         
          ogb01a    LIKE ogb_file.ogb01,         
          ogb01b    LIKE ogb_file.ogb01,         
          ogb41     LIKE ogb_file.ogb41,         
          ogb42     LIKE ogb_file.ogb42,         
          ogb43     LIKE ogb_file.ogb43,         
          ogb1004   LIKE ogb_file.ogb1004,       
          ogb1002   LIKE ogb_file.ogb1002,       
          ogb37     LIKE ogb_file.ogb37,         
          ogb13     LIKE ogb_file.ogb13,         
          ogb1006   LIKE ogb_file.ogb1006,       
          ogb14     LIKE ogb_file.ogb14,         
          ogb14t    LIKE ogb_file.ogb14t,        
          ogb930    LIKE ogb_file.ogb930,        
          gem02c    LIKE gem_file.gem02 ,        
          ogb908    LIKE ogb_file.ogb908,        
          ogbiicd01 LIKE ogbi_file.ogbiicd01,    
          ogbiicd02 LIKE ogbi_file.ogbiicd02,    
          ogbiicd03 LIKE ogbi_file.ogbiicd03,    
          ogbiicd04 LIKE ogbi_file.ogbiicd04,    
          ogbud01 LIKE ogb_file.ogbud01,         
          ogbud02 LIKE ogb_file.ogbud02,         
          ogbud03 LIKE ogb_file.ogbud03,         
          ogbud04 LIKE ogb_file.ogbud04,         
          ogbud05 LIKE ogb_file.ogbud05,         
          ogbud06 LIKE ogb_file.ogbud06,         
          ogbud07 LIKE ogb_file.ogbud07,         
          ogbud08 LIKE ogb_file.ogbud08,         
          ogbud09 LIKE ogb_file.ogbud09,         
          ogbud10 LIKE ogb_file.ogbud10,         
          ogbud11 LIKE ogb_file.ogbud11,         
          ogbud12 LIKE ogb_file.ogbud12,         
          ogbud13 LIKE ogb_file.ogbud13,         
          ogbud14 LIKE ogb_file.ogbud14,         
          ogbud15 LIKE ogb_file.ogbud15,         
          ogb44   LIKE ogb_file.ogb44,           
          ogb45   LIKE ogb_file.ogb45,           
          ogb46   LIKE ogb_file.ogb46,           
          ogb47   LIKE ogb_file.ogb47,           
          ogbiicd028 LIKE ogbi_file.ogbiicd028,  
          ogbiicd029 LIKE ogbi_file.ogbiicd029,  
          ogbiicd07  LIKE ogbi_file.ogbiicd07
       END RECORD,
#TQC-D10066 add end-------------------
       g_ofa  RECORD   LIKE ofa_file.*,
       g_ofb  RECORD   LIKE ofb_file.*,
       g_oga2 RECORD   LIKE oga_file.*,
       g_ogb2 RECORD   LIKE ogb_file.*,
       g_oga3 RECORD   LIKE oga_file.*,
       g_ogb3 RECORD   LIKE ogb_file.*,
 
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql,g_ws1,g_ws2    STRING,
       g_wc_oga                   STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE lg_oay22      LIKE oay_file.oay22   #在oay_file中定義的與當前單別關聯的組別   
DEFINE lg_group      LIKE oay_file.oay22   #當前單身中采用的組別
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
#DEFINE g_msg          LIKE type_file.chr1000      #TQC-C80100 mark
DEFINE g_msg          STRING                       #TQC-C80100 add 
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_dbs2         LIKE type_file.chr30    #TQC-680074
DEFINE tm RECORD                              #
          slip        LIKE oay_file.oayslip,  #單據別
          dt          LIKE oeb_file.oeb16,    #出通/出貨日期
          g           LIKE type_file.chr1     #匯總方式
       END RECORD,
       g_gfa          RECORD LIKE gfa_file.*
DEFINE g_ogb1003      LIKE ogb_file.ogb1003   #預計交貨日
DEFINE t_aza41        LIKE type_file.num5     #單別位數 (by aza41)
DEFINE g_renew        LIKE type_file.num5        
DEFINE g_ogbi2        RECORD LIKE ogbi_file.* #No.FUN-7B0018
DEFINE g_plant2       LIKE type_file.chr10    #FUN-980020
DEFINE g_occ          RECORD LIKE occ_file.*  #MOD-D40011 add
 
FUNCTION p220(p_argv0)
   DEFINE p_argv0  LIKE   type_file.chr1
   DEFINE l_oga01  LIKE oga_file.oga01, 
          l_oma00  LIKE oma_file.oma00
 
   WHENEVER ERROR CALL cl_err_msg_log   #MOD-980271
 
   LET g_argv0 = p_argv0
   LET g_renew = 1 
 
   CLEAR FORM
   CALL p220_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   CALL cl_set_comp_visible("ogbiicd02,ogbiicd04",FALSE)           #FUN-C30235  #FUN-C30289
   #FUN-C30289---begin
   IF s_industry('icd') THEN
     CALL cl_set_comp_visible("ogbiicd07",TRUE) 
   ELSE
     CALL cl_set_comp_visible("ogbiicd07",FALSE) 
   END IF 
   #FUN-C30289---end
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p220_q()
      END IF
      CALL s_showmsg_init()     #NO.TQC-740217
      CALL p220_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p220_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p220_sel_all('N')
 
         WHEN "view_da" #出通單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              IF g_prog = "axmp220" THEN                          #TQC-C50046 add
                 LET g_msg = " axmt610 '", g_oga1_t.oga01,"'"
              END IF                                              #TQC-C50046 add
              IF g_prog = "axmp220_icd" THEN                      #TQC-C50046 add
                 LET g_msg = " axmt610_icd '", g_oga1_t.oga01,"'" #TQC-C50046 add
              END IF                                              #TQC-C50046 add
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "view_dn" #出貨單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              IF g_prog = "axmp220" THEN                          #TQC-C50046 add
                 LET g_msg = " axmt620 '", g_oga1_t.oga01,"'"    
              END IF                                              #TQC-C50046 add
              IF g_prog = "axmp220_icd" THEN                      #TQC-C50046 add
                 LET g_msg = " axmt620_icd '", g_oga1_t.oga01,"'" #TQC-C50046 add
              END IF                                              #TQC-C50046 add
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "maintain_detail"  #單身修改
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_b1()
           END IF
           
         WHEN "da_batch_confirm" #出通整批確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_batch_confirm()
           END IF
 
         WHEN "dn_batch_confirm" #出貨整批確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_batch_confirm()
           END IF
 
         WHEN "dn_batch_post" #出貨整批扣帳
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p220_dn_post()
           END IF
 
         WHEN "batch_print_da"   #列印出通單 
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_batch_out()
           END IF
 
         WHEN "batch_print_dn"   #列印出貨單 
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_batch_out()
           END IF
 
         WHEN "carry_dn"      #轉出貨單
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
               CALL p220_carry_dn()
           END IF
 
         WHEN "carry_invoice"  #轉INVOICE
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p220_carry_invoice()
           END IF
 
         WHEN "view_invoice"
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              LET g_msg = " axmt500 '", g_oga1_t.oga27,"'"
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "view_pl"
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              DECLARE p220_oga_1 CURSOR FOR
               SELECT oga01 FROM oga_file 
                WHERE oga09 ='2' AND oga011 = g_oga1_t.oga01
              FOREACH p220_oga_1 INTO l_oga01
                 EXIT FOREACH
              END FOREACH
              LET g_msg = " axmt630 '", l_oga01,"'"
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "carry_ar"   #轉應收 #出貨單功能
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p220_carry_ar()
           END IF
 
         WHEN "a_r"
           LET g_renew = 0
           IF NOT cl_null(g_oga1_t.oga10) THEN
              SELECT oma00 INTO l_oma00 FROM oma_file
               WHERE oma01=g_oga1_t.oga10
              IF cl_null(l_oma00) THEN
                 LET l_oma00='12'
              END IF
              LET g_msg="axrt300 '",g_oga1_t.oga10,"' '' '",l_oma00,"'" 
              CALL cl_cmdrun_wait(g_msg)  
           END IF
           
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oga1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE

         #MOD-B10020 add --start--
         WHEN "close" 
           EXIT WHILE
         #MOD-B10020 add --end--

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p220_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_oga1 WITHOUT DEFAULTS FROM s_oga.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
             IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
             END IF
             LET g_renew = 1
             CALL fgl_set_arr_curr(l_ac1)
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_oga1_t.* = g_oga1[l_ac1].*
 
             IF g_rec_b1 > 0 THEN
               CALL p220_b_fill()
               CALL p220_bp2('')
               IF g_argv0 = "2" THEN #出貨單 
                 CALL cl_set_act_visible("select_all,select_non,view_dn,
                                           dn_batch_confirm,batch_print_dn,
                                           dn_batch_post,carry_ar,a_r", TRUE)
                 #-----MOD-A30086---------
                 IF g_oaz.oaz67 = '2' THEN
                    CALL cl_set_act_visible("carry_invoice",TRUE)
                 END IF
                 #-----END MOD-A30086-----
               ELSE   #出通單
                 CALL cl_set_act_visible("select_all,select_non,view_da,
                                          maintain_detail,da_batch_confirm,batch_print_da,
                                          carry_dn,view_invoice,view_pl",TRUE)      #MOD-850217把carry_invoice拿掉
                 IF g_oaz.oaz67 = '1' THEN
                    CALL cl_set_act_visible("carry_invoice",TRUE)
                 END IF
               END IF
             ELSE
               CALL cl_set_act_visible("select_all,select_non,view_dn,view_da,
                                        maintain_detail,da_batch_confirm,dn_batch_confirm,
                                        carry_dn,carry_invoice,view_invoice,view_pl,
                                        batch_print_da,batch_print_dn,dn_batch_post,
                                        carry_ar,a_r", FALSE)
             END IF
 
         ON CHANGE a
            IF cl_null(g_oga1[l_ac1].a) THEN 
               LET g_oga1[l_ac1].a = 'Y'
            END IF
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT
 
         ON ACTION view_da #出通單明細
            LET g_action_choice="view_da"
            EXIT INPUT
 
         ON ACTION view_dn #出貨單明細
            LET g_action_choice="view_dn"
            EXIT INPUT
 
         ON ACTION maintain_detail
            LET g_action_choice="maintain_detail"
            EXIT INPUT
 
         ON ACTION da_batch_confirm #出通單整批確認
            LET g_action_choice="da_batch_confirm"
            EXIT INPUT
 
         ON ACTION dn_batch_confirm #出通單整批確認
            LET g_action_choice="dn_batch_confirm"
            EXIT INPUT
 
         ON ACTION dn_batch_post #出通單整批確認
            LET g_action_choice="dn_batch_post"
            EXIT INPUT
 
         ON ACTION batch_print_da   #列印出通單
            LET g_action_choice="batch_print_da"
            EXIT INPUT
 
         ON ACTION batch_print_dn   #列印出貨單
            LET g_action_choice="batch_print_dn"
            EXIT INPUT
 
         ON ACTION carry_dn      #轉出貨單
            LET g_action_choice="carry_dn"
            EXIT INPUT
 
         ON ACTION carry_invoice  #轉INVOICE
            LET g_action_choice="carry_invoice"
            EXIT INPUT
 
         ON ACTION view_invoice  #INVOICE明細
            LET g_action_choice="view_invoice"
            EXIT INPUT
 
         ON ACTION view_pl  #packing list 明細
            LET g_action_choice="view_pl"
            EXIT INPUT
         
         ON ACTION carry_ar     #轉應收
            LET g_action_choice="carry_ar"
            EXIT INPUT
 
         ON ACTION a_r              #應收維護
            LET g_action_choice="a_r"
            EXIT INPUT
 
         ON ACTION view
            CALL p220_bp2('V')
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT

         #MOD-B10020 add --start--
         ON ACTION close 
            LET g_action_choice="exit"
            EXIT INPUT
         #MOD-B10020 add --end--
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p220_q()
 
   IF g_sma.sma120 = 'Y'  THEN                                                                                
      #初始化界面的樣式(沒有任何默認屬性組)                                                                                           
      LET lg_oay22 = ''                                                                                                               
      LET lg_group = ''                                                                                                               
      CALL p220_refresh_detail() 
   END IF
   CALL p220_b_askkey()
END FUNCTION
 
 
FUNCTION p220_b_askkey()
   CLEAR FORM
   CALL g_oga1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON oga02,oga01,oga16,oga00,oga08,oga03,oga04,oea10,
                      oga23,oga21,oga27,oga30,oga10,oga14,ogaconf,
                      ogapost,oga55
                 FROM s_oga[1].oga02,s_oga[1].oga01,s_oga[1].oga16,
                      s_oga[1].oga00,s_oga[1].oga08,s_oga[1].oga03,
                      s_oga[1].oga04,s_oga[1].oea10,s_oga[1].oga23,
                      s_oga[1].oga21,s_oga[1].oga27,s_oga[1].oga30,
                      s_oga[1].oga10,s_oga[1].oga14,s_oga[1].ogaconf,
                      s_oga[1].ogapost,s_oga[1].oga55
                      
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga7"
                   LET g_qryparam.state = "c"
                   CASE 
                      WHEN g_argv0 = '1' LET g_qryparam.arg1 = '1'
                      WHEN g_argv0 = '2' LET g_qryparam.arg1 = '2'
                   END CASE
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga01
                   NEXT FIELD oga01
 
               WHEN INFIELD(oga16)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oea11"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga16
                   NEXT FIELD oga16
 
               WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03  
                   NEXT FIELD oga03  
 
              WHEN INFIELD(oga04) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ4"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga04
                   NEXT FIELD oga04
 
              #WHEN INFIELD(oea14) #MOD-D30013 mark
               WHEN INFIELD(oga14) #MOD-D30013 add
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga14
                   NEXT FIELD oga14
 
              WHEN INFIELD(oga21) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gec"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga21
                   NEXT FIELD oga21
 
              WHEN INFIELD(oga23) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga23
                   NEXT FIELD oga23
              WHEN INFIELD(oga27)                                                                                                   
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.form ="q_oga4"                                                                                    
                   LET g_qryparam.state = "c"                                                                                       
                   CASE                                                                                                             
                      WHEN g_argv0 = '1' LET g_qryparam.arg1 = '1'                                                                  
                      WHEN g_argv0 = '2' LET g_qryparam.arg1 = '2'                                                                  
                   END CASE                                                                                                         
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                               
                   DISPLAY g_qryparam.multiret TO oga27                                                                             
                   NEXT FIELD oga27                                                                                                 
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p220_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oga1_t.* = g_oga1[l_ac1].*
 
   CALL p220_b_fill()
END FUNCTION
 
FUNCTION p220_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT 'N',oga02,oga01,oga16,oga00,oga08,oga03,oga032,oga04,'',",
               "       '',oga23,oga21,oga27,oga30,oga10,oga14,'',ogaconf,",
               "       ogapost,oga55", 
               "  FROM oga_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oga09 = '",g_argv0,"'",
               " ORDER BY oga02 DESC "
 
   PREPARE p220_pb1 FROM g_sql
   DECLARE oga_curs CURSOR FOR p220_pb1
  
   CALL g_oga1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oga_curs INTO g_oga1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO g_oga1[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oga1[g_cnt].oga04
 
      SELECT gen02 INTO g_oga1[g_cnt].gen02
        FROM gen_file
       WHERE gen01 = g_oga1[g_cnt].oga14
      
      IF NOT cl_null(g_oga1[g_cnt].oga16) THEN
         SELECT oea10 INTO g_oga1[g_cnt].oea10 
           FROM oea_file 
         WHERE oea01 = g_oga1[g_cnt].oga16
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_oga1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   #CALL SET_COUNT(g_rec_b1)#告之DISPALY ARRAY
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p220_b_fill()
   DEFINE l_oga65  LIKE oga_file.oga65
 
    IF s_industry('std') THEN
    LET g_sql =
        "SELECT ogb03,ogb1005,ogb31,ogb32,ogb48,ogb49,ogb04,'','','','','','','','','',",#FUN-AB0061
        "       '','','','','','','','','','','','',ogb06,ima021,ima1002,ima135,ogb11,ogb1001,'',ogb40,ogb1012,",  #No.FUN-610064 #FUN-B50054 #TQC-D10066 add ''azf03_1
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,ogb913,ogb914,",  #No.FUN-5C0075  No.FUN-610064
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917,ogb52,ogb50,ogb51,ogb54,ogb53,ogb55, ", #FUN-C50097 ADD OGB50,51,52
        "       0,0,0,ogb65,'','','',",  #No.FUN-630061 #TQC-D10066 add ''azf03_2
        "       ogb41,ogb42,ogb43,",  #FUN-810045 add 
        "       ogb1004,ogb1002,ogb37,ogb13,ogb1006,ogb14,ogb14t,",   #No.FUN-610064#FUN-AB0061
        "       ogb930,'',ogb908, ", #no.A050 add ogb908  #FUN-670063
        "       '','','','',",        #No.FUN-7C0017
        #MOD-CB0013 add start -----
        "       ogbud01,ogbud02,ogbud03,ogbud04,ogbud05, ",
        "       ogbud06,ogbud07,ogbud08,ogbud09,ogbud10, ",
        "       ogbud11,ogbud12,ogbud13,ogbud14,ogbud15, ",
        #MOD-CB0013 add end   -----
        "       ogb44,ogb45,ogb46,ogb47, '', '', '' ",   #No.FUN-870007 #FUN-C30289
        " FROM ogb_file,OUTER ima_file ",
        " WHERE ogb01 ='",g_oga1_t.oga01,"'",  #單頭
        " AND ogb_file.ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",         #No.TQC-640123
        " ORDER BY ogb03"
    ELSE
    LET g_sql =
        "SELECT ogb03,ogb1005,ogb31,ogb32,ogb48,ogb49,ogb04,'','','','','','','','','',",#FUN-AB0061
        "       '','','','','','','','','','','','',ogb06,ima021,ima1002,ima135,ogb11,ogb1001,'',ogb40,ogb1012,",  #No.FUN-610064 #FUN-B50054 #TQC-D10066 add ''azf03_2
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,ogb913,ogb914,",  #No.FUN-5C0075  No.FUN-610064
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917,ogb52,ogb50,ogb51,ogb54,ogb53,ogb55, ",  #FUN-C50097 ADD OGB50,51,52
        "       0,0,0,ogb65,'','','',",  #No.FUN-630061 #TQC-D10066 add ''azf03_1
        "       ogb41,ogb42,ogb43,",  #FUN-810045 add 
        "       ogb1004,ogb1002,ogb37,ogb13,ogb1006,ogb14,ogb14t,",   #No.FUN-610064#FUN-AB0061
        "       ogb930,'',ogb908,  ", #no.A050 add ogb908  #FUN-670063
        "       ogbiicd01,ogbiicd02,ogbiicd03,ogbiicd04, ",
        #MOD-CB0013 add start -----
        "       ogbud01,ogbud02,ogbud03,ogbud04,ogbud05, ",
        "       ogbud06,ogbud07,ogbud08,ogbud09,ogbud10, ",
        "       ogbud11,ogbud12,ogbud13,ogbud14,ogbud15, ",
        #MOD-CB0013 add end   -----
        "       ogb44,ogb45,ogb46,ogb47,ogbiicd028,ogbiicd029,ogbiicd07",   #No.FUN-870007  #FUN-C30289
        " FROM ogb_file,OUTER ima_file,OUTER ogbi_file ",
        " WHERE ogb01 ='",g_oga1_t.oga01,"'",  #單頭
        " AND ogb_file.ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",         #No.TQC-640123
        " AND ogb_file.ogb01 = ogbi_file.ogbi01 ",
        " AND ogb_file.ogb03 = ogbi_file.ogbi03 ",
        " ORDER BY ogb03"
    END IF
 
   PREPARE p220_pb FROM g_sql
   DECLARE ogb_curs CURSOR FOR p220_pb
   CALL g_ogb1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   SELECT oga65 INTO l_oga65 FROM oga_file
    WHERE oga01 = g_oga_t.oga01
   FOREACH ogb_curs INTO g_ogb1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
         #得到該料件對應的父料件和所有屬性                                                                                        
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                imx07,imx08,imx09,imx10 INTO                                                                                      
                g_ogb1[g_cnt].att00,g_ogb1[g_cnt].att01,g_ogb1[g_cnt].att02,                                                         
                g_ogb1[g_cnt].att03,g_ogb1[g_cnt].att04,g_ogb1[g_cnt].att05,                                                         
                g_ogb1[g_cnt].att06,g_ogb1[g_cnt].att07,g_ogb1[g_cnt].att08,                                                         
                g_ogb1[g_cnt].att09,g_ogb1[g_cnt].att10                                                                             
         FROM imx_file WHERE imx000 = g_ogb1[g_cnt].ogb04                                                                          
                                                                                                                                  
         LET g_ogb1[g_cnt].att01_c = g_ogb1[g_cnt].att01                                                                            
         LET g_ogb1[g_cnt].att02_c = g_ogb1[g_cnt].att02                                                                            
         LET g_ogb1[g_cnt].att03_c = g_ogb1[g_cnt].att03                                                                            
         LET g_ogb1[g_cnt].att04_c = g_ogb1[g_cnt].att04                                                                            
         LET g_ogb1[g_cnt].att05_c = g_ogb1[g_cnt].att05                                                                            
         LET g_ogb1[g_cnt].att06_c = g_ogb1[g_cnt].att06                                                                            
         LET g_ogb1[g_cnt].att07_c = g_ogb1[g_cnt].att07                                                                            
         LET g_ogb1[g_cnt].att08_c = g_ogb1[g_cnt].att08                                                                            
         LET g_ogb1[g_cnt].att09_c = g_ogb1[g_cnt].att09                                                                            
         LET g_ogb1[g_cnt].att10_c = g_ogb1[g_cnt].att10                                                                            
      END IF  
   
      IF cl_null(g_ogb1[g_cnt].ogb910) THEN 
         LET g_ogb1[g_cnt].ogb911 = NULL
         LET g_ogb1[g_cnt].ogb912 = NULL
      END IF
      IF cl_null(g_ogb1[g_cnt].ogb913) THEN 
         LET g_ogb1[g_cnt].ogb914 = NULL
         LET g_ogb1[g_cnt].ogb915 = NULL
      END IF
   
      IF g_ogb1[g_cnt].ogb04[1,4]!='MISC' THEN 
         SELECT ima1002,ima135 INTO g_ogb1[g_cnt].ima1002,g_ogb1[g_cnt].ima135                                                    
           FROM ima_file                                                                                                    
          WHERE ima01 = g_ogb1[g_cnt].ogb04                                                                                  
      END IF                                            
     
      IF g_argv0 = '2' AND l_oga65='Y' THEN
         SELECT ogb01 INTO g_ogb1[g_cnt].ogb01a
           FROM ogb_file,oga_file
          WHERE ogb01 =oga01
            AND oga011=g_oga_t.oga01
            AND oga09 = '8'
            AND ogb03 = g_ogb1[g_cnt].ogb03
         SELECT ogb01 INTO g_ogb1[g_cnt].ogb01b
           FROM ogb_file,oga_file
          WHERE ogb01 =oga01
            AND oga011=g_oga_t.oga01
            AND oga09 = '9'
            AND ogb03 = g_ogb1[g_cnt].ogb03
      END IF
      LET g_ogb1[g_cnt].gem02c=s_costcenter_desc(g_ogb1[g_cnt].ogb930) 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_ogb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p220_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb1 TO s_b1.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()
   END DISPLAY
 
END FUNCTION
 
FUNCTION p220_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND (NOT cl_null(lg_oay22)) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_ogb1.getLength() = 0 THEN
        LET lg_group = lg_oay22
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_ogb1.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_ogb1[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_ogb1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_oay22 THEN                                                                                               
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF 
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替ogb04子料件編號來顯示
     #得到當前語言別下ogb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'ogb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'ogb04,ogb06'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'ogb04,ogb06'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'ogb04'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
 
FUNCTION p220_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_oga1[l_i].a = p_flag
    DISPLAY BY NAME g_oga1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p220_init()
 
   LET g_plant2 = g_plant        #FUN-980020  
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
 
 
   IF g_argv0 = '2' THEN  #出貨單
       CALL cl_set_comp_visible("oga10,ogapost",TRUE)
   ELSE
       CALL cl_set_comp_visible("oga10,ogapost",FALSE)
   END IF 
   CALL cl_set_comp_visible("ogb44,ogb45,ogb46,ogb47",g_azw.azw04='2') #No.FUN-870007
   CALL cl_set_act_visible("select_all,select_non,view_dn,view_da,
                            maintain_detail,da_batch_confirm,dn_batch_confirm,
                            carry_dn,carry_invoice,view_invoice,view_pl,
                            batch_print_da,batch_print_dn,dn_batch_post,
                            carry_ar,a_r", FALSE)
   CALL cl_set_comp_visible("ogb40",FALSE) #FUN-B50054
   CALL cl_set_comp_visible("ogb50,ogb51,ogb52,ogb53,ogb54,ogb55",FALSE) #FUN-C50097 
   CALL p220_ui_set()
    
END FUNCTION
 
#批次列印訂單確認書
FUNCTION p220_batch_out()
  DEFINE l_wc STRING
  DEFINE l_i,l_n  LIKE type_file.num5
         
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
      LET l_n = l_n + 1
    END IF
  END FOR 
 
  IF l_n = 0 THEN RETURN END IF  #都沒勾選
  
  LET l_n = 0 
  LET l_wc = " oga01 IN ("
  FOR l_i = 1 TO g_rec_b1
     IF g_oga1[l_i].a = 'Y' THEn
        LET l_n = l_n + 1
        IF l_n = 1 THEN
           LET l_wc = l_wc CLIPPED,"'",g_oga1[l_i].oga01 CLIPPED,"'"
        ELSE
           LET l_wc = l_wc CLIPPED,",'",g_oga1[l_i].oga01 CLIPPED,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"                                                                                     
  LET l_wc = cl_replace_str( l_wc , "'" , "\"" )
 
  CASE g_argv0 
    WHEN  "1"  #出通單 (axmr500)
      #LET g_msg = "axmr500",  #FUN-C30085 mark
       LET g_msg = "axmg500",  #FUN-C30085 add                                                                                          
          " '",g_today CLIPPED,"' ''",                                                                                         
          " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                  
          " '",l_wc CLIPPED,"' 'N' 'N'"  #No.TQC-970373 mod
    WHEN  "2"  #出貨單 (axmr600)
      #LET g_msg = "axmr600",   #FUN-C30085 mark
       LET g_msg = "axmg600",   #FUN-C30085 add                                                                                                
          " '",g_today CLIPPED,"' ''",                                                                                         
          " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                  
          #" '",l_wc CLIPPED,"' '1' 'Y' 'N' "              #MOD-B90173 mark
          " '",l_wc CLIPPED,"' '1' 'Y' 'Y' 'Y' 'Y' 'Y'"    #MOD-B90173 add
  END CASE
  CALL cl_cmdrun(g_msg)
END FUNCTION
 
 
FUNCTION p220_chk_oga()
  DEFINE l_i,l_n  LIKE type_file.num5
  DEFINE l_cnt    LIKE type_file.num5  #TQC-780007
  LET l_n = 0  
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN  #有勾選
      #要是"已確認"且"已核准"的資料
      IF NOT (g_oga1[l_i].ogaconf = 'Y' AND g_oga1[l_i].oga55 = '1')  THEN
        LET g_oga1[l_i].a = 'N'  #將勾勾拿掉
        LET g_msg = g_oga1[l_i].oga01 CLIPPED
        CALL s_errmsg("",g_msg CLIPPED,'',"atm-402",1)
      ELSE
         #判斷如已拋過就不能再拋
          SELECT COUNT(*) INTO l_cnt
            FROM oga_file 
           WHERE oga09 IN ('2','3','4','6') 
             AND ogaconf <> 'X' 
             AND oga011 = g_oga1[l_i].oga01
          IF l_cnt > 0 THEN
            LET g_oga1[l_i].a = 'N'  #將勾勾拿掉
          ELSE
            LET l_n = l_n + 1
          END IF
      END IF 
    END IF
  END FOR
 
  IF l_n > 0 THEN
    RETURN TRUE
  ELSE
    RETURN FALSE
  END IF
END FUNCTION
 
FUNCTION p220_batch_confirm()
  DEFINE l_i,l_n   LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
       IF g_oga1[l_i].ogaconf <> 'N' THEN
          LET g_oga1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n >  0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
         SELECT oga_file.* INTO  g_oga.* FROM oga_file
          WHERE oga01 = g_oga1[l_i].oga01
         CALL t600sub_y_chk(g_oga1[l_i].oga01,"")  #FUN-740034 #CHI-C30118 add ""
         IF g_success = "Y" THEN
            CALL t600sub_y_upd(g_oga.oga01,"")      #CALL 原確認的 update 段  #FUN-740034
            CALL t600sub_refresh(g_oga.oga01) RETURNING g_oga.*  
            LET g_oga1[l_i].ogaconf = g_oga.ogaconf
            LET g_oga1[l_i].oga55   = g_oga.oga55
         END IF
         INITIALIZE g_oga.* TO NULL
    END IF
  END FOR
END FUNCTION
 
 
FUNCTION p220_dn_post()
  DEFINE l_i,l_n   LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
       IF NOT (g_oga1[l_i].ogaconf = 'Y' AND g_oga1[l_i].ogapost = 'N') THEN
          LET g_oga1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n >  0 THEN
    IF NOT cl_confirm('axm-599') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
         SELECT oga_file.* INTO  g_oga.* FROM oga_file
          WHERE oga01 = g_oga1[l_i].oga01
          CALL t600sub_s('0',FALSE,g_oga1[l_i].oga01,FALSE) #FUN-740034
          SELECT ogapost INTO g_oga1[l_i].ogapost FROM oga_file
           WHERE oga01 = g_oga1[l_i].oga01
         INITIALIZE g_oga.* TO NULL
    END IF
  END FOR
END FUNCTION
 
 
FUNCTION p220_ui_set()
DEFINE cb             ui.ComboBox 
   CALL cl_set_comp_visible("azf03_1,azf03_2",FALSE) #TQC-D10066 add
   CALL cl_set_comp_visible("ogb12b,ogb65,ogb915b,ogb912b",FALSE)
   CALL cl_set_comp_visible("ogb01a,ogb01b",FALSE) 
   CALL cl_set_comp_visible("oga01a,oga01b",FALSE) #只有一般出貨單才顯示
  #FUN-AB0096 Begin--- By shi
  #CALL cl_set_comp_visible("ogb48,ogb49,ogb50",g_argv0 = "2")   #FUN-AB0061 
   IF g_argv0 = "2" AND g_azw.azw04="2" THEN
      CALL cl_set_comp_visible("ogb48,ogb49",TRUE)
   ELSE
      CALL cl_set_comp_visible("ogb48,ogb49",FALSE)
   END IF
  #FUN-AB0096 End-----
   CALL cl_set_comp_visible("ogb41,ogb42,ogb43",g_aza.aza08='Y') #FUN-810045 add
 
   CALL cl_set_comp_visible("ogb911,ogb914",FALSE)
   CALL cl_set_comp_visible("ogb1005,b2_1005",FALSE)
 
   IF g_argv0 = "1" THEN
      CALL cl_set_comp_visible("ogb1005,ogb1007,tqw16,tqw08,tqw081,ogb1008,ogb1009,ogb1010,ogb1011",FALSE)
   END IF
 
   CALL cl_set_comp_visible("ogb930,gem02c",g_aaz.aaz90='Y') #FUN-670063
   CALL cl_set_comp_visible("ogb911,ogb914",FALSE)
 
   IF (g_aza.aza50='N') THEN
         CALL cl_set_comp_visible("oga1001,oga1002,oga1003,oga1005,oga1006,oga1007,oga1008,oga1009,oga1010,oga1011,oga1013,oga1015",FALSE)
         CALL cl_set_comp_visible("oga1002_tqa02,oga1009_tqa02,oga1003_tqb02,oga1011_occ02,oga1010_tqb02",FALSE)
         CALL cl_set_comp_visible("page05,ogb11,ogb37,ogb13,ogb14,ogb14t,ogb1002,ogb1003,ogb1004,ogb1005,ogb1006,ogb1012,ima1002,ima135",FALSE)   #No.FUN-660073#FUN-AB0061
         CALL cl_set_comp_visible("oga50,tot1,tot2,tot3",FALSE)
   END IF
 
   IF g_argv0 = "1" THEN
      CALL cl_set_comp_visible("oga1015,oga1006,oga1013,tot2,tot3,ogb1005,ogb1007,tqw16,tqw08,tqw081,ogb1008,ogb1009,ogb1010,ogb1011",FALSE)
   END IF
   IF g_argv0 = "2" THEN   #No.FUN-630061 
      CALL cl_set_comp_visible("oga1015,oga1008",FALSE)
   END IF
   CALL cl_set_comp_visible("oga1013",FALSE)
 
   CASE g_argv0
      WHEN "1" #axmt610 出貨通知單
         CALL cl_set_comp_visible("oga65",TRUE)
         CALL cl_set_comp_visible("oga99,oga905",FALSE)
         CALL cl_set_comp_visible("oga1012,oga1014",FALSE)
      WHEN "2" #axmt620 一般出貨單
         CALL cl_set_comp_visible("oga65",TRUE)
         CALL cl_set_comp_visible("oga99,oga905",FALSE)
         CALL cl_set_comp_visible("oga01a,oga01b",TRUE)
         CALL cl_set_comp_visible("oga1012,oga1014",TRUE)
   END CASE
 
   CALL cl_set_comp_visible("ogb930,gem02c",g_aaz.aaz90='Y') #FUN-670063
 
   CALL cl_set_comp_visible("ogaspc",FALSE)
   CALL cl_set_act_visible("trans_spc",FALSE)
 
 
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("ogb913,ogb914,ogb915",FALSE)
      CALL cl_set_comp_visible("ogb910,ogb911,ogb912",FALSE)
   ELSE
      CALL cl_set_comp_visible("ogb05,ogb12",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[01]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("ogb916,ogb917",FALSE)
   END IF
 
 
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("ogb913,ogb914,ogb915",FALSE)
      CALL cl_set_comp_visible("ogb910,ogb911,ogb912",FALSE)
   ELSE
      CALL cl_set_comp_visible("ogb05,ogb12",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[01]' THEN   
      CALL cl_set_comp_visible("ogb916,ogb917",FALSE)
   END IF
 
   CALL p220_set_perlang() 
 
   #初始化界面的樣式(沒有任何默認屬性組)                                                                                           
   LET lg_oay22 = ''                                                                                                               
   LET lg_group = ''                                                                                                               
   CALL p220_refresh_detail()                                                                                                      
END FUNCTION
 
FUNCTION p220_set_perlang()
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb913",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb915",g_msg CLIPPED)
      CALL cl_getmsg('asm-326',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb910",g_msg CLIPPED)
      CALL cl_getmsg('asm-327',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ogb912",g_msg CLIPPED)
   END IF
 
   IF g_argv0 = "1" THEN            
      CALL cl_getmsg('axm-370',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oga01",g_msg CLIPPED)
      CALL cl_getmsg('axm-371',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oga02",g_msg CLIPPED)
      CALL cl_getmsg('axm-372',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("oga011",g_msg CLIPPED)
   END IF
   IF g_oaz.oaz23 = 'Y' THEN
      CALL cl_getmsg('axm-042',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("ogb17",g_msg CLIPPED)   
   END IF
END FUNCTION
 
FUNCTION p220_b1()
  DEFINE l_i LIKE type_file.num5
 
  SELECT oga_file.* INTO  g_oga.* FROM oga_file
   WHERE oga01 = g_oga1_t.oga01
  LET g_oga_t.* = g_oga.*
  FOR l_i = 1 TO g_rec_b
     LET g_ogb[l_i].* = g_ogb1[l_i].* 
  END FOR
  CALL t600_b1()                   #輸入單身
  FOR l_i = 1 TO g_rec_b
     LET g_ogb1[l_i].* = g_ogb[l_i].*
  END FOR
  LET g_renew = 0
END FUNCTION
 
#出通單轉INVOICE
FUNCTION p220_carry_invoice()
  DEFINE l_i,l_n   LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
       IF g_oga1[l_i].ogaconf <> 'Y' THEN
          LET g_oga1[l_i].a = 'N' 
          LET g_msg = g_oga1[l_i].oga01 CLIPPED
          CALL s_errmsg("",g_msg CLIPPED,'',"atm-402",1)
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-295') THEN
      CALL s_showmsg()       #NO.TQC-740217
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  OPEN WINDOW p220_exp_ofa AT p_row,p_col WITH FORM "axm/42f/axmp220b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale("axmp220b")
  
  LET g_success = 'Y'
  BEGIN WORK
  LET tm.slip = ''
  LET tm.dt = g_today
  CALL cl_set_act_visible("accept,cancel", TRUE)
  INPUT BY NAME tm.slip,tm.dt  WITHOUT DEFAULTS
    AFTER FIELD slip
      IF NOT cl_null(tm.slip) THEN  
#        CALL s_check_no(g_sys,tm.slip,'',"55","ofa_file","ofa01","")
         CALL s_check_no("axm",tm.slip,'',"55","ofa_file","ofa01","")   #No.FUN-A40041
           RETURNING li_result,tm.slip
         IF (NOT li_result) THEN
    	     NEXT FIELD slip
         END IF
         DISPLAY BY NAME tm.slip
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         #CLOSE WINDOW p200_exp   #MOD-A80240
         CLOSE WINDOW p220_exp_ofa   #MOD-A80240
         RETURN
      END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
              CALL q_oay(FALSE,TRUE,tm.slip,'55','AXM') RETURNING tm.slip
              DISPLAY BY NAME tm.slip   
              NEXT FIELD slip
            OTHERWISE EXIT CASE
         END CASE
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
  
        ON ACTION controlg      
           CALL cl_cmdask()     
  END INPUT
  CALL cl_set_act_visible("accept,cancel", FALSE)
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     LET g_success = 'N'
     ROLLBACK WORK      
     CLOSE WINDOW p220_exp_ofa
     RETURN
  END IF
  CLOSE WINDOW p220_exp_ofa
 
  LET begin_no = NULL
  LET end_no = NULL 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
        INITIALIZE g_ofa.* TO NULL
        INITIALIZE g_ofb.* TO NULL
         SELECT * INTO g_oga.* FROM oga_file
          WHERE oga01 = g_oga1[l_i].oga01
            #AND (oga09 = '1' OR oga09 = '5')   #MOD-A30086
            AND oga09 IN ('1','2','4','5','6')   #MOD-A30086
         CALL p220_ins_ofa()
         CALL p220_upd_ofa()
         LET g_oga1[l_i].oga27 = g_ofa.ofa01
         LET g_oga1_t.* = g_oga1[l_i].*
         IF g_success = 'N' THEN
           EXIT FOR
         END IF
    END IF
  END FOR
  IF g_success = 'N' THEN
    ROLLBACK WORK
    MESSAGE "Failure "
    CALL s_showmsg()       #NO.TQC-740217
  ELSE
     COMMIT WORK
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
END FUNCTION
 
FUNCTION p220_ins_ofa()
    DEFINE exT             LIKE type_file.chr1
    DEFINE l_oap           RECORD LIKE oap_file.*   #MOD-D40011
 
    IF g_oga.ogaconf = 'N' THEN   #未確認
       CALL cl_err(g_oga.oga01,'axm-184',0)
    END IF
 
    LET g_ofa.ofa00 = g_oga.oga00
    LET g_ofa.ofa011 = g_oga.oga01
    LET g_ofa.ofa02 = tm.dt
    LET g_ofa.ofa08 = g_oga.oga08
    LET g_ofa.ofa03 = g_oga.oga03
    LET g_ofa.ofa032= g_oga.oga032
    LET g_ofa.ofa033= g_oga.oga033
    LET g_ofa.ofa04 = g_oga.oga04
    LET g_ofa.ofa044= g_oga.oga044
    LET g_ofa.ofa16 = g_oga.oga16
    SELECT oea10 INTO g_ofa.ofa10 FROM oea_file
       WHERE oea01 = g_oga.oga16
    LET g_ofa.ofa21 = g_oga.oga21
    LET g_ofa.ofa211= g_oga.oga211
    LET g_ofa.ofa212= g_oga.oga212
    LET g_ofa.ofa213= g_oga.oga213
    LET g_ofa.ofa23 = g_oga.oga23
    IF g_ofa.ofa08='1' THEN
       LET exT=g_oaz.oaz52
    ELSE
       LET exT=g_oaz.oaz70
    END IF
    CALL s_curr3(g_ofa.ofa23,g_ofa.ofa02,exT)
         RETURNING g_ofa.ofa24
    LET g_ofa.ofa31 = g_oga.oga31
    LET g_ofa.ofa32 = g_oga.oga32
    LET g_ofa.ofa41 = g_oga.oga41
    LET g_ofa.ofa42 = g_oga.oga42
    LET g_ofa.ofa43 = g_oga.oga43
    LET g_ofa.ofa44 = g_oga.oga44
    LET g_ofa.ofa47 = g_oga.oga47
    LET g_ofa.ofa48 = g_oga.oga48
    LET g_ofa.ofa50 = 0
    LET g_ofa.ofaconf = 'N' #MOD-D20168 add
   #MOD-D40011---add---S
    INITIALIZE g_occ.* TO NULL 
    SELECT * INTO g_occ.* FROM occ_file WHERE occ01=g_ofa.ofa03
    LET g_ofa.ofa0351=g_occ.occ18
    LET g_ofa.ofa0352=g_occ.occ19
    LET g_ofa.ofa0353=g_occ.occ231
    LET g_ofa.ofa0354=g_occ.occ232
    LET g_ofa.ofa0355=g_occ.occ233
    LET g_ofa.ofa0356=g_occ.occ234  
    LET g_ofa.ofa0357=g_occ.occ235   

    CALL s_addr(g_ofa.ofa011,g_ofa.ofa04,g_ofa.ofa044)
         RETURNING l_oap.oap041,l_oap.oap042,l_oap.oap043,l_oap.oap044,l_oap.oap045    
    LET g_ofa.ofa0451=g_occ.occ18
    LET g_ofa.ofa0452=g_occ.occ19
    LET g_ofa.ofa0453=l_oap.oap041
    LET g_ofa.ofa0454=l_oap.oap042
    LET g_ofa.ofa0455=l_oap.oap043
    LET g_ofa.ofa0456=l_oap.oap044   
    LET g_ofa.ofa0457=l_oap.oap045 
   #MOD-D40011---add---E
 
    LET g_ofa.ofa01 = tm.slip
#   CALL s_auto_assign_no(g_sys,g_ofa.ofa01,g_ofa.ofa02,"55","ofa_file","ofa01","","","")
    CALL s_auto_assign_no("axm",g_ofa.ofa01,g_ofa.ofa02,"55","ofa_file","ofa01","","","")  #No.FUN-A40041
      RETURNING li_result,g_ofa.ofa01
    IF (NOT li_result) THEN
      RETURN
    END IF
    IF cl_null(begin_no) THEN
      LET begin_no = g_ofa.ofa01
    END IF
    LET end_no = g_ofa.ofa01
 
    LET g_ofa.ofaplant = g_plant 
    LET g_ofa.ofalegal = g_legal 
 
    LET g_ofa.ofaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_ofa.ofaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO ofa_file VALUES (g_ofa.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #NO.TQC-740217
      LET g_msg = g_ofa.ofa01 CLIPPED    #NO.TQC-740217
      CALL s_errmsg("ofa01",g_msg CLIPPED,'',SQLCA.SQLCODE,1)  #NO.TQC-740217
      LET g_success = 'N' RETURN
    END IF
    
    CALL p220_ins_ofb()
END FUNCTION
 
FUNCTION p220_ins_ofb()
   DEFINE l_ogb  RECORD LIKE ogb_file.*
 
   DECLARE p220_g_b_c1 CURSOR FOR
         SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
                                  AND ogb1005 = '1'
   FOREACH p220_g_b_c1 INTO l_ogb.*
     IF STATUS THEN EXIT FOREACH END IF
     INITIALIZE g_ofb.* TO NULL
     LET g_ofb.ofb01 = g_ofa.ofa01
     LET g_ofb.ofb03 = l_ogb.ogb03
     LET g_ofb.ofb31 = l_ogb.ogb31
     LET g_ofb.ofb32 = l_ogb.ogb32
     LET g_ofb.ofb04 = l_ogb.ogb04
     LET g_ofb.ofb05 = l_ogb.ogb05
     LET g_ofb.ofb06 = l_ogb.ogb06
     LET g_ofb.ofb11 = l_ogb.ogb11
     LET g_ofb.ofb12 = l_ogb.ogb12
     LET g_ofb.ofb13 = l_ogb.ogb13
     LET g_ofb.ofb14 = l_ogb.ogb14
     IF cl_null(g_ofb.ofb14) THEN LET g_ofb.ofb14 = 0 END IF
     LET g_ofb.ofb34 = l_ogb.ogb01  
     LET g_ofb.ofb35 = l_ogb.ogb03  
     LET g_ofb.ofb910= l_ogb.ogb910
     LET g_ofb.ofb911= l_ogb.ogb911
     LET g_ofb.ofb912= l_ogb.ogb912
     LET g_ofb.ofb913= l_ogb.ogb913
     LET g_ofb.ofb914= l_ogb.ogb914
     LET g_ofb.ofb915= l_ogb.ogb915
     LET g_ofb.ofb916= l_ogb.ogb916
     LET g_ofb.ofb917= l_ogb.ogb917
     CALL p220_b_else()
     MESSAGE g_ofb.ofb03,' ',g_ofb.ofb04,' ',g_ofb.ofb12
 
     LET g_ofb.ofbplant = g_plant 
     LET g_ofb.ofblegal = g_legal 
 
     INSERT INTO ofb_file VALUES(g_ofb.*)
     IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN   #NO.TQC-740217
        LET g_msg = g_ofb.ofb01 CLIPPED,"-",g_ofb.ofb03 USING "###"     #NO.TQC-740217
        CALL s_errmsg("ofb01",g_msg CLIPPED,'',SQLCA.SQLCODE,1)                       #NO.TQC-740217
        LET g_success = 'N' RETURN    
     END IF
   END FOREACH
   CALL p220_bu() 
END FUNCTION
 
FUNCTION p220_upd_ofa()
 
   SELECT SUM(ofb14) INTO g_ofa.ofa50 
     FROM ofb_file WHERE ofb01 = g_ofa.ofa01
   IF cl_null(g_ofa.ofa50) THEN LET g_ofa.ofa50 = 0 END IF
 
   UPDATE ofa_file SET ofa50=g_ofa.ofa50
    WHERE ofa01 = g_ofa.ofa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","",0)
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
 
FUNCTION p220_b_else()
   IF g_ofb.ofb04[1,4]!='MISC' THEN
      IF g_ofa.ofa213 = 'N' THEN
         LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13
         LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
      ELSE
         LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13
         LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
      END IF
   ELSE
      LET g_ofb.ofb14  = g_ofb.ofb917*g_ofb.ofb13
      LET g_ofb.ofb14t = g_ofb.ofb14
   END IF
   IF cl_null(g_ofb.ofb14) THEN LET g_ofb.ofb14 = 0 END IF
   IF cl_null(g_ofb.ofb14t) THEN LET g_ofb.ofb14t = 0 END IF
   CALL cl_digcut(g_ofb.ofb14,t_azi04) RETURNING g_ofb.ofb14  
   CALL cl_digcut(g_ofb.ofb14t,t_azi04)RETURNING g_ofb.ofb14t 
END FUNCTION
 
FUNCTION p220_bu()
    LET g_ofa.ofa50 = NULL
 
    SELECT SUM(ofb14) INTO g_ofa.ofa50 FROM ofb_file WHERE ofb01 = g_ofa.ofa01
    IF cl_null(g_ofa.ofa50) THEN LET g_ofa.ofa50 = 0 END IF
 
    UPDATE ofa_file SET (ofa50)=(g_ofa.ofa50)
     WHERE ofa01 = g_ofa.ofa01
    IF STATUS OR SQLCA.SQLCODE THEN
       LET g_success = 'N'
       CALL cl_err3("upd","ofa_file",g_ofa.ofa01,"",SQLCA.SQLCODE,"","_bu()upd ofa",1)  #No.FUN-660167
    END IF
END FUNCTION
 
FUNCTION p220_carry_ar()
  DEFINE l_i,l_n   LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
       IF NOT (g_oga1[l_i].ogaconf = 'Y' AND g_oga1[l_i].ogapost = 'Y') THEN
          LET g_oga1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n >  0 THEN
    IF NOT cl_confirm('axm-597') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_oga1[l_i].a = 'Y' THEN
      SELECT oga_file.* INTO  g_oga.* FROM oga_file
       WHERE oga01 = g_oga1[l_i].oga01
      CALL t600sub_gui(g_oga.*)
      SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga1[l_i].oga01
      LET g_oga1[l_i].oga10 = g_oga.oga10
    END IF
  END FOR
END FUNCTION
 
#出通單轉出貨單
FUNCTION p220_carry_dn()
 
 
#----------------------
  DEFINE 
          l_oga00     LIKE oga_file.oga00,
          l_oga01     LIKE oga_file.oga01,
          l_oga03     LIKE oga_file.oga03,  
          l_oga032    LIKE oga_file.oga032,
          l_oga033    LIKE oga_file.oga033,
          l_oga04     LIKE oga_file.oga04,
          l_oga044    LIKE oga_file.oga044,
          l_oga05     LIKE oga_file.oga05,
          l_oga06     LIKE oga_file.oga06,
          l_oga07     LIKE oga_file.oga07,
          l_oga08     LIKE oga_file.oga08,
          l_oga1001   LIKE oga_file.oga1001, 
          l_oga1002   LIKE oga_file.oga1002,
          l_oga1003   LIKE oga_file.oga1003,
          l_oga1004   LIKE oga_file.oga1004,
          l_oga1005   LIKE oga_file.oga1005,
          l_oga1009   LIKE oga_file.oga1009,
          l_oga1010   LIKE oga_file.oga1010,
          l_oga1011   LIKE oga_file.oga1011,
          l_oga1016   LIKE oga_file.oga1016,  
          l_oga14     LIKE oga_file.oga14,
          l_oga15     LIKE oga_file.oga15,
          l_oga161    LIKE oga_file.oga161,
          l_oga162    LIKE oga_file.oga162,
          l_oga163    LIKE oga_file.oga163,
          l_oga18     LIKE oga_file.oga18,
          l_oga21     LIKE oga_file.oga21,
          l_oga211    LIKE oga_file.oga211,
          l_oga212    LIKE oga_file.oga212,
          l_oga213    LIKE oga_file.oga213,
          l_oga23     LIKE oga_file.oga23,
          l_oga24     LIKE oga_file.oga24,
          l_oga25     LIKE oga_file.oga25,
          l_oga26     LIKE oga_file.oga26,
          l_oga31     LIKE oga_file.oga31,
          l_oga32     LIKE oga_file.oga32,
          l_oga41     LIKE oga_file.oga41,
          l_oga42     LIKE oga_file.oga42,
          l_oga43     LIKE oga_file.oga43,
          l_oga44     LIKE oga_file.oga44,
          l_oga45     LIKE oga_file.oga45,
          l_oga46     LIKE oga_file.oga46,
          l_oga909    LIKE oga_file.oga909,
          l_oga65     LIKE oga_file.oga65
  
  DEFINE l_buf1    LIKE oga_file.oga01        #單別
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_wc    STRING
  DEFINE l_cnt        LIKE type_file.num5    #TQC-970375
    
  LET begin_no = NULL
  LET end_no = NULL
  DECLARE p220_gfa_1 CURSOR FOR
   SELECT * FROM gfa_file 
    WHERE gfa01 = '2'  AND gfa03 ='axmt620'
  FOREACH p220_gfa_1 INTO g_gfa.*
     EXIT FOREACH
  END FOREACH

 
 
  OPEN WINDOW p220_exp_oga AT p_row,p_col WITH FORM "axm/42f/axmp220a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale("axmp220a")
  
  LET tm.slip = g_gfa.gfa05  #預設單據別
  LET tm.dt = g_today        
  LET tm.g = "3"
  DISPLAY BY NAME tm.slip,tm.dt,tm.g
  LET g_success = 'Y'
  BEGIN WORK
  CALL cl_set_act_visible("accept,cancel", TRUE)
  INPUT BY NAME tm.slip,tm.dt,tm.g  WITHOUT DEFAULTS
    AFTER FIELD slip
      IF NOT cl_null(tm.slip) THEN  
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM oay_file
          WHERE oayslip = tm.slip AND oaytype = '50' 
         IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
            LET g_cnt = 0
         END IF
         IF g_cnt = 0 THEN
            CALL cl_err(tm.slip,'aap-010',0)       
            NEXT FIELD slip
         END IF
         CALL s_check_no("axm",tm.slip,"",'50',"oga_file","oga01","")
            RETURNING li_result,tm.slip
         DISPLAY BY NAME tm.slip
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW p220_exp_oga
         RETURN
      END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
              CALL q_oay(FALSE,FALSE,'','50','AXM')   
                 RETURNING tm.slip
              DISPLAY BY NAME tm.slip   
              NEXT FIELD slip
            OTHERWISE EXIT CASE
         END CASE
  
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
  
        ON ACTION controlg      
           CALL cl_cmdask()     
  END INPUT
  CALL cl_set_act_visible("accept,cancel", FALSE)
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     LET g_success = 'N'
     ROLLBACK WORK      
     #CLOSE WINDOW p200_exp   #MOD-A80240 
     CLOSE WINDOW p220_exp_oga   #MOD-A80240 
     RETURN
  END IF
  CLOSE WINDOW p220_exp_oga
 
 
  LET l_wc = " oga01 in ("
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
     IF g_oga1[l_i].a = 'Y' THEN
        LET l_n = l_n + 1
        IF l_n = 1 THEN
          LET l_wc = l_wc CLIPPED,"'",g_oga1[l_i].oga01,"'"
        ELSE
          LET l_wc = l_wc CLIPPED,",'",g_oga1[l_i].oga01,"'"
        END IF
        #-----MOD-A50075---------
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file 
         WHERE oga01 = ogb01
           AND oga09 = '2'
           AND ogaconf != 'X' 
           AND ogb03 IS NOT NULL  
           AND oga011 = g_oga1[l_i].oga01  
        IF l_cnt > 0 THEN 
           CALL cl_err(g_oga1[l_i].oga01,'axm-652',1)   
           LET g_success = 'N'
           ROLLBACK WORK      
           RETURN
        END IF    
        #-----END MOD-A50075-----
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED ,")"
  
  CASE tm.g
    WHEN "1"   #客戶+預計出貨日 (oga03+obe1003)
     LET g_sql = "SELECT DISTINCT '','',ogb1003," 
    WHEN "2"   #客戶+單別      (oga03+substr(oga01,1,aza41)  #依系統設定抓單據位數
     LET g_sql = "SELECT DISTINCT oga01[1,",t_aza41,"],'','',"     #No.FUN-9B0043
    WHEN "3"   #不匯總         (oea01)
      LET g_sql = "SELECT DISTINCT '',oga01,'',"
  END CASE 
 
  LET g_sql = g_sql ,"oga00,  oga03,  oga04,",
                     "oga05,  oga07,  oga08,",
                     "oga1002,oga1003,oga1004,oga1005,",
                     "oga1009,oga1010,oga1011,oga1016,oga14,",
                     "oga15,  oga161, oga162, oga163, oga18,",
                     "oga21,  oga211, oga212, oga213, oga23,",
                     "oga24,  oga25,  oga26,  oga31,  oga32,",
                     "oga41,  oga42,  oga43,  oga44,  oga45,",
                     "oga46,  oga909, oga65 ",                      
                     "  FROM  oga_file,ogb_file ",
                     " WHERE oga01 = ogb01 ",
                     "    AND oga09 = '1' AND ogaconf = 'Y' ",
                     " AND oga01 NOT IN" ,
                     "(SELECT oga011  ",
                     "   FROM oga_file,ogb_file ",
                     "  WHERE oga01 = ogb01 AND oga09 IN ('2','3','4','6') ", 
                     "    AND ogaconf <> 'X' AND oga011 IS NOT NULL) " ,
                     "   AND ",l_wc 
  IF tm.g = "3" THEN
   LET g_sql = g_sql ,"  ORDER BY oga01"
  END IF
  PREPARE oga_pre FROM g_sql
  DECLARE oga_cur2 CURSOR FOR oga_pre
  FOREACH oga_cur2 INTO  l_buf1 ,  l_oga01,  g_ogb1003,
                         l_oga00,  l_oga03,  l_oga04,
                         l_oga05,  l_oga07,  l_oga08,
                         l_oga1002,l_oga1003,l_oga1004,l_oga1005,
                         l_oga1009,l_oga1010,l_oga1011,l_oga1016,l_oga14,
                         l_oga15,  l_oga161, l_oga162, l_oga163, l_oga18,
                         l_oga21,  l_oga211, l_oga212, l_oga213, l_oga23,
                         l_oga24,  l_oga25,  l_oga26,  l_oga31,  l_oga32,
                         l_oga41,  l_oga42,  l_oga43,  l_oga44,  l_oga45,
                         l_oga46,  l_oga909, l_oga65              
                                       
        ###在這一個foreach迴圈中就已經決定了要併成幾張出通/出貨單
         LET g_ws2 = ' '
         IF NOT cl_null(l_oga04) THEN 
            LET g_ws2 = g_ws2,"   AND oga04 = '", l_oga04,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga04 IS NULL "
         END IF
         IF NOT cl_null(l_oga05) THEN 
            LET g_ws2 = g_ws2,"   AND oga05 = '", l_oga05,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga05 IS NULL "
         END IF
         IF NOT cl_null(l_oga07) THEN 
            LET g_ws2 = g_ws2,"   AND oga07 = '", l_oga07,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga07 IS NULL "
         END IF
         IF NOT cl_null(l_oga08) THEN 
            LET g_ws2 = g_ws2,"   AND oga08 = '", l_oga08,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga08 IS NULL "
         END IF
         IF NOT cl_null(l_oga1002) THEN 
            LET g_ws2 = g_ws2,"   AND oga1002 = '", l_oga1002,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1002 IS NULL "
         END IF
         IF NOT cl_null(l_oga1003) THEN 
            LET g_ws2 = g_ws2,"   AND oga1003 = '", l_oga1003,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1003 IS NULL "
         END IF
         IF NOT cl_null(l_oga1004) THEN 
            LET g_ws2 = g_ws2,"   AND oga1004 = '", l_oga1004,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1004 IS NULL "
         END IF
         IF NOT cl_null(l_oga1005) THEN 
            LET g_ws2 = g_ws2,"   AND oga1005 = '", l_oga1005,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1005 IS NULL "
         END IF
         IF NOT cl_null(l_oga1009) THEN 
            LET g_ws2 = g_ws2,"   AND oga1009 = '", l_oga1009,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1009 IS NULL "
         END IF
         IF NOT cl_null(l_oga1010) THEN 
            LET g_ws2 = g_ws2,"   AND oga1010 = '", l_oga1010,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1010 IS NULL "
         END IF
         IF NOT cl_null(l_oga1011) THEN 
            LET g_ws2 = g_ws2,"   AND oga1011 = '", l_oga1011,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga1011 IS NULL "
         END IF
         IF NOT cl_null(l_oga1016) THEN    #MOD-A50075 
            LET g_ws2 = g_ws2,"   AND oga1016 = '", l_oga1016,"'"
         ELSE    #MOD-A50075 
           #LET g_ws2 = g_ws2, "  AND oga1016 IS NULL "   #MOD-A50075 #MOD-D30253 mark
            LET g_ws2 = g_ws2, "  AND (oga1016 IS NULL OR oga1016 = ' ' ) "   #MOD-D30253 add
         END IF   #MOD-A50075 
         IF NOT cl_null(l_oga14) THEN 
            LET g_ws2 = g_ws2,"   AND oga14= '", l_oga14,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga14 IS NULL "
         END IF
         IF NOT cl_null(l_oga15) THEN 
            LET g_ws2 = g_ws2,"   AND oga15= '", l_oga15,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga15 IS NULL "
         END IF
         IF NOT cl_null(l_oga161) THEN 
            LET g_ws2 = g_ws2,"   AND oga161= ", l_oga161
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga161 IS NULL "
         END IF
         IF NOT cl_null(l_oga162) THEN 
            LET g_ws2 = g_ws2,"   AND oga162= ", l_oga162
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga162 IS NULL "
         END IF
         IF NOT cl_null(l_oga163) THEN 
            LET g_ws2 = g_ws2,"   AND oga163= ", l_oga163
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga163 IS NULL "
         END IF
         IF NOT cl_null(l_oga18) THEN 
            LET g_ws2 = g_ws2,"   AND oga18= '", l_oga18,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga18 IS NULL "
         END IF
         IF NOT cl_null(l_oga21) THEN 
            LET g_ws2 = g_ws2,"   AND oga21= '", l_oga21,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga21 IS NULL "
         END IF
         IF NOT cl_null(l_oga211) THEN 
            LET g_ws2 = g_ws2,"   AND oga211= ", l_oga211
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga211 IS NULL "
         END IF
         IF NOT cl_null(l_oga212) THEN 
            LET g_ws2 = g_ws2,"   AND oga212= '", l_oga212,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga212 IS NULL "
         END IF
         IF NOT cl_null(l_oga213) THEN 
            LET g_ws2 = g_ws2,"   AND oga213= '", l_oga213,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga213 IS NULL "
         END IF
         IF NOT cl_null(l_oga23) THEN 
            LET g_ws2 = g_ws2,"   AND oga23= '", l_oga23,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga23 IS NULL "
         END IF
         IF NOT cl_null(l_oga24) THEN 
            LET g_ws2 = g_ws2,"   AND oga24= ", l_oga24
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga24 IS NULL "
         END IF
         IF NOT cl_null(l_oga25) THEN 
            LET g_ws2 = g_ws2,"   AND oga25= '", l_oga25,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga25 IS NULL "
         END IF
         IF NOT cl_null(l_oga26) THEN 
            LET g_ws2 = g_ws2,"   AND oga26= '", l_oga26,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga26 IS NULL "
         END IF
         IF NOT cl_null(l_oga31) THEN 
            LET g_ws2 = g_ws2,"   AND oga31= '", l_oga31,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga31 IS NULL "
         END IF
         IF NOT cl_null(l_oga32) THEN 
            LET g_ws2 = g_ws2,"   AND oga32= '", l_oga32,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga32 IS NULL "
         END IF
         IF NOT cl_null(l_oga41) THEN 
            LET g_ws2 = g_ws2,"   AND oga41= '", l_oga41,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga41 IS NULL "
         END IF
         IF NOT cl_null(l_oga42) THEN 
            LET g_ws2 = g_ws2,"   AND oga42= '", l_oga42,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga42 IS NULL "
         END IF
         IF NOT cl_null(l_oga43) THEN 
            LET g_ws2 = g_ws2,"   AND oga43= '", l_oga43,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga43 IS NULL "
         END IF
         IF NOT cl_null(l_oga44) THEN 
            LET g_ws2 = g_ws2,"   AND oga44= '", l_oga44,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga44 IS NULL "
         END IF
         IF NOT cl_null(l_oga45) THEN 
            LET g_ws2 = g_ws2,"   AND oga45= '", l_oga45,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga45 IS NULL "
         END IF
         IF NOT cl_null(l_oga46) THEN 
            LET g_ws2 = g_ws2,"   AND oga46= '", l_oga46,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga46 IS NULL "
         END IF
         IF NOT cl_null(l_oga909) THEN 
            LET g_ws2 = g_ws2,"   AND oga909= '", l_oga909,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga909 IS NULL "
         END IF
         IF NOT cl_null(l_oga65) THEN 
            LET g_ws2 = g_ws2,"   AND oga65= '", l_oga65,"'"
         ELSE 
            LET g_ws2 = g_ws2, "  AND oga65 IS NULL "
         END IF
 
      CASE tm.g
        WHEN "1"  #依客戶+日期
          LET g_sql = "SELECT oga_file.* FROM oga_file,ogb_file",
                      " WHERE oga01 = ogb01 "
 
          LET g_ws1 = " AND oga03 = '", l_oga03,"'",
                      " AND ogb1003 = '", g_ogb1003,"' ",                            #TQC-780059
                      " AND ",l_wc,
                      " AND oga01 NOT IN" ,
                      "(SELECT oga011  ",
                      "   FROM oga_file,ogb_file ",
                      "  WHERE oga01 = ogb01 AND oga09 IN ('2','3','4','6') ", 
                      "    AND ogaconf <> 'X' AND oga011 IS NOT NULL) " ,
                      " AND oga00 = '", l_oga00,"'"
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "2"  #依客戶+單別
          LET g_sql = "SELECT oga_file.* FROM oga_file,ogb_file ",
                      " WHERE oga01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",    #No.FUN-9B0043
                      "   AND oga01 = ogb01"
          LET g_ws1 = "   AND oga03 = '", l_oga03,"'",
                      "   AND ",l_wc,
                      " AND oga01 NOT IN" ,
                      "(SELECT oga011  ",
                      "   FROM oga_file,ogb_file ",
                      "  WHERE oga01 = ogb01 AND oga09 IN ('2','3','4','6') ", 
                      "    AND ogaconf <> 'X' AND oga011 IS NOT NULL) " ,
                      " AND oga00 = '", l_oga00,"'"
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "3"  #不匯總   
          LET g_sql = "SELECT * FROM oga_file ",
                      " WHERE oga01 ='", l_oga01, "'"
      END CASE
 
      LET g_wc_oga = NULL   
      PREPARE oga_pre1  FROM g_sql
      DECLARE p220_oga_cs                         #SCROLL CURSOR
        SCROLL CURSOR FOR oga_pre1
      FOREACH p220_oga_cs INTO g_oga3.*
         IF cl_null(g_wc_oga) THEN
           LET g_wc_oga = " oga01 IN('",g_oga3.oga01,"'"
         ELSE
           LET g_wc_oga = g_wc_oga,",'",g_oga3.oga01,"'"
         END IF
      END FOREACH
      IF NOT cl_null(g_wc_oga) THEN LET g_wc_oga=g_wc_oga,")" END IF
     #-----MOD-A50075---------
     #SELECT COUNT(oga01) INTO l_cnt FROM oga_file,ogb_file
     # WHERE oga01 = ogb01
     #   AND oga09 = '2'
     #   AND ogaconf != 'X'
     #   AND ogb03 IS NOT NULL 
     #   AND oga011 = g_oga3.oga01  
     #IF l_cnt > 0 THEN 
     #   CALL s_errmsg('','','','axm-652',1)   
     #   LET g_success = 'N'
     #   EXIT FOREACH 
     #END IF    
     #-----END MOD-A50075-----

      CALL p220_ins_oga()
      CALL p220_upd_oga()
      IF g_success = 'N' THEN
        EXIT FOREACH
      END IF
  END FOREACH
 
 
  IF g_success = 'N' THEN
     MESSAGE 'Failure..'
     ROLLBACK WORK
     CALL s_showmsg()       #NO.TQC-740217
  ELSE
     COMMIT WORK
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
END FUNCTION
 
FUNCTION p220_ins_oga()
   DEFINE l_oax01   LIKE oax_file.oax01,   #三角貿易使用匯率 S/B/C/D      #NO.FUN-670007
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             
          exT       LIKE type_file.chr1,             
          l_date1   LIKE type_file.dat,              
          l_date2   LIKE type_file.dat               
   DEFINE l_ogb03   LIKE type_file.num5
   DEFINE l_date3   LIKE type_file.dat  
   DEFINE l_i       LIKE type_file.num5
   DEFINE l_oga032  LIKE oga_file.oga032   #MOD-C20145 add
 
   #Default初植
   LET g_oga2.oga00  = g_oga3.oga00
   LET g_oga2.oga011 = g_oga3.oga01    
   LET g_oga2.oga021 = tm.dt
   LET g_oga2.oga03  = g_oga3.oga03
   LET g_oga2.oga032 = g_oga3.oga032
   LET g_oga2.oga033 = g_oga3.oga033
   LET g_oga2.oga04  = g_oga3.oga04
   LET g_oga2.oga044 = g_oga3.oga044
   LET g_oga2.oga05  = g_oga3.oga05
   LET g_oga2.oga06  = g_oga3.oga06
   LET g_oga2.oga07  = g_oga3.oga07
   LET g_oga2.oga08  = g_oga3.oga08
   LET g_oga2.oga09  = '2'             #單據別:一般出貨單
   LET g_oga2.oga1001= g_oga3.oga1001
   LET g_oga2.oga1002= g_oga3.oga1002
   LET g_oga2.oga1003= g_oga3.oga1003
   LET g_oga2.oga1004= g_oga3.oga1004
   LET g_oga2.oga1005= g_oga3.oga1005
   LET g_oga2.oga1009= g_oga3.oga1009
   LET g_oga2.oga1010= g_oga3.oga1010
   LET g_oga2.oga1011= g_oga3.oga1011
   LET g_oga2.oga1016= g_oga3.oga1016   
   LET g_oga2.oga14  = g_oga3.oga14
   LET g_oga2.oga15  = g_oga3.oga15
   LET g_oga2.oga16  = g_oga3.oga16
   LET g_oga2.oga161 = g_oga3.oga161
   LET g_oga2.oga162 = g_oga3.oga162
   LET g_oga2.oga163 = g_oga3.oga163
   LET g_oga2.oga18  = g_oga3.oga18
   LET g_oga2.oga21  = g_oga3.oga21
   LET g_oga2.oga211 = g_oga3.oga211
   LET g_oga2.oga212 = g_oga3.oga212
   LET g_oga2.oga213 = g_oga3.oga213
   LET g_oga2.oga23  = g_oga3.oga23
   LET g_oga2.oga24  = g_oga3.oga24
   LET g_oga2.oga25  = g_oga3.oga25
   LET g_oga2.oga26  = g_oga3.oga26
   LET g_oga2.oga31  = g_oga3.oga31
   LET g_oga2.oga32  = g_oga3.oga32
   LET g_oga2.oga41  = g_oga3.oga41
   LET g_oga2.oga42  = g_oga3.oga42
   LET g_oga2.oga43  = g_oga3.oga43
   LET g_oga2.oga44  = g_oga3.oga44
   LET g_oga2.oga45  = g_oga3.oga45
   LET g_oga2.oga46  = g_oga3.oga46
   LET g_oga2.oga909 = g_oga3.oga909
   LET g_oga2.oga65  = g_oga3.oga65
 
   LET g_oga2.oga69  = g_today            #輸入日期  #TQC-780007
   LET g_oga2.oga02  = tm.dt            #出貨日期   #MOD-980271
   LET g_oga2.oga022 = ''                 #裝船日期
   LET g_oga2.oga10  = ''                 #帳單編號
   LET g_oga2.oga1006= 0
   LET g_oga2.oga1013= 'N'
   SELECT occ67 INTO g_oga2.oga13 FROM occ_file WHERE occ01=g_oga2.oga03  
   IF cl_null(g_oga2.oga13) THEN LET g_oga2.oga13  = '' END IF             
   LET g_oga2.oga17  = ''                 #排貨模擬順序 
   LET g_oga2.oga20  = 'Y'                #分錄底稿是否可重新產生
   LET g_oga2.oga27  = g_oga3.oga27       #Invoice No.   #MOD-870180
   LET g_oga2.oga28  = ''                 #立帳時采用訂單匯率
   LET g_oga2.oga29  = ''                 #信用額度余額
   LET g_oga2.oga30  = 'N'                #包裝單確認碼
   LET g_oga2.oga50  = 0                  #原幣出貨金額
   LET g_oga2.oga501 = 0                  #本幣出貨金額
   LET g_oga2.oga51  = 0                  #原幣出貨金額(含稅)
   LET g_oga2.oga511 = 0                  #本幣出貨金額 
   LET g_oga2.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
   LET g_oga2.oga53  = 0                  #原幣應開發票未稅金額
   LET g_oga2.oga54  = 0                  #原幣已開發票未稅金額 
   LET g_oga2.oga55  = '0'                #狀態
   LET g_oga2.oga905 = 'N'                #已轉三角貿易出貨單否
   LET g_oga2.oga906 = 'Y'                #起始出貨單否
   LET g_oga2.oga99  = ''                 #多角貿易流程序號
   LET g_oga2.ogaconf= 'N'                #確認否/作廢碼
   LET g_oga2.ogapost= 'N'                #出貨扣帳否
   LET g_oga2.ogaprsw= 0                  #列印次數
   LET g_oga2.ogauser= g_user             #資料所有者
   LET g_oga2.ogagrup= g_grup             #資料所有部門
   LET g_oga2.ogamodu= ''                 #資料修改者
   LET g_oga2.ogadate= g_today            #最近修改日
   LET g_oga2.ogamksg= 'N'                #簽核
   #帳款客戶簡稱,帳款客戶統一編號
   SELECT occ02,occ11    
     #INTO g_oga2.oga032,g_oga2.oga033 #MOD-C20145 mark
     INTO l_oga032,g_oga2.oga033       #MOD-C20145 add
     FROM occ_file
    WHERE occ01 = g_oga2.oga03
   #MOD-C20145 ----- add start -----
   IF cl_null(g_oga2.oga032) THEN
      LET g_oga2.oga032 = l_oga032
   END IF
   #MOD-C20145 ----- add end -----
   #待扺帳款-預收單號
   SELECT oma01 INTO g_oga2.oga19 
     FROM oma_file 
    WHERE oma10 = g_oga2.oga16
   #應收款日,容許票據到期日
    IF NOT cl_null(g_oga2.oga16) THEN                                                                                                 
       SELECT oea02 INTO l_date3 FROM oea_file 
        WHERE oea01 = g_oga2.oga16                                                              
    ELSE                                                                                                                             
       LET l_date3 = g_oga2.oga02                                                                                                      
    END IF                                                                                                                           
   CALL s_rdatem(g_oga2.oga03,g_oga2.oga32,g_oga2.oga02,g_oga2.oga02,
                 l_date3,g_plant2)                    #FUN-980020
      RETURNING l_date1,l_date2
   IF cl_null(g_oga2.oga11) THEN 
      LET g_oga2.oga11 = l_date1 
   END IF
   IF cl_null(g_oga2.oga12) THEN 
      LET g_oga2.oga12 = l_date2 
   END IF
   IF cl_null(g_oga2.oga85) THEN
      LET g_oga2.oga85=' '
   END IF
   IF cl_null(g_oga2.oga94) THEN
      LET g_oga2.oga94='N'
   END IF
   
   #FUN-AC0077 add ---------------------begin-----------------------
   IF cl_null(g_oga2.oga57) THEN
      LET g_oga2.oga57 = '1'  
   END IF
   #FUN-AC0077 add ----------------------end------------------------   

   CALL s_auto_assign_no("axm",tm.slip,g_oga2.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,g_oga2.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_oga2.ogaplant = g_plant 
   LET g_oga2.ogalegal = g_legal 
 
   LET g_oga2.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga2.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES(g_oga2.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','','',SQLCA.sqlcode,1)      
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(begin_no) THEN 
      LET begin_no = g_oga2.oga01
   END IF
   LET end_no=g_oga2.oga01

  #FUN-D30083---add---S
   DROP TABLE b
   SELECT * FROM idb_file WHERE idb07 = g_oga3.oga01 INTO TEMP b
   UPDATE b SET idb07 = g_oga2.oga01
   INSERT INTO idb_file SELECT * FROM b
  #FUN-D30083---add---E
 
   CASE tm.g
    WHEN "1"  #依客戶+出貨日
      LET g_sql = "SELECT COUNT(*) FROM ogb_file,oga_file ",
                  " WHERE ogb01=oga01 ",g_ws1 CLIPPED,g_ws2 CLIPPED   #MOD-A50075 add g_ws2
      PREPARE xx_pre FROM g_sql
      EXECUTE xx_pre INTO l_i
      DISPLAY 'ogb3 count:', l_i
      LET g_sql = "SELECT ogb_file.* FROM ogb_file,oga_file ",
                  " WHERE ogb01 = oga01 "
      LET g_sql = g_sql, g_ws1 CLIPPED,g_ws2 CLIPPED   #MOD-A50075 add g_ws2
    WHEN "2"  #依客戶+單別
      LET g_sql = "SELECT COUNT(*) FROM ogb_file,oga_file ",
                  " WHERE ogb01=oga01 ",g_ws1 CLIPPED,g_ws2 CLIPPED   #MOD-A50075 add g_ws2
      PREPARE xxx_pre FROM g_sql
      EXECUTE xxx_pre INTO l_i
      DISPLAY 'ogb3 count:', l_i
      LET g_sql = "SELECT ogb_file.* FROM ogb_file,oga_file ",
                  " WHERE ogb01 = oga01 "
      LET g_sql = g_sql, g_ws1 CLIPPED,g_ws2 CLIPPED   #MOD-A50075 add g_ws2
      LET g_sql = g_sql, " ORDER BY ogb01 DESC"
    WHEN "3"  #不匯總
      LET g_sql = "SELECT * FROM ogb_file WHERE ogb01 = '",g_oga3.oga01,"' "
   END CASE
    
   LET l_ogb03 = 0
   PREPARE p220_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p220_cs1 CURSOR  FOR p220_prepare1
   FOREACH p220_cs1 INTO g_ogb3.* 
         LET l_ogb03 = l_ogb03 + 1
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            RETURN 
         END IF
 
         LET g_ogb2.ogb03  = l_ogb03     #項次
         CALL p220_ins_ogb()
         INITIALIZE g_ogb2.* TO NULL   #DEFAULT 設定
         INITIALIZE g_ogb3.* TO NULL   #DEFAULT 設定
   END FOREACH
   IF tm.g = '3' THEN 
      DROP TABLE x
      SELECT * FROM ogc_file WHERE ogc01 = g_oga3.oga01 INTO TEMP x
      UPDATE x SET ogc01=g_oga2.oga01
      INSERT INTO ogc_file SELECT * FROM x
      
      DROP TABLE x
      SELECT * FROM oao_file WHERE oao01 = g_oga3.oga01 INTO TEMP x
      UPDATE x SET oao01=g_oga2.oga01
      INSERT INTO oao_file SELECT * FROM x
      
      DROP TABLE x
      SELECT * FROM oap_file WHERE oap01 = g_oga3.oga01 INTO TEMP x
      UPDATE x SET oap01=g_oga2.oga01
      INSERT INTO oap_file SELECT * FROM x
   END IF

END FUNCTION
 
FUNCTION p220_ins_ogb()
   DEFINE l_flag   LIKE type_file.num5,           
          l_ima25  LIKE ima_file.ima25
   DEFINE l_rxc    RECORD LIKE rxc_file.* #FUN-AB0061
 
   #Default初植
    LET g_ogb2.ogb01  = g_oga2.oga01
    LET g_ogb2.ogb04  = g_ogb3.ogb04
    LET g_ogb2.ogb05  = g_ogb3.ogb05
    LET g_ogb2.ogb05_fac = g_ogb3.ogb05_fac
    LET g_ogb2.ogb06  = g_ogb3.ogb06     
    LET g_ogb2.ogb07  = g_ogb3.ogb07
    LET g_ogb2.ogb08  = g_ogb3.ogb08
    LET g_ogb2.ogb09  = g_ogb3.ogb09
    LET g_ogb2.ogb091 = g_ogb3.ogb091
    LET g_ogb2.ogb092 = g_ogb3.ogb092
    LET g_ogb2.ogb1001= g_ogb3.ogb1001
    LET g_ogb2.ogb1002= g_ogb3.ogb1002
    LET g_ogb2.ogb1003= g_ogb3.ogb1003
    LET g_ogb2.ogb1004= g_ogb3.ogb1004
    LET g_ogb2.ogb1005= g_ogb3.ogb1005
    LET g_ogb2.ogb1006= g_ogb3.ogb1006
    LET g_ogb2.ogb1007= g_ogb3.ogb1007
    LET g_ogb2.ogb1008= g_ogb3.ogb1008
    LET g_ogb2.ogb1009= g_ogb3.ogb1009
    LET g_ogb2.ogb1010= g_ogb3.ogb1010
    LET g_ogb2.ogb1011= g_ogb3.ogb1011                
    LET g_ogb2.ogb1012= g_ogb3.ogb1012                
    LET g_ogb2.ogb11  = g_ogb3.ogb11
    LET g_ogb2.ogb12  = g_ogb3.ogb12 
    LET g_ogb2.ogb13  = g_ogb3.ogb13
    LET g_ogb2.ogb14  = g_ogb3.ogb14
    LET g_ogb2.ogb14t = g_ogb3.ogb14t 
    LET g_ogb2.ogb31  = g_ogb3.ogb31  
    LET g_ogb2.ogb32  = g_ogb3.ogb32  
    LET g_ogb2.ogb908 = g_ogb3.ogb908
    LET g_ogb2.ogb910 = g_ogb3.ogb910
    LET g_ogb2.ogb911 = g_ogb3.ogb911
    LET g_ogb2.ogb912 = g_ogb3.ogb912
    LET g_ogb2.ogb913 = g_ogb3.ogb913
    LET g_ogb2.ogb914 = g_ogb3.ogb914
    LET g_ogb2.ogb915 = g_ogb3.ogb915
    LET g_ogb2.ogb916 = g_ogb3.ogb916
    LET g_ogb2.ogb917 = g_ogb3.ogb917
    LET g_ogb2.ogb19  = g_ogb3.ogb19
#FUN-AB0061 -----------add start---------------- 
    LET g_ogb2.ogb47 = g_ogb3.ogb47                              
    LET g_ogb2.ogb48 = g_ogb3.ogb48                              
    LET g_ogb2.ogb49 = g_ogb3.ogb49                              
    #LET g_ogb2.ogb50 = g_ogb3.ogb50   #FUN-AC0055 mark                           
    LET g_ogb2.ogb37 = g_ogb3.ogb37                              
    IF cl_null(g_ogb2.ogb37) OR g_ogb2.ogb37=0 THEN           
       LET g_ogb2.ogb37=g_ogb2.ogb13                         
    END IF                                                                             
#FUN-AB0061 -----------add end----------------  
    IF tm.g = '3' THEN 
       LET g_ogb2.ogb17 = g_ogb3.ogb17
    ELSE
       LET g_ogb2.ogb17 = 'N'
    END IF
    LET g_ogb2.ogb60  = 0               #已開發票數量
    LET g_ogb2.ogb63  = 0               #銷退數量
    LET g_ogb2.ogb64  = 0               #銷退數量 (不需換貨出貨)
    LET g_ogb2.ogb930 = g_oeb.oeb930    #FUN-680006
    LET g_ogb2.ogb1014   = 'N'                 #保稅放行否  #FUN-6B0044
    LET g_ogb2.ogb41  = g_ogb3.ogb41
    LET g_ogb2.ogb42  = g_ogb3.ogb42
    LET g_ogb2.ogb43  = g_ogb3.ogb43
    IF cl_null(g_ogb2.ogb091) THEN LET g_ogb2.ogb091 = ' ' END IF  #出貨儲位編號
    IF cl_null(g_ogb2.ogb092) THEN LET g_ogb2.ogb092 = ' ' END IF  #出貨批號
    IF g_ogb2.ogb1005 = '1' THEN        #出貨
       #庫存明細單位由廠/倉/儲/批自動得出
       SELECT img09  INTO g_ogb2.ogb15 
         FROM img_file
        WHERE img01 = g_ogb2.ogb04 
          AND img02 = g_ogb2.ogb09 
          AND img03 = g_ogb2.ogb091
          AND img04 = g_ogb2.ogb092
       CALL s_umfchk(g_ogb2.ogb04,g_ogb2.ogb05,g_ogb2.ogb15) 
          RETURNING l_flag,g_ogb2.ogb15_fac
       IF l_flag > 0 THEN 
          LET g_ogb2.ogb15_fac = 1 
       END IF
       #銷售/庫存匯總單位換算率
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ogb2.ogb04
       CALL s_umfchk(g_ogb2.ogb04,g_ogb2.ogb05,l_ima25)
          RETURNING l_flag,g_ogb2.ogb05_fac
       IF l_flag > 0 THEN 
          LET g_ogb2.ogb05_fac = 1
       END IF
       LET g_ogb2.ogb16 = g_ogb2.ogb12 * g_ogb2.ogb15_fac  #數量
       LET g_ogb2.ogb18 = g_ogb2.ogb12                    #預計出貨數量  
       #更新出貨單頭檔
       LET g_oga2.oga50  = g_oga2.oga50 + g_ogb2.ogb14     #原幣出貨金額
       LET g_oga2.oga51  = g_oga2.oga51 + g_ogb2.ogb14t    #原幣出貨金額(含稅)
       LET g_oga2.oga1008= g_oga2.oga1008 + g_ogb2.ogb14t
    ELSE
       LET g_oga2.oga1006= g_oga2.oga1006 + g_ogb2.ogb14
       LET g_oga2.oga1007= g_oga2.oga1007 + g_ogb2.ogb14t
    END IF
    IF cl_null(g_ogb2.ogb18) THEN
       LET g_ogb2.ogb18 = 0
    END IF
    IF cl_null(g_ogb2.ogb16) THEN
       LET g_ogb2.ogb16 = 0
    END IF
    IF cl_null(g_ogb2.ogb15) THEN
       LET g_ogb2.ogb15 = g_ogb2.ogb05 
    END IF
    LET g_ogb2.ogb16 = s_digqty(g_ogb2.ogb16,g_ogb2.ogb15) #FUN-BB0083 add
    IF cl_null(g_ogb2.ogb15_fac) THEN
       LET g_ogb2.ogb15_fac = 1 
    END IF
   IF cl_null(g_ogb2.ogb44) THEN
      LET g_ogb2.ogb44='1'
   END IF
   IF cl_null(g_ogb2.ogb47) THEN
      LET g_ogb2.ogb47=0
   END IF
 
   LET g_ogb2.ogbplant = g_plant 
   LET g_ogb2.ogblegal = g_legal 
  #FUN-AC0055 mark ---------------------begin-----------------------
  ##FUN-AB0096 --------------add start-----------------
  # IF cl_null(g_ogb2.ogb50) THEN
  #    LET g_ogb2.ogb50 = '1'
  # END IF
  ##FUN-AB0096 --------------add end---------------------  
  #FUN-AC0055 mark ----------------------end------------------------
   #FUN-C50097 ADD BEGIN-----
   IF cl_null(g_ogb2.ogb50) THEN
     LET g_ogb2.ogb50 = 0
   END IF
   IF cl_null(g_ogb2.ogb51) THEN
     LET g_ogb2.ogb51 = 0
   END IF
   IF cl_null(g_ogb2.ogb52) THEN
     LET g_ogb2.ogb52 = 0
   END IF
   IF cl_null(g_ogb2.ogb53) THEN
     LET g_ogb2.ogb53 = 0
   END IF
   IF cl_null(g_ogb2.ogb54) THEN
     LET g_ogb2.ogb54 = 0
   END IF
   IF cl_null(g_ogb2.ogb55) THEN
     LET g_ogb2.ogb55 = 0
   END IF   
   #FUN-C50097 ADD END-------   
   #FUN-CB0087--add--str--
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(g_ogb2.ogb01,g_ogb2.ogb31,'',g_ogb2.ogb04,g_ogb2.ogb09,g_oga2.oga14,g_oga2.oga15) RETURNING g_ogb2.ogb1001
      IF cl_null(g_ogb2.ogb1001) THEN
         CALL cl_err(g_ogb2.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   INSERT INTO ogb_file VALUES(g_ogb2.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p220_ins_ogb():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   ELSE
     #FUN-AB0061 Begin--- Add By shi
      IF g_ogb2.ogb47 > 0 THEN
         LET l_rxc.rxc00 = '02'
         LET l_rxc.rxc01 = g_ogb2.ogb01
         LET l_rxc.rxc02 = g_ogb2.ogb03
         LET l_rxc.rxcplant = g_ogb2.ogbplant
         LET l_rxc.rxclegal = g_ogb2.ogblegal
         DECLARE cur_rxc01 CURSOR FOR
            SELECT rxc03,rxc04,rxc05,rxc06,rxc07,rxc08,rxc09,rxc10,rxc11,rxc15
             FROM rxc_file WHERE rxc00 = '01'
              AND rxc01 = g_ogb3.ogb01 AND rxc02 = g_ogb3.ogb03
         FOREACH cur_rxc01 INTO l_rxc.rxc03,l_rxc.rxc04,l_rxc.rxc05,l_rxc.rxc06,
                                l_rxc.rxc07,l_rxc.rxc08,l_rxc.rxc09,l_rxc.rxc10,
                                l_rxc.rxc11,l_rxc.rxc15
             IF l_rxc.rxc06 IS NULL THEN LET l_rxc.rxc06 = 0 END IF
             IF l_rxc.rxc09 IS NULL THEN LET l_rxc.rxc09 = 0 END IF
             IF l_rxc.rxc11 IS NULL THEN LET l_rxc.rxc11 = 'N' END IF
             INSERT INTO rxc_file(rxc00,rxc01,rxc02,rxc03,rxc04,rxc05,rxc06,
                                   rxc07,rxc08,rxc09,rxc10,rxc11,rxcplant,rxclegal,rxc15)
                            VALUES(l_rxc.rxc00,l_rxc.rxc01,l_rxc.rxc02,l_rxc.rxc03,
                                   l_rxc.rxc04,l_rxc.rxc05,l_rxc.rxc06,l_rxc.rxc07,
                                   l_rxc.rxc08,l_rxc.rxc09,l_rxc.rxc10,l_rxc.rxc11,
                                   l_rxc.rxcplant,l_rxc.rxclegal,l_rxc.rxc15)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('','',"p220_ins_ogb() ins_rxc:",SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
     #FUN-AB0061 End-----
      IF NOT s_industry('std') THEN
         LET g_ogbi2.ogbi01 = g_ogb2.ogb01
         LET g_ogbi2.ogbi03 = g_ogb2.ogb03
         IF NOT s_ins_ogbi(g_ogbi2.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
    CALL p220_ins_rvbs()                                    #FUN-870146
   END IF
END FUNCTION
 
FUNCTION p220_upd_oga()
   DEFINE l_cnt   LIKE type_file.num5   #MOD-870182
 
   UPDATE oga_file SET oga50   = g_oga2.oga50,
                       oga51   = g_oga2.oga51,
                       oga1006 = g_oga2.oga1006,
                       oga1007 = g_oga2.oga1007,
                       oga1008 = g_oga2.oga1008
                 WHERE oga01   = g_oga2.oga01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p220_upd_oga():",SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN
   END IF
 
   #單身若為多訂單,單頭訂單單號應清空
   LET l_cnt = 0 
   SELECT COUNT(DISTINCT ogb31) INTO l_cnt FROM ogb_file
      WHERE ogb01 = g_oga2.oga01
   IF l_cnt > 1 THEN
      UPDATE oga_file SET oga16 = ''
        WHERE oga01=g_oga2.oga01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('','',"p220_upd_oga():",SQLCA.sqlcode,1)   
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION p220_ins_rvbs()
    DEFINE l_rvbs          RECORD LIKE rvbs_file.*
    DEFINE g_ima918        LIKE ima_file.ima918
    DEFINE g_ima921        LIKE ima_file.ima921
    DEFINE l_rvbs02        LIKE rvbs_file.rvbs02    
 
      
      IF g_oaz.oaz81='Y' THEN                               #出通單要判斷參數
         CASE tm.g
          WHEN "1"  #依客戶+出貨日
            LET g_sql = "SELECT rvbs_file.* FROM rvbs_file,ogb_file ",
                       " WHERE rvbs01 = ogb01 ",
                       "   AND rvbs00 = 'axmt610'",
                       "   AND rvbs01 = '",g_ogb3.ogb01,"' ",
                       "   AND rvbs02 = '",g_ogb3.ogb03,"' ",
                       "   AND ogb03 = '",g_ogb3.ogb03,"' "
          WHEN "2"  #依客戶+單別
            LET g_sql = "SELECT rvbs_file.* FROM rvbs_file,ogb_file ",
                       " WHERE rvbs01 = ogb01 ",
                       "   AND rvbs00 = 'axmt610'",
                       "   AND rvbs01 = '",g_ogb3.ogb01,"' ",
                       "   AND rvbs02 = '",g_ogb3.ogb03,"' ",
                       "   AND ogb03 = '",g_ogb3.ogb03,"' "
            LET g_sql = g_sql, " ORDER BY rvbs01 DESC"
          WHEN "3"  #不匯總
            LET g_sql = "SELECT rvbs_file.* FROM rvbs_file,ogb_file ",
                        " WHERE rvbs01 = '",g_oga2.oga011,"'",
                        "   AND rvbs00= 'axmt610' ",
                        "   AND rvbs01 = ogb01 ",
                        "   AND rvbs02 = '",g_ogb2.ogb03,"' ",
                        "   AND ogb03 = '",g_ogb2.ogb03,"' "
         END CASE
   
         PREPARE p220_prepare2 FROM g_sql
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','',SQLCA.sqlcode,1)   
            LET g_success = 'N'
            RETURN 
         END IF
         DECLARE p220_cs2 CURSOR  FOR p220_prepare2
         LET l_rvbs02 = 0
        FOREACH p220_cs2 INTO l_rvbs.*
            LET l_rvbs02 = l_rvbs02+1
            LET l_rvbs.rvbs00 = 'axmt620'
            LET l_rvbs.rvbs01 = g_ogb2.ogb01
            LET l_rvbs.rvbs02 = g_ogb2.ogb03
            LET l_rvbs.rvbs022 = l_rvbs02    
            IF cl_null(l_rvbs.rvbs03) THEN
                LET l_rvbs.rvbs03 = ' '
            END IF
            IF cl_null(l_rvbs.rvbs04) THEN                                                                                          
                LET l_rvbs.rvbs04 = ' '                                                                                             
            END IF
            IF cl_null(l_rvbs.rvbs08) THEN                                                                                          
                LET l_rvbs.rvbs08 = ' '                                                                                             
            END IF
            IF cl_null(l_rvbs.rvbs022) THEN                                                                                          
                LET l_rvbs.rvbs022 = '0'                                                                                             
            END IF       
            
            LET l_rvbs.rvbsplant = g_plant 
            LET l_rvbs.rvbslegal = g_legal 
 
            INSERT INTO rvbs_file VALUES(l_rvbs.*)                                                                                           
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
               CALL s_errmsg('','',"p220_ins_rvbs():",SQLCA.sqlcode,1)                                                                       
               LET g_success = 'N'
               RETURN                                                                                                                        
            END IF
         END FOREACH
     END IF
 
END FUNCTION
# FUN-9C0073 -----By chenls  10/01/06
