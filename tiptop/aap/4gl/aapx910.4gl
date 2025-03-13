# Prog. Version..: '5.30.07-13.05.30(00004)'     #
#
# Pattern name...: aapx910.4gl
# Descriptions...: 應付對帳單
# Date & Author..: 06/06/14 by Rainy
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行時間
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/24 By douzh l_time轉g_time
# Modify.........: No.FUN-690080 06/10/25 By ice 查詢帳款,增加13,17,25類型的判斷與關聯
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0128 06/12/07 By Rayven 程序代號位置錯，無“接下頁”和“結束”
# Modify.........: No.TQC-740326 07/04/28 By dxfwo  排序第三欄位未有默認值
# Modify.........: No.TQC-770052 07/07/12 By Rayven 制表日期的位置在報表名之上
# Modify.........: No.FUN-830099 08/03/27 By Cockroach 報表轉成CR  
# Modify.........: No.MOD-850083 08/05/14 By Sarah 將apa00欄寬從chr4放大成chr20
# Modify.........: No.FUN-870128 08/08/29 By jamie 程式已轉CR不應call cl_outnam
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-8B0026 08/12/02 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa 跨数据库统一改为s_dbstring.
# Modify.........: No.FUN-A10098 10/01/20 By wuxj 去掉plant，跨DB改為不跨DB，去掉報表營運中心
# Modify.........: No:CHI-AB0010 10/11/12 By Summer SQL多串apc_file依多帳期資料分開列示
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_apa14應給予預設值'',抓不到值不應為'1'
# Modify.........: No:TQC-B70203 11/07/28 By Sarah 未付金額計算應包含apc14
# Modify.........: No:MOD-B70256 11/07/29 By Polly 1.將FUNCTION axmr330_getdesc改為x910_getdesc
#                                                  2.修正x910_getdes內的訊息，應抓取APA00的帳款性質資料:
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C90053 12/09/10 By Polly 調整報表格式，印出發票號碼
# Modify.........: No.FUN-D40020 13/03/15 By zhangweib CR轉XtraGrid報表
# Modify.........: No.FUN-D30070 13/03/21 By yangtt 去除畫面檔上小計欄位，并去除4gl中grup_sum_field
# Modify.........: No.FUN-D40128 13/05/14 By wangrr 增加欄位開窗,報表增加"規格"欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                        # Print condition RECORD
              wc      LIKE type_file.chr1000,           # Where condition  #No.FUN-690028 VARCHAR(300)
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        		# Order by sequence
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        		# Eject sw
             #u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),        		# Group total sw  #FUN-D30070 mark
              deadline LIKE type_file.dat,         # No.FUN-690028 DATE,              	# 截止日期
           #NO.FUN-A10098 --start---
           #  b       LIKE type_file.chr1,            #No.FUN-8B0026 VARCHAR(1)
           #  p1      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p2      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p3      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p4      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10) 
           #  p5      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p6      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p7      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #  p8      LIKE azp_file.azp01,            #No.FUN-8B0026 VARCHAR(10)
           #NO.FUN-A10098 ---end---
              type    LIKE type_file.chr1,            #No.FUN-8B0026 VARCHAR(1)              
              more     LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)              # Input more condition(Y/N)
              END RECORD,
              headtag  LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),             # 判斷XML的HEAD是否列印過
              xml_name LIKE type_file.chr20             # For XML File Name  #No.FUN-690028 VARCHAR(20)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   i               LIKE type_file.num5    #No.FUN-690028 SMALLINT
#     DEFINEl_time   LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-830099 --add start--
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   l_table1        STRING
#No.FUN-830099 --end--
DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0026 ARRAY[10] OF VARCHAR(20)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184   #No.FUN-6A0055 #FUN-BB0047 mark

#No.FUN-830099 --ADD START--
   LET g_sql =  " order1.apa_file.apa01,",
		" order2.apa_file.apa01,",
                " order3.apa_file.apa01,",
	     	" apa06.apa_file.apa06,",
                " apa07.apa_file.apa07,",
                " pmc091.pmc_file.pmc091,",
                " pmc092.pmc_file.pmc092,",
                " pmc093.pmc_file.pmc093,",
                " pmc094.pmc_file.pmc094,",
                " pmc095.pmc_file.pmc095,",
                " pmc10.pmc_file.pmc10,",
	        " apa02.apa_file.apa02,",
                " apa00.type_file.chr20,",   #MOD-850083 mod chr4->chr20
                " apa01.apa_file.apa01,",
	        " apa12.apa_file.apa12,",
		" apa22.apa_file.apa22,",
	        " apa21.apa_file.apa21,",
                " gem02.gem_file.gem02,",
                " gen02.gen_file.gen02,",
                " apa13.apa_file.apa13,",
                " apa14.apa_file.apa14,",
                " apa34f.apa_file.apa34f,",
                " balance.apa_file.apa31f,",
		" apa34.apa_file.apa34f,",
                " balance2.apa_file.apa31f,",
                " oox10.oox_file.oox10,",
 	        " apa08.apa_file.apa08,",
                " azi03.azi_file.azi03,",
                " azi04.azi_file.azi04,",
                " azi05.azi_file.azi05,",
                " azi07.azi_file.azi07,",
                " plant.azp_file.azp01,",                                          #FUN-8B0026
               #No.FUN-D40020 ---start--- add
                " apb01.apb_file.apb01,",
                " apb02.apb_file.apb02,",
                " apb21.apb_file.apb21,",
                " apb12.apb_file.apb12,",
                " apb28.apb_file.apb28,",
                " apb09.apb_file.apb09,",
                " apb23.apb_file.apb23,",
                " apb24.apb_file.apb24,",
                " apb27.apb_file.apb27,",
                " keyfd.type_file.chr100,",
               #No.FUN-D40020 ---start--- add
                "ima021.ima_file.ima021,",     #FUN-D40128 
                "l_n1.type_file.num5"  #FUN-D40128
#                " t1_azi05.azi_file.azi05,",
#                " t2_azi05.azi_file.azi05,",
#                " t3_azi05.azi_file.azi05,",
                    
   LET l_table = cl_prt_temptable('aapx910',g_sql) CLIPPED
   IF l_table = -1 THEN
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
 
#FUN-D40129---mark--str--
#  LET g_sql =  " apb01.apb_file.apb01,",
#               " apb02.apb_file.apb02,",
#               " apb21.apb_file.apb21,",
#               " apb12.apb_file.apb12,",
#               " apb28.apb_file.apb28,",
#               " apb09.apb_file.apb09,",
#               " apb23.apb_file.apb23,",
#               " apb24.apb_file.apb24,",
#               " apb27.apb_file.apb27 "
#  LET l_table1 = cl_prt_temptable('aapx9101',g_sql) CLIPPED
#  IF l_table1=-1 THEN
#     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055 #FUN-BB0047 mark
#     EXIT PROGRAM
#  END IF 
#FUN-D40129---mark--end--
#No.FUN-830099 --ADD END--
 
 
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.s ='12 '                           
   LET tm.s ='123'                    # TQC-740326             
   LET tm.t ='Y  '
  #LET tm.u ='Y  '  #FUN-D30070 mark
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.deadline = g_today
   LET tm.wc = ARG_VAL(1)
   LET g_rep_user = ARG_VAL(2)
   LET g_rep_clas = ARG_VAL(3)
   LET g_template = ARG_VAL(4)
   LET g_rpt_name = ARG_VAL(5)  #No.FUN-7C0078
  #NO.FUN-A10098  ---start---
  ##No.FUN-8B0026 --start--
  #LET tm.b     = ARG_VAL(6)
  #LET tm.p1    = ARG_VAL(7)
  #LET tm.p2    = ARG_VAL(8)
  #LET tm.p3    = ARG_VAL(9)
  #LET tm.p4    = ARG_VAL(10)
  #LET tm.p5    = ARG_VAL(11)
  #LET tm.p6    = ARG_VAL(12)
  #LET tm.p7    = ARG_VAL(13)
  #LET tm.p8    = ARG_VAL(14)
  #LET tm.type  = ARG_VAL(15)            
  ##No.FUN-8B0026 ---end---  
   LET tm.type  = ARG_VAL(6)
  #NO.FUN-A10098 ---end---     
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1]  #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2]  #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3]  #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF  #FUN-D30070 mark
   DROP TABLE curr_tmp
# No.FUN-690028 --start-- 
  CREATE TEMP TABLE curr_tmp(
     curr  LIKE apa_file.apa13,
     amt1  LIKE type_file.num20_6,
     amt2  LIKE type_file.num20_6,
     amt3  LIKE azj_file.azj03,
     apa06 LIKE apa_file.apa06,
     order1 LIKE apa_file.apa01,
     order2 LIKE apa_file.apa01,
     order3 LIKE apa_file.apa01);
    
    
# No.FUN-690028 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(tm.wc)
      THEN CALL aapx910_tm(0,0)             # Input print condition
      ELSE LET tm.wc="apaa01= '",tm.wc CLIPPED,"'"
           CALL aapx910()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapx910_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000   #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5      #No.FUN-940102
 
   LET p_row = 3 LET p_col =16
 
   OPEN WINDOW aapx910_w AT p_row,p_col WITH FORM "aap/42f/aapx910"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   
   #FUN-8B0026-Begin--#
   LET tm.type  = '3'
#  LET tm.b ='N'              #NO.FUN-A10098 
#  LET tm.p1=g_plant          #NO.FUN-A10098
#  CALL x910_set_entry_1()    #NO.FUN-A10098           
#  CALL x910_set_no_entry_1() #NO.FUN-A10098
#  CALL x910_set_comb()       #NO.FUN-A10098    
   #FUN-8B0026-End--#   
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apa06,apa13,apa01,apa00,apa22,apa21
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
     #FUN-D40128--add--str--
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(apa06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa12"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa06
              NEXT FIELD apa06
           WHEN INFIELD(apa13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa13_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa13
              NEXT FIELD apa13
          WHEN INFIELD(apa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa07"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa01
              NEXT FIELD apa01
          WHEN INFIELD(apa00)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa00"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa00
              NEXT FIELD apa00
          WHEN INFIELD(apa22)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa22_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa22
              NEXT FIELD apa22
          WHEN INFIELD(apa21)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_apa21_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO apa21
              NEXT FIELD apa21
        END CASE
     #FUN-D40128--add--end 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapx910_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3,tm.deadline,   #FUN-D30070 mark
                 tm.deadline,    #FUN-D30070 add
                #NO.FUN-A10098  ---start---
                #tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8B0026
                #tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,                                     #FUN-8B0026                 
                 tm.type,
                #NO.FUN-10098  ----end---
                 tm.more WITHOUT DEFAULTS
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD deadline
         IF cl_null(tm.deadline) THEN
            NEXT FIELD deadline
         END IF
         
     #NO.FUN-A10098  ----start----
     # #FUN-8B0026--Begin--#
     #AFTER FIELD b
     #    IF NOT cl_null(tm.b)  THEN
     #       IF tm.b NOT MATCHES "[YN]" THEN
     #          NEXT FIELD b       
     #       END IF
     #    END IF
     
     # ON CHANGE  b
     #    LET tm.p1=g_plant
     #    LET tm.p2=NULL
     #    LET tm.p3=NULL
     #    LET tm.p4=NULL
     #    LET tm.p5=NULL
     #    LET tm.p6=NULL
     #    LET tm.p7=NULL
     #    LET tm.p8=NULL
     #    DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
     #    CALL x910_set_entry_1()      
     #    CALL x910_set_no_entry_1()
     #    CALL x910_set_comb()    
     #NO.FUN-A10098 ---end----   
       
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF                   

   #NO.FUN-A10098  ----start---         
   #  AFTER FIELD p1
   #     IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
   #     SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
   #     IF STATUS THEN 
   #        CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
   #        NEXT FIELD p1 
   #     END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p1
   #             END IF 
   # #No.FUN-940102 --end--
 
   #  AFTER FIELD p2
   #     IF NOT cl_null(tm.p2) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p2 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p2
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p3
   #     IF NOT cl_null(tm.p3) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p3 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p3
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p4
   #     IF NOT cl_null(tm.p4) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
   #           NEXT FIELD p4 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p4
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p5
   #     IF NOT cl_null(tm.p5) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
   #           NEXT FIELD p5 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p5
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p6
   #     IF NOT cl_null(tm.p6) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
   #           NEXT FIELD p6 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p6
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p7
   #     IF NOT cl_null(tm.p7) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
   #           NEXT FIELD p7 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p7
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF
 
   #  AFTER FIELD p8
   #     IF NOT cl_null(tm.p8) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p8 
   #        END IF
   # #No.FUN-940102 --begin--
   #           CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
   #             IF not li_result THEN 
   #                NEXT FIELD p8
   #             END IF 
   # #No.FUN-940102 --end--
   #     END IF       
   #   #FUN-8B0026--End--#         
   #NO.FUN-A10098  ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
    
    #NO.FUN-A10098  ---start---     
    # #FUN-8B0026--Begin--#      
    # ON ACTION CONTROLP
    #    CASE                                                             
    #       WHEN INFIELD(p1)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p1
    #          CALL cl_create_qry() RETURNING tm.p1
    #          DISPLAY BY NAME tm.p1
    #          NEXT FIELD p1
    #       WHEN INFIELD(p2)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p2
    #          CALL cl_create_qry() RETURNING tm.p2
    #          DISPLAY BY NAME tm.p2
    #          NEXT FIELD p2
    #       WHEN INFIELD(p3)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p3
    #          CALL cl_create_qry() RETURNING tm.p3
    #          DISPLAY BY NAME tm.p3
    #          NEXT FIELD p3
    #       WHEN INFIELD(p4)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p4
    #          CALL cl_create_qry() RETURNING tm.p4
    #          DISPLAY BY NAME tm.p4
    #          NEXT FIELD p4
    #       WHEN INFIELD(p5)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p5
    #          CALL cl_create_qry() RETURNING tm.p5
    #          DISPLAY BY NAME tm.p5
    #          NEXT FIELD p5
    #       WHEN INFIELD(p6)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p6
    #          CALL cl_create_qry() RETURNING tm.p6
    #          DISPLAY BY NAME tm.p6
    #          NEXT FIELD p6
    #       WHEN INFIELD(p7)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p7
    #          CALL cl_create_qry() RETURNING tm.p7
    #          DISPLAY BY NAME tm.p7
    #          NEXT FIELD p7
    #       WHEN INFIELD(p8)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = 'q_azp'  #No.FUN-940102
    #          LET g_qryparam.form = 'q_zxy'  #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user   #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p8
    #          CALL cl_create_qry() RETURNING tm.p8
    #          DISPLAY BY NAME tm.p8
    #          NEXT FIELD p8
    #    END CASE                        
    #    #FUN-8B0026--End--#         
    #NO.FUN-A10098 ----end---

      ON ACTION controlg
         CALL cl_cmdask()    # Command execution
 
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070 mark
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help        
         CALL cl_show_help()  
 
      ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapx910_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapx910'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err3("sel","zz_file","aapx910","",SQLCA.sqlcode,""," sel zz",1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.deadline CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",
                       #NO.FUN-A10098  ----start---
                       # " '",tm.b CLIPPED,"'" ,    #FUN-8B0026
                       # " '",tm.p1 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p2 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p3 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p4 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p5 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p6 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p7 CLIPPED,"'" ,   #FUN-8B0026
                       # " '",tm.p8 CLIPPED,"'" ,   #FUN-8B0026
                       #NO.FUN-A10098  ----end----
                         " '",tm.type CLIPPED,"'"   #FUN-8B0026                         
                                    
         CALL cl_cmdat('aapx910',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aapx910_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aapx910()
   ERROR ""
END WHILE
   CLOSE WINDOW aapx910_w
END FUNCTION
 
FUNCTION aapx910()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_str     LIKE type_file.chr1000,     # No.FUN-690028 VARCHAR(100),       # Temp String
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #FUN-580184 mark  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
	  l_apa06	LIKE apa_file.apa06,
          l_order    ARRAY[5] OF LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
          sr        RECORD
		    order1	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
		    order2	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
		    order3	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
		    apa06     LIKE apa_file.apa06,	#1
                    apa07     LIKE apa_file.apa07,	#2
                    pmc091    LIKE pmc_file.pmc091,	#5
                    pmc092    LIKE pmc_file.pmc092,	#5
                    pmc093    LIKE pmc_file.pmc093,	#5
                    pmc094    LIKE pmc_file.pmc094,	#5
                    pmc095    LIKE pmc_file.pmc095,	#5
                    pmc10     LIKE pmc_file.pmc10,	#5
		    apa02     LIKE apa_file.apa02,	#7
                    apa00     LIKE type_file.chr20,     #8 #No.FUN-690080   #MOD-850083 mod chr8->chr20
                    apa01     LIKE apa_file.apa01,	#9
		    apa12     LIKE apa_file.apa12,	#10
		    apa22     LIKE apa_file.apa22,	#10
		    apa21     LIKE apa_file.apa21,	#10
                    gem02     LIKE gem_file.gem02,	#11
                    gen02     LIKE gen_file.gen02,	#12
                    apa13     LIKE apa_file.apa13,	#13
                    apa14     LIKE apa_file.apa14,	#14
                    apa34f    LIKE apa_file.apa34f,	#15
                    balance   LIKE apa_file.apa31f,	#16
	     	    apa34    LIKE apa_file.apa34,	#17
		    balance2  LIKE apa_file.apa31f,	#18
		    oox10     LIKE oox_file.oox10,	#19
 		    apa08     LIKE apa_file.apa08,	
		    azi03     LIKE azi_file.azi03,
		    azi04     LIKE azi_file.azi04,
		    azi05     LIKE azi_file.azi05,
		    azi07     LIKE azi_file.azi07
                    END RECORD,
          sr2       RECORD
                    apb01     LIKE apb_file.apb01,
                    apb02     LIKE apb_file.apb02,
                    apb21     LIKE apb_file.apb21,
                    apb12     LIKE apb_file.apb12,
                    apb28     LIKE apb_file.apb28,
                    apb09     LIKE apb_file.apb09,
                    apb23     LIKE apb_file.apb23,
                    apb24    LIKE apb_file.apb24,
                    apb27     LIKE apb_file.apb27
                    END RECORD
   DEFINE        l_apb02        LIKE apb_file.apb02,     #No.FUN-830099 DEFINE  
                 l1_apb02       LIKE apb_file.apb02      #No.FUN-830099 DEFINE
   DEFINE l_oox01   STRING                           #CHI-830003 add
   DEFINE l_oox02   STRING                           #CHI-830003 add
   DEFINE l_sql_1   STRING                           #CHI-830003 add
   DEFINE l_sql_2   STRING                           #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
   DEFINE l_apa14   LIKE apa_file.apa14              #CHI-830003 add
   DEFINE l_i       LIKE type_file.num5              #No.FUN-8B0026 SMALLINT
   DEFINE l_dbs     LIKE azp_file.azp03              #No.FUN-8B0026
   DEFINE l_pmc903  LIKE pmc_file.pmc903             #No.FUN-8B0026
   DEFINE i         LIKE type_file.num5              #No.FUN-8B0026                    
   DEFINE l_ima021  LIKE ima_file.ima021   #FUN-D40128                 
   DEFINE l_n1      LIKE type_file.num5    #FUN-D40128                 
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184 mark  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
     #End:FUN-980030
#No.FUN-830099 --add start--
     CALL cl_del_data(l_table)
#    CALL cl_del_data(l_table1)   #FUN-D40129
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",    #No.FUN-D40020   Add
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,? )  "  #FUN-8B0026 Add ? #FUN-D40128 add 2?
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
        EXIT PROGRAM                                                                                                                 
     END IF
   #FUN-D40129---mark--str--
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
   #           " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?   )  "    
   # PREPARE insert_prep1 FROM g_sql                                                                                                  
   # IF STATUS THEN                                                                                                                   
   #    CALL cl_err('insert_prep1:',status,1)                                                                                        
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
   #    EXIT PROGRAM                                                                                                                 
   # END IF
   #FUN-D40129---mark--str--
#No.FUN-830099 --add end--
 
     #no.5196
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ",  #bug no:A057
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "  GROUP BY curr  "
     PREPARE r320_prepare_1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp1 CURSOR FOR r320_prepare_1
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ", #bug no:A057
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "  GROUP BY curr  "
     PREPARE r320_prepare_2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp2 CURSOR FOR r320_prepare_2
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ", #bug no:A057
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               "  GROUP BY curr  "
     PREPARE r320_prepare_3 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp3 CURSOR FOR r320_prepare_3
 
     #no.5196(end)
  
  #NO.FUN-A10098  ---start---   
  #  #FUN-8B0026--Begin--#
  #  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
  #  LET m_dbs[1]=tm.P1
  #  LET m_dbs[2]=tm.p2
  #  LET m_dbs[3]=tm.p3
  #  LET m_dbs[4]=tm.p4
  #  LET m_dbs[5]=tm.p5
  #  LET m_dbs[6]=tm.p6
  #  LET m_dbs[7]=tm.p7
  #  LET m_dbs[8]=tm.p8
  #  #FUN-8B0026--End--#
  #NO.FUN-A10098 ----end---
  
  #NO.FUN-A10098  ---start---    
  #  FOR l_i = 1 to 8                                                          #FUN-8B0026
  #      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0026
  #      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0026
  #      #LET l_dbs = FGL_GETENV("MSSQLAREA") CLIPPED,'_',l_dbs CLIPPED,'.dbo.'                                         #FUN-8B0026     
  #      LET l_dbs = s_dbstring(l_dbs CLIPPED)               #TQC-9B0011 mod
  #NO.FUN-A10098 ----end---
#CHI-AB0010 mark --start--
#     LET l_sql="SELECT '','','',apa06,apa07,",
#                        "pmc091,pmc092,pmc093,pmc094,pmc095,pmc10,",                                                       
#                        " apa02,apa00,apa01,",                                                                            
#                        "apa12,apa22,apa21,",
#                        "gem02,gen02,apa13,apa72,",                                                            
#                        "apa34f,apa34f-apa35f,",                                                                                  
#                        "apa34,apa73,0,apa08,",
#                        "azi03,azi04,azi05,azi07,pmc903",                       #FUN-8B0026 Add pmc903                                                              
##              " FROM apa_file,OUTER gem_file,OUTER gen_file,OUTER azi_file,",  #FUN-8B0026 Mark                                                  
##              "      OUTER pmc_file ",                                         #FUN-8B0026 Mark               
#             #NO.FUN-A10098 ---start---
#             # " FROM ",l_dbs CLIPPED,"apa_file, ",                             #FUN-8B0026 
#             # " OUTER ",l_dbs CLIPPED,"gem_file, ",                            #FUN-8B0026
#             # " OUTER ",l_dbs CLIPPED,"gen_file, ",                            #FUN-8B0026
#             # " OUTER ",l_dbs CLIPPED,"azi_file, ",                            #FUN-8B0026
#             # " OUTER ",l_dbs CLIPPED,"pmc_file ",                             #FUN-8B0026                                                                                                                                                                                                                     
#               " FROM apa_file,OUTER gem_file,OUTER gen_file,OUTER azi_file,",
#               "      OUTER pmc_file ",
#             #NO.FUN-A10098 ---end---
#               " WHERE apa_file.apa22=gem_file.gem01 AND apa_file.apa21=gen_file.gen01 ",                                                          
#               "   AND apa41 = 'Y' AND apa42 = 'N'",                                                         
#                         "   AND apa34f>apa35f AND pmc_file.pmc01=apa_file.apa06",                                                         
#               "   AND apa_file.apa13=azi_file.azi01 AND apa02 <='",tm.deadline,"' AND ",                                                   
#                             tm.wc CLIPPED," ORDER BY apa06,apa02"                                                               
#CHI-AB0010 mark --end--
    #CHI-AB0010 mod --start--
     LET l_sql="SELECT '','','',apa06,apa07,",
                        "pmc091,pmc092,pmc093,pmc094,pmc095,pmc10,",                                                       
                        " apa02,apa00,apa01,",                   #MOD-C90053 apc12 mod apk03                                                                           
                        "apc04,apa22,apa21,",
                        "gem02,gen02,apa13,apc07,",                                                            
                        "apc08,apc08-apc10-apc14,",  #TQC-B70203 add apc14
                        "apc09,apc13,0,apk03,",
                        "azi03,azi04,azi05,azi07,pmc903",                                                                  
               " FROM apa_file,apc_file,apk_file,OUTER gem_file,OUTER gen_file,OUTER azi_file,",  #MOD-C90053 add apk_file
               "      OUTER pmc_file ",
               " WHERE apa_file.apa22=gem_file.gem01 AND apa_file.apa21=gen_file.gen01 ",                                                          
               "   AND apa01 = apc01 ",
               "   AND apa01 = apk01 ",                                                              #MOD-C90053 add
               "   AND apa41 = 'Y' AND apa42 = 'N'",                                                         
               "   AND apc08>apc10+apc14 AND pmc_file.pmc01=apa_file.apa06",  #TQC-B70203 add apc14
               "   AND apa_file.apa13=azi_file.azi01 AND apa02 <='",tm.deadline,"' AND ",                                                   
               tm.wc CLIPPED," ORDER BY apa06,apa02"                                                               
    #CHI-AB0010 mod --end--
     LET l_sql= l_sql CLIPPED
     PREPARE aapx910_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
        EXIT PROGRAM
     END IF
     DECLARE aapx910_curs1 CURSOR FOR aapx910_prepare1
    #CALL cl_outnam('aapx910') RETURNING l_name  #FUN-870128 mark
     CALL cl_prt_pos_len()
 
#     LET xml_name=l_name CLIPPED,'.xml'       #No.FUN-830099 MARK    
#     START REPORT aapx910_rep1 TO l_name      #No.FUN-830099 MARK
 
     LET g_pageno = 0
     LET headtag = '0'
     FOREACH aapx910_curs1 INTO sr.*,l_pmc903        #FUN-8B0026 Add l_pmc903
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

      #No.FUN-D40020 ---start--- Add
       SELECT azi05 INTO sr.azi05 FROM azi_file
          WHERE azi01 = sr.apa13
      #No.FUN-D40020 ---end  --- Add
       
      #FUN-8B0026--Begin--#
      IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
      IF tm.type = '1' THEN
         IF l_pmc903  = 'N' THEN  CONTINUE FOREACH END IF
      END IF
      IF tm.type = '2' THEN   #非關係人
         IF l_pmc903  = 'Y' THEN  CONTINUE FOREACH END IF
      END IF
      #FUN-8B0026--End--#       
       
      #CHI-830003--Add--Begin--#    
      IF g_apz.apz27 = 'Y' THEN
         LET l_oox01 = YEAR(tm.deadline)
         LET l_oox02 = MONTH(tm.deadline)                      	 
         LET l_apa14 = ''  #TQC-B10083 add
         WHILE cl_null(l_apa14)
             #NO.FUN-A10098  ---start---
             # LET l_sql_2 = "SELECT COUNT(*) FROM ",l_dbs CLIPPED," oox_file",                 #FUN-8B0026 Add ",l_dbs CLIPPED,"
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
             #NO.FUN-A10098  ---end--- 
                             " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.apa01,"'",
                             "   AND oox04 = '0'"
               PREPARE x910_prepare7 FROM l_sql_2
               DECLARE x910_oox7 CURSOR FOR x910_prepare7
               OPEN x910_oox7
               FETCH x910_oox7 INTO l_count
               CLOSE x910_oox7                       
               IF l_count = 0 THEN
                  #LET l_apa14 = '1'   #TQC-B10083 mark 
                  EXIT WHILE           #TQC-B10083 add
               ELSE      
                 #NO.FUN-A10098  ---start---            
                 #LET l_sql_1 = "SELECT oox07 FROM ",l_dbs CLIPPED," oox_file",                 #FUN-8B0026 Add ",l_dbs CLIPPED,"             
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",
                 #NO.FUN-A10098  ---end---
                                " WHERE oox00 = 'AP' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.apa01,"'",
                                "   AND oox04 = '0'"
               END IF                  
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE x910_prepare07 FROM l_sql_1
               DECLARE x910_oox07 CURSOR FOR x910_prepare07
               OPEN x910_oox07
               FETCH x910_oox07 INTO l_apa14
               CLOSE x910_oox07
            END IF              
         END WHILE                       
      END IF
      #CHI-830003--Add--End--# 
      
      #CHI-830003--Begin--#
      #IF g_apz.apz27 = 'Y' AND l_count <> 0 THEN         #TQC-B10083 mark
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN  #TQC-B10083 mod
         LET sr.apa34 = sr.apa34f * l_apa14
         LET sr.balance2 = sr.balance * l_apa14
      END IF    
      #CHI-830003--End--#       
       
       IF sr.apa00 MATCHES '2*' THEN
	   		LET sr.apa34f  =-sr.apa34f
	   		LET sr.balance =-sr.balance
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa06
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa13
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa01
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa00
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa22
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.apa21
              #NO.FUN-A10098  ----mark---
              #WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = m_dbs[l_i]                    #FUN-8B0026               
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
      #CALL axmr330_getdesc(sr.apa00) RETURNING sr.apa00      #No.MOD-B70256 mark
       CALL x910_getdesc(sr.apa00) RETURNING sr.apa00         #No.MOD-B70256 add
        
      #FUN-8B0026--Begin--#
#      SELECT SUM(oox10) INTO sr.oox10 FROM oox_file
#       WHERE oox00='AP' AND oox03=sr.apa01            
 
      LET l_sql = "SELECT SUM(oox10) ",       
                 #NO.FUN-A10098  ---start---                                                                       
                 #"  FROM ",l_dbs CLIPPED,"oox_file",
                  "  FROM oox_file",
                 #NO.FUN-A10098  ---end---
                  " WHERE oox00='AP' ", 
                  "   AND oox03='",sr.apa01,"'"                                                                                                                                                                                  
          PREPARE oox_prepare2 FROM l_sql                                                                                          
          DECLARE oox_c2  CURSOR FOR oox_prepare2                                                                                 
          OPEN oox_c2                                                                                    
          FETCH oox_c2 INTO sr.oox10        
      #FUN-8B0026--End--#        
        
       IF cl_null(sr.oox10) THEN LET sr.oox10=0 END IF
 
#       INSERT INTO curr_tmp VALUES(sr.apa13,sr.apa34f,sr.balance,sr.oox10,sr.apa06,sr.order1,sr.order2,sr.order3)
       
       IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
#       OUTPUT TO REPORT aapx910_rep1(sr.*)           #No.FUN-830099 --MARK--
       LET l_apb02 = 0     #Default   
          LET l1_apb02 = 0    #Default   
	  LET l_sql = "SELECT apb01,apb02,apb21,apb12,apb28,apb09,apb23,apb24,apb27 ",
#               "  FROM apb_file ",                                                        #FUN-8B0026 Mark
               #NO.FUN-A10098  ---start---
               #"  FROM ",l_dbs CLIPPED,"apb_file",                                        #FUN-8B0026	              
                "  FROM apb_file",
               #NO.FUN-A10098  ---end---
		      " WHERE apb01 = '",sr.apa01,"' "
          PREPARE r330_prepare2 FROM l_sql
          IF SQLCA.sqlcode THEN
              CALL cl_err('r330_prepare2:',SQLCA.sqlcode,1) RETURN
          END IF
          DECLARE aapx910_cur2 CURSOR FOR r330_prepare2
          FOREACH aapx910_cur2 INTO sr2.*
             LET l1_apb02 = l_apb02
             LET l_apb02 = sr2.apb02
             IF sr2.apb02 = g_aza.aza34 THEN
                LET sr2.apb02 = l1_apb02 + 1
                LET l_apb02 = sr2.apb02
             END IF
         #No.FUN-D40020 ---start--- Mark
         #EXECUTE  insert_prep1  USING 
         # sr2.apb01, sr2.apb02, sr2.apb21, sr2.apb12, sr2.apb28, 
         # sr2.apb09, sr2.apb23, sr2.apb24, sr2.apb27   
         #No.FUN-D40020 ---end  --- Mark
         #No.FUN-D40020 ---start--- Add
          LET l_str = Null
          IF tm.t[1] = 'Y' THEN
             CASE tm.s[1]
                WHEN '1' LET l_str = sr.apa06
               #WHEN '2' LET l_str = sr.apa13  #FUN-D30070 幣別已有固定群組
                WHEN '3' LET l_str = sr.apa01
                WHEN '4' LET l_str = sr.apa00
                WHEN '5' LET l_str = sr.apa22
                WHEN '6' LET l_str = sr.apa21
             END CASE
          END IF
          IF tm.t[2] = 'Y' THEN
             CASE tm.s[2]
                WHEN '1' LET l_str = l_str,sr.apa06
               #WHEN '2' LET l_str = l_str,sr.apa13  #FUN-D30070 幣別已有固定群組
                WHEN '3' LET l_str = l_str,sr.apa01
                WHEN '4' LET l_str = l_str,sr.apa00
                WHEN '5' LET l_str = l_str,sr.apa22
                WHEN '6' LET l_str = l_str,sr.apa21
             END CASE
          END IF
          IF tm.t[3] = 'Y' THEN
             CASE tm.s[3]
                WHEN '1' LET l_str = l_str,sr.apa06
              # WHEN '2' LET l_str = l_str,sr.apa13  #FUN-D30070 幣別已有固定群組
                WHEN '3' LET l_str = l_str,sr.apa01
                WHEN '4' LET l_str = l_str,sr.apa00
                WHEN '5' LET l_str = l_str,sr.apa22
                WHEN '6' LET l_str = l_str,sr.apa21
             END CASE
          END IF
          LET l_str = l_str,sr.apa13
          LET l_ima021=''  #FUN-D40128
          SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr2.apb21  #FUN-D40128
          LET l_n1 = 3   #FUN-D40128
          EXECUTE  insert_prep  USING
             sr.order1,   sr.order2, sr.order3, sr.apa06,  sr.apa07,   sr.pmc091,
             sr.pmc092,   sr.pmc093, sr.pmc094, sr.pmc095, sr.pmc10,   sr.apa02,
             sr.apa00,    sr.apa01,  sr.apa12,  sr.apa22,  sr.apa21,   sr.gem02,
             sr.gen02,    sr.apa13,  sr.apa14,  sr.apa34f, sr.balance, sr.apa34,
             sr.balance2, sr.oox10,  sr.apa08,  sr.azi03,  sr.azi04,   sr.azi05,
             sr.azi07,g_plant,
             sr2.apb01, sr2.apb02, sr2.apb21, sr2.apb12, sr2.apb28,
             sr2.apb09, sr2.apb23, sr2.apb24, sr2.apb27,l_str
            ,l_ima021,  l_n1  #FUN-D40128
          END FOREACH
         #No.FUN-D40020 ---end  --- Add
       END FOREACH
 
#        FOREACH curr_temp1 USING sr.order1
#                            INTO l_curr,l_amt1,l_amt2,l_amt3
#            SELECT azi05 into t1_azi05  #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
#        END FOREACH
#        
#        FOREACH curr_temp2 USING sr.order1,sr.order2
#                            INTO l_curr,l_amt1,l_amt2
#            SELECT azi05 into t2_azi05   #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
#       END FOREACH
#       FOREACH curr_temp3 USING sr.order1,sr.order2,sr.order3
#                            INTO l_curr,l_amt1,l_amt2
#            SELECT azi05 into t3_azi05  #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
#        END FOREACH
 
   #No.FUN-D40020 ---start--- Mark
   ##FUN-8B0026--Begin--#
   #SELECT azi05 INTO sr.azi05 FROM azi_file
   # WHERE azi01 = sr.apa13
   ##FUN-8B0026--End--#
 
   #EXECUTE  insert_prep  USING  
   #  sr.order1,   sr.order2, sr.order3, sr.apa06,  sr.apa07,   sr.pmc091,
   #  sr.pmc092,   sr.pmc093, sr.pmc094, sr.pmc095, sr.pmc10,   sr.apa02,
   #  sr.apa00,    sr.apa01,  sr.apa12,  sr.apa22,  sr.apa21,   sr.gem02,
   #  sr.gen02,    sr.apa13,  sr.apa14,  sr.apa34f, sr.balance, sr.apa34,
   #  sr.balance2, sr.oox10,  sr.apa08,  sr.azi03,  sr.azi04,   sr.azi05,
#  #  sr.azi07,m_dbs[l_i]                                  #NO.FUN-A10098 mark                        #FUN-8B0026 Add m_dbs[l_i]
   #  sr.azi07,g_plant                                     #NO.FUN-A10098                                              
#  #   t1_azi05,  t2_azi05,  t3_azi05,
#  #   sr2.apb02, sr2.apb21, sr2.apb12, sr2.apb28, 
#  #   sr2.apb09, sr2.apb23, sr2.apb24, sr2.apb27
 
   # END FOREACH
   ##END FOR                    #NO.FUN-A10098  mark                                                       #FUN-8B0026
   #No.FUN-D40020 ---start--- Mark
 
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                            
###XtraGrid###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
 
   LET g_str = ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'apa06,apa13,apa01,apa00,apa22,apa21')                                                                                           
           RETURNING tm.wc                                                                                                         
      LET g_str = tm.wc                                                                                                            
   END IF
#NO.FUN-A10098  ---start---
#  IF tm.b = 'Y' THEN                                                   #FUN-8B0026
#     LET l_name = 'aapx910_1'                                          #FUN-8B0026
#  ELSE                                                                 #FUN-8B0026
#  	  LET l_name = 'aapx910'                                            #FUN-8B0026
#  END IF	                                                              #FUN-8B0026   
   LET l_name = 'aapx910'
#NO.FUN-A10098 ----end---
###XtraGrid###   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
###XtraGrid###                    ,";",g_azi07,";",tm.deadline,";",g_memo_pagetrailer,";",g_memo       
###XtraGrid###   CALL cl_prt_cs3('aapx910',l_name,l_sql,g_str)                        #FUN-8B0026 Add l_name    
    LET g_xgrid.table = l_table    ###XtraGrid###
    CALL cl_get_order_field(tm.s,"apa06,apa13,apa01,apa00,apa22,apa21") RETURNING g_xgrid.order_field
  #LET g_xgrid.grup_field = cl_get_sum_field(tm.s,tm.u,"apa07,apa13,apa01,apa00,apa22,apa21")  #FUN-D30070 mar
   LET g_xgrid.grup_field = cl_get_order_field(tm.s,"apa07,apa13,apa01,apa00,apa22,apa21")  #FUN-D30070 add
   IF cl_null(g_xgrid.grup_field) THEN
      LET g_xgrid.grup_field = "apa13"
   ELSE
      LET g_xgrid.grup_field = g_xgrid.grup_field,",apa13"
   END IF
 # LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"apa06,apa13,apa01,apa00,apa22,apa21")  #FUN-D30070 mark
    LET g_xgrid.skippage_field = "keyfd"
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-830099 --ADD END--
 
#No.FUN-830099 --MARK START--    
#        FINISH REPORT aapx910_rep1
#        CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#       CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0055
#No.FUN-830099 --MARK END--  
END FUNCTION
 
#NO.FUN-A10098 ----start---
##FUN-8B0026--Begin--#
#FUNCTION x910_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION x910_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '7' THEN                                                                                                         
#          LET tm2.s1 = '1'                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s2 = '7' THEN                                                                                                         
#          LET tm2.s2 = '2'                                                                                                          
#       END IF                                                                                                                       
#       IF tm2.s3 = '7' THEN                                                                                                         
#          LET tm2.s3 = '3'                                                                                                          
#       END IF
#    END IF
#    DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3    
#END FUNCTION
#FUNCTION x910_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='aap-966' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='aap-967' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8B0026--End--#
#NO.FUN-A10098  ---end---
 
#FUNCTION axmr330_getdesc(l_apa00)     #No.MOD-B70256 mark
FUNCTION x910_getdesc(l_apa00)         #No.MOD-B70256 add
    DEFINE l_apa00      LIKE apa_file.apa00,
           l_desc       LIKE type_file.chr20       # No.FUN-690028 VARCHAR(4) #No.FUN-690080   #MOD-850083 chr8->chr20

#-----------------------------No.MOD-B70256--------------------------------start 
#CASE l_apa00
#       WHEN '11' LET l_desc=cl_getmsg('axr-231',g_lang)
#       WHEN '12' LET l_desc=cl_getmsg('axr-232',g_lang)
#       WHEN '13' LET l_desc=cl_getmsg('axr-233',g_lang)
#       WHEN '14' LET l_desc=cl_getmsg('axr-234',g_lang)
#       WHEN '21' LET l_desc=cl_getmsg('axr-257',g_lang)
#       WHEN '22' LET l_desc=cl_getmsg('axr-253',g_lang)
#       WHEN '23' LET l_desc=cl_getmsg('axr-237',g_lang)
#       WHEN '24' LET l_desc=cl_getmsg('axr-238',g_lang)
#       WHEN '13' LET l_desc=cl_getmsg('axr-235',g_lang)   #No.FUN-690080
#       WHEN '17' LET l_desc=cl_getmsg('axr-236',g_lang)   #No.FUN-690080
#       WHEN '25' LET l_desc=cl_getmsg('axr-239',g_lang)   #No.FUN-690080
#END CASE
CASE l_apa00
        WHEN '11' LET l_desc=cl_getmsg('agl-415',g_lang)
        WHEN '12' LET l_desc=cl_getmsg('agl-416',g_lang)
        WHEN '13' LET l_desc=cl_getmsg('axr-235',g_lang)
        WHEN '15' LET l_desc=cl_getmsg('agl-417',g_lang)
        WHEN '16' LET l_desc=cl_getmsg('aap-361',g_lang)
        WHEN '17' LET l_desc=cl_getmsg('axr-236',g_lang)
        WHEN '21' LET l_desc=cl_getmsg('axr-257',g_lang)
        WHEN '22' LET l_desc=cl_getmsg('aap-362',g_lang)
        WHEN '23' LET l_desc=cl_getmsg('aap-363',g_lang)
        WHEN '24' LET l_desc=cl_getmsg('aap-364',g_lang)
        WHEN '25' LET l_desc=cl_getmsg('aap-365',g_lang)
        WHEN '26' LET l_desc=cl_getmsg('aap-366',g_lang)
END CASE
#-----------------------------No.MOD-B70256-----------------------------------end
RETURN l_desc
END FUNCTION
 
#No.FUN-830099 --MARK --START--
#REPORT aapx910_rep1(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#         l_curr       LIKE azi_file.azi01,      # No.FUN-690028 VARCHAR(4),
#         sr        RECORD
#       	order1	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
#       	order2	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
#               order3	  LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(20),
#            	    apa06     LIKE apa_file.apa06,
#                   apa07     LIKE apa_file.apa07,
#                   pmc091    LIKE pmc_file.pmc091,	
#                   pmc092    LIKE pmc_file.pmc092,	
#                   pmc093    LIKE pmc_file.pmc093,	
#                   pmc094    LIKE pmc_file.pmc094,	
#                   pmc095    LIKE pmc_file.pmc095,	
#                   pmc10     LIKE pmc_file.pmc10,
#                   apa02     LIKE apa_file.apa02,
#                   apa00     LIKE type_file.chr4,      # No.FUN-690028 VARCHAR(4) #No.FUN-690080 VARCHAR(4)會有截位
#                   apa01     LIKE apa_file.apa01,
#                   apa12     LIKE apa_file.apa12,
#       	    apa22     LIKE apa_file.apa22,
#                   apa21     LIKE apa_file.apa21,
#                   gem02     LIKE gem_file.gem02,
#                   gen02     LIKE gen_file.gen02,
#                   apa13     LIKE apa_file.apa13,
#                   apa14     LIKE apa_file.apa14,
#                   apa34f    LIKE apa_file.apa34f,
#                   balance   LIKE apa_file.apa31f,
#       	    apa34    LIKE apa_file.apa34f,
#       	    balance2  LIKE apa_file.apa31f,
#                   oox10     LIKE oox_file.oox10,    #bug no:A057
#		    apa08     LIKE apa_file.apa08,	#MOD-540183
#       	    azi03     LIKE azi_file.azi03,
#       	    azi04     LIKE azi_file.azi04,
#       	    azi05     LIKE azi_file.azi05,
#       	    azi07     LIKE azi_file.azi07
#                   END RECORD,
#         sr2       RECORD
#                   apb02     LIKE apb_file.apb02,
#                   apb21     LIKE apb_file.apb21,
#                   apb12     LIKE apb_file.apb12,
#                   apb28     LIKE apb_file.apb28,
#                   apb09     LIKE apb_file.apb09,
#                   apb23     LIKE apb_file.apb23,
#                   apb24    LIKE apb_file.apb24,
#                   apb27     LIKE apb_file.apb27
#                   END RECORD,
#        l_flag     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#       	 l_apa34f	LIKE apa_file.apa34f,
#       	 l_balance 	LIKE apa_file.apa34f,
#       	 l_amt1		LIKE apa_file.apa31f,
#       	 l_amt2		LIKE apa_file.apa32f,
#       	 l_amt3		LIKE apa_file.apa73,   #bug no:A057
#       	 l_buf	 LIKE zaa_file.zaa08,  #No.FUN-690028 VARCHAR(10)
#       	 l_time	 LIKE type_file.chr8,    #No.FUN-690028 VARCHAR(8)
#                l_str          LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)               # Temp String
#  DEFINE        l_sql          LIKE type_file.chr1000,               #No.FUN-690028 VARCHAR(400)
#                l_apb02        LIKE apb_file.apb02,   
#                l1_apb02       LIKE apb_file.apb02     
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#         LET l_flag = 'N'
 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     LET g_pageno = g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
##     PRINT g_head CLIPPED,pageno_total  #No.TQC-770052 mark
#     PRINT                              #No.TQC-770052
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT g_x[30] CLIPPED;
#     FOR i=1 TO 3
#      CASE tm.s[i,i]
#              WHEN '1' PRINT g_x[24] CLIPPED,' ';
#              WHEN '2' PRINT g_x[25] CLIPPED,' ';
#              WHEN '3' PRINT g_x[26] CLIPPED,' ';
#              WHEN '4' PRINT g_x[27] CLIPPED,' ';
#              WHEN '5' PRINT g_x[28] CLIPPED,' ';
#              WHEN '6' PRINT g_x[29] CLIPPED,' ';
#              OTHERWISE PRINT '';
#      END CASE
#     END FOR
#     PRINT
#     LET l_time = TIME
#     PRINT COLUMN 01,g_x[11] CLIPPED,'(',sr.apa06 CLIPPED,')',
#       		   sr.apa07 CLIPPED
#     LET sr.pmc091 = sr.pmc091 CLIPPED,sr.pmc092 CLIPPED,sr.pmc093 CLIPPED,sr.pmc094 CLIPPED,sr.pmc095 CLIPPED
#     PRINT COLUMN 01,g_x[12] CLIPPED,sr.pmc091 CLIPPED
#     PRINT g_x[13] CLIPPED,tm.deadline
#     PRINT g_head CLIPPED,pageno_total  #No.TQC-770052
#     PRINT g_dash[1,g_len]
#     PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],
#           g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59] 
#     PRINT g_dash1
#     LET l_last_sw = 'n'       #FUN-550111
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#        PRINT COLUMN g_c[41],sr.apa02,
#              COLUMN g_c[42],sr.apa00 CLIPPED,   #No.FUN-690080
#              COLUMN g_c[43],sr.apa01,
#              COLUMN g_c[44],sr.apa12,
#              COLUMN g_c[45],sr.gem02 CLIPPED,
#              COLUMN g_c[46],sr.gen02 CLIPPED,
#              COLUMN g_c[47],sr.apa13,
#              COLUMN g_c[48],cl_numfor(sr.apa34f,18,sr.azi04),
#              COLUMN g_c[49],cl_numfor(sr.oox10,10,sr.azi07),    
#              COLUMN g_c[50],cl_numfor(sr.balance,18,sr.azi04),
#              COLUMN g_c[51],sr.apa08;
#              
 
#         LET l_apb02 = 0     #Default項次初值
#         LET l1_apb02 = 0    #Default項次初值
#         LET l_sql = "SELECT apb02,apb21,apb12,apb28,apb09,apb23,apb24,apb27 ",
#                     "  FROM apb_file ",
#       	      " WHERE apb01 = '",sr.apa01,"' "
#         PREPARE r330_prepare2 FROM l_sql
#         IF SQLCA.sqlcode THEN
#             CALL cl_err('r330_prepare2:',SQLCA.sqlcode,1) RETURN
#         END IF
#         DECLARE aapx910_cur2 CURSOR FOR r330_prepare2
#         FOREACH aapx910_cur2 INTO sr2.*
#            #No.FUN-5B0139 --start--
#            #發票待扺資料分配項次
#            LET l1_apb02 = l_apb02
#            LET l_apb02 = sr2.apb02
#            IF sr2.apb02 = g_aza.aza34 THEN
#               LET sr2.apb02 = l1_apb02 + 1
#               LET l_apb02 = sr2.apb02
#            END IF
#            #No.FUN-5B0139 --end--
#     			PRINT COLUMN g_c[52],sr2.apb02 USING '###&', #No.FUN-570177
#                             COLUMN g_c[53],sr2.apb21,
#                  #No.FUN-550071 --start--
#                             COLUMN g_c[54],sr2.apb12 CLIPPED,
#                             COLUMN g_c[55],sr2.apb27,
#                             COLUMN g_c[56],sr2.apb28 CLIPPED,
#                             COLUMN g_c[57],cl_numfor(sr2.apb09,57,3),
#                             COLUMN g_c[58],cl_numfor(sr2.apb23,58,sr.azi03),
#                             COLUMN g_c[59],cl_numfor(sr2.apb24,59,sr.azi04)
#           	END FOREACH
#       	PRINT ''	
#       	
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#       	 CASE tm.s[1,1]
#       		WHEN '1' LET l_buf= g_x[24] CLIPPED
#       		WHEN '2' LET l_buf= g_x[25] CLIPPED
#       		WHEN '3' LET l_buf= g_x[26] CLIPPED
#       		WHEN '4' LET l_buf= g_x[27] CLIPPED
#       		WHEN '5' LET l_buf= g_x[28] CLIPPED
#       		WHEN '6' LET l_buf= g_x[29] CLIPPED
#       	 END CASE
 
#       PRINT COLUMN g_c[46],g_dash2[1,g_w[46]+1+g_w[47]+1+g_w[48]+1+g_w[49]+1+g_w[50]]
#        FOREACH curr_temp1 USING sr.order1
#                            INTO l_curr,l_amt1,l_amt2,l_amt3
#            SELECT azi05 into t_azi05  #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
 
#           PRINT COLUMN g_c[46],l_curr CLIPPED,g_x[23] CLIPPED,
#                 COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);  #No.CHI-6A0004
#           PRINT COLUMN g_c[50], cl_numfor(l_amt2,18,t_azi05)   #No.CHI-6A0004
#        END FOREACH
#        PRINT ''
#     END IF
#     #no.5196(end)
 
#  AFTER GROUP OF sr.order2
#     IF tm.u[2,2] = 'Y' THEN
#       	 CASE tm.s[2,2]
#       		WHEN '1' LET l_buf= g_x[24] CLIPPED
#       		WHEN '2' LET l_buf= g_x[25] CLIPPED
#       		WHEN '3' LET l_buf= g_x[26] CLIPPED
#       		WHEN '4' LET l_buf= g_x[27] CLIPPED
#       		WHEN '5' LET l_buf= g_x[28] CLIPPED
#       		WHEN '6' LET l_buf= g_x[29] CLIPPED
#       	 END CASE
#      #no.5196
#        FOREACH curr_temp2 USING sr.order1,sr.order2
#                            INTO l_curr,l_amt1,l_amt2
#            SELECT azi05 into t_azi05   #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
 
#          PRINT COLUMN g_c[46], l_curr CLIPPED,g_x[23] CLIPPED,
#                COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);  #No.CHI-6A0004
#          PRINT COLUMN g_c[49], cl_numfor(l_amt3,49,g_azi07),
#                   COLUMN g_c[50],cl_numfor(l_amt2,50,t_azi05)  #No.CHI-6A0004
 
#        END FOREACH
#        PRINT ''
#     END IF
#     #no.5196(end)
 
#  AFTER GROUP OF sr.order3
#     IF tm.u[3,3] = 'Y' THEN
#       	 CASE tm.s[3,3]
#       		WHEN '1' LET l_buf= g_x[24] CLIPPED
#       		WHEN '2' LET l_buf= g_x[25] CLIPPED
#       		WHEN '3' LET l_buf= g_x[26] CLIPPED
#       		WHEN '4' LET l_buf= g_x[27] CLIPPED
#       		WHEN '5' LET l_buf= g_x[28] CLIPPED
#       		WHEN '6' LET l_buf= g_x[29] CLIPPED
#       	 END CASE
#      #no.5196
#        FOREACH curr_temp3 USING sr.order1,sr.order2,sr.order3
#                            INTO l_curr,l_amt1,l_amt2
#            SELECT azi05 into t_azi05  #No.CHI-6A0004
#              FROM azi_file
#              WHERE azi01=l_curr
 
#           PRINT COLUMN g_c[46], l_curr CLIPPED,g_x[23] CLIPPED,
#                 COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);  #No.CHI-6A0004
#           PRINT COLUMN g_c[49], cl_numfor(l_amt3,49,g_azi07),
#                   COLUMN g_c[50],cl_numfor(l_amt2,50,t_azi05)  #No.CHI-6A0004
 
#        END FOREACH
#        PRINT ''
#     END IF
#     #no.5196(end)
#
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
##               PRINT '(aapx910)'  #No.TQC-6B0128 mark
#        PRINT g_dash[1,g_len]
#      #  PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
#     #No.TQC-6B0128 --start--
#     PRINT g_x[5] CLIPPED;
#     IF l_last_sw = 'y' THEN
#        PRINT COLUMN (g_len-9), g_x[7] CLIPPED
#     ELSE
#        PRINT COLUMN (g_len-9), g_x[6] CLIPPED
#     END IF
#     #No.TQC-6B0128 --end--
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
### END FUN-550111
#
#END REPORT
#No.FUN-830099 --MARK END--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
