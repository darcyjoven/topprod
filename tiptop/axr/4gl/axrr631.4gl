# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr631.4gl
# Descriptions...: 催收帳款明細表
# Date & Author..: 99/01/06 by Plum
# Modify.........: No.FUN-4C0100 05/01/01 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.MOD-580211 05/09/07 By ice  修改報表列印格式
# Modify.........: No.TQC-5C0086 05/12/20 By Carrier AR月底重評修改
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-6B0076 06/12/05 By Smapmin 收款條件沒有中文說明
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  修改報表格式        
# Modify.........: No.FUN-760076 07/06/28 By yoyo 報表轉cr        
# Modify.........: No.TQC-790126 07/09/25 By destiny 修改打印時沒公司名稱的BUG
# Modify.........: No.MOD-840110 08/04/15 By Smapmin 將occ39a改為occ39
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/21 By chenls  跨DB處理
# Modify.........: No:TQC-A50082 10/05/25 By Carrier MOD-A10196追单
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C40001 12/04/13 By SunLM 增加開窗功能

 
DATABASE ds
 
GLOBALS "../../config/top.global" #CKP
DEFINE   g_i           LIKE type_file.num5        #CKP #No.FUN-680123 SMALLINT
DEFINE   g_cnt         LIKE type_file.num5        #CKP #No.FUN-680123 SMALLINT
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc       LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(1000) #Where condition
              bdate    LIKE type_file.dat,        #No.FUN-680123 DATE # 基準日期
              a        LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
              b        LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
#No:FUN-A10098 ----mark start
#              b_1      LIKE type_file.chr1,            #No.FUN-8A0065 VARCHAR(1)
#              p1       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p2       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p3       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p4       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10) 
#              p5       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p6       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p7       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p8       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#No:FUN-A10098 ----mark end
              type     LIKE type_file.chr1,            #No.FUN-8A0065 VARCHAR(1)
              s        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
              t        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
              u        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)              
              more     LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
              END RECORD
#FUN-760076--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE l_str       STRING
#FUN--760076--end

#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)   #No:FUN-A10098 ----mark
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #CKP
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.a = ARG_VAL(9)
   LET tm.b = ARG_VAL(10)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-8A0065 --start--
#No:FUN-A10098 ----mark start
#   LET tm.b_1   = ARG_VAL(15)
#   LET tm.p1    = ARG_VAL(16)
#   LET tm.p2    = ARG_VAL(17)
#   LET tm.p3    = ARG_VAL(18)
#   LET tm.p4    = ARG_VAL(19)
#   LET tm.p5    = ARG_VAL(20)
#   LET tm.p6    = ARG_VAL(21)
#   LET tm.p7    = ARG_VAL(22)
#   LET tm.p8    = ARG_VAL(23)

#   LET tm.type  = ARG_VAL(24)   
#   LET tm.s     = ARG_VAL(25)
#   LET tm.t     = ARG_VAL(26)
#   LET tm.u     = ARG_VAL(27)
#No:FUN-A10098 ----mark end
#No:FUN-A10098 ----add begin
   LET tm.type  = ARG_VAL(15)
   LET tm.s     = ARG_VAL(16)
   LET tm.t     = ARG_VAL(17)
   LET tm.u     = ARG_VAL(18)
#No:FUN-A10098 ----add end
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF      
   #No.FUN-8A0065 ---end---    
 
#FUN-760076--start
#   #no.5196
#   DROP TABLE curr_tmp
#   CREATE TEMP TABLE curr_tmp
#    (curr LIKE azi_file.azi01,
#     oma03 LIKE oma_file.oma03,
#     oga14 LIKE oga_file.oga14,
#     amt1 LIKE type_file.num20_6,
#     amt2 LIKE type_file.num20_6)
   LET g_sql = "oma03.oma_file.oma03,",
               "oma032.oma_file.oma032,",
               "omb31.omb_file.omb31,",
               "oga02.oga_file.oga02,",
               "oma11.oma_file.oma11,",
               "beenday.type_file.num5,",
               "overday.type_file.num5,", 
               "omb04.omb_file.omb04,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "oma23.oma_file.oma23,",
               "omb14t.omb_file.omb14t,",
               "omb16t.omb_file.omb16t,",
               "occ39.occ_file.occ39,",   #MOD-840110
               "l_oag02.oag_file.oag02,", 
               "azi04.azi_file.azi04,",
               "oga14.oga_file.oga14,",
               "gen02.gen_file.gen02,",
               "oma14.oma_file.oma14,",                                         #FUN-8A0065
               "oma15.oma_file.oma15,",                                         #FUN-8A0065
               "oma02.oma_file.oma02,",                                         #FUN-8A0065               
               "plant.azp_file.azp01,",                                         #FUN-8A0065
               "azi05.azi_file.azi05 "                                          #FUN-8A0065                              
   LET l_table = cl_prt_temptable('axrr631',g_sql) CLIPPED   
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                         
#FUN-760076--end
    
   #no.5196(end)  #No.FUN-680123 end
 
   IF cl_null(tm.wc) THEN
      CALL axrr631_tm(0,0)                # Input print condition
   ELSE
      CALL axrr631()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr631_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(1000)
 
IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 15
 
   OPEN WINDOW axrr631_w AT p_row,p_col
      #CKP
      WITH FORM "axr/42f/axrr631"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate=g_today
   LET tm.a    ='Y'
   LET tm.b    ='Y'
   #FUN-8A0065-Begin--#
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.type  = '3'
#No:FUN-A10098 ----mark start
#   LET tm.b_1 ='N'
#   LET tm.p1=g_plant
#   CALL r631_set_entry_1()               
#   CALL r631_set_no_entry_1()
#   CALL r631_set_comb()           
#No:FUN-A10098 ----mark end
   #FUN-8A0065-End--#   
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON oma14,oma03,oma11,oma15,oma02,omb31,omb04
    #CKP
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    ON ACTION exit
       LET INT_FLAG = 1
       EXIT CONSTRUCT
#FUN-C40001 mark 
##No.FUN-570244  --start-
#      ON ACTION CONTROLP
#            IF INFIELD(omb04) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO omb04
#               NEXT FIELD omb04
#            END IF
##No.FUN-570244 --end--
#FUN-C40001 mark
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)#部門
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma03)#賬款客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
            WHEN INFIELD(oma14)#人員編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            WHEN INFIELD(omb31)#出貨/銷退單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_omb31"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO omb31
                 NEXT FIELD omb31
            WHEN INFIELD(omb04)  #料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO omb04
                 NEXT FIELD omb04
            END CASE
      #No.FUN-C40001  --End   
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr631_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
INPUT BY NAME tm.bdate,tm.a,tm.b,
#No.FUN-A10098 ---MARK
#                 tm.b_1,tm.p1,tm.p2,tm.p3,                                                  #FUN-8A0065
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,                                     #FUN-8A0065 
#No.FUN-A10098 ---MARK END
                 tm.type,                                        #No.FUN-A10098 ---ADD
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8A0065
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8A0065	
	               tm.more
                WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
#No.FUN-A10098 ---mark         
#       #FUN-8A0065--Begin--#
#      AFTER FIELD b_1
#          IF NOT cl_null(tm.b_1)  THEN
#             IF tm.b_1 NOT MATCHES "[YN]" THEN
#                NEXT FIELD b_1       
#             END IF
#          END IF
#       ON CHANGE  b_1
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL r631_set_entry_1()      
#          CALL r631_set_no_entry_1()
#          CALL r631_set_comb()       
#No.FUN-A10098 ---mark end       
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF                   
#No.FUN-A10098 ---mark start
       
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#         #No.FUN-940102--begin    
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1
#            END IF  
#         END IF              
#         #No.FUN-940102--end
# 
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#            #No.FUN-940102--end 
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#            #No.FUN-940102--end 
#         END IF       
#       #FUN-8A0065--End--#         

#No.FUN-A10098 ---mark end
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #CKP
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      #FUN-8A0065--Begin--#      
#No.FUN-A10098 ---mark start
#
#     ON ACTION CONTROLP
#        CASE                                                    
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE                        
#
#No.FUN-A10098 ---mark end
         #FUN-8A0065--End--#
         
      #FUN-8A0065--Begin--#
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3      
      #FUN-8A0065--End--#                  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr631_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr631'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr631','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.a     CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'"  ,   #TQC-610059                         
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
#No.FUN-A10098 ---mark start
#                         " '",tm.b_1 CLIPPED,"'" ,  #FUN-8A0065
#                         " '",tm.p1 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p2 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p3 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p4 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p5 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p6 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p7 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p8 CLIPPED,"'" ,   #FUN-8A0065
#No.FUN-A10098 ---mark end
                         " '",tm.type CLIPPED,"'" , #FUN-8A0065           
                         " '",tm.s CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.t CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.u CLIPPED,"'"      #FUN-8A0065                         
                         
         CALL cl_cmdat('axrr631',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr631_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr631()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr631_w
END FUNCTION
 
FUNCTION axrr631()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE za_file.za05,           #No.FUN-680123 VARCHAR(40)
          sr        RECORD
                oga02     LIKE oga_file.oga02,   #出貨日期
                oga14     LIKE oga_file.oga14,   #業務員
                occ39     LIKE occ_file.occ39,  #客戶付款日二   #MOD-840110
                gem02     LIKE gem_file.gem02,   #部門
                gen02     LIKE gen_file.gen02,   #業務員姓名
                beenday   LIKE type_file.num5,   #已出天數 #No.FUN-680123 SMALLINT
                overday   LIKE type_file.num5,   #超出天數 #No.FUN-680123 SMALLINT   
                oma02     LIKE oma_file.oma02,   #帳款日期
                oma03     LIKE oma_file.oma03,   #客戶
                oma032    LIKE oma_file.oma032,  #簡稱
                oma11     LIKE oma_file.oma11,   #應收款日
                oma14     LIKE oma_file.oma14,   #業務員
                oma15     LIKE oma_file.oma15,   #部門
                oma23     LIKE oma_file.oma23,   #幣別
                oma32     LIKE oma_file.oma32,   #收款條件
                omb04     LIKE omb_file.omb04,   #料號
                omb14t    LIKE omb_file.omb14t,  #應收原幣金額
                omb16t    LIKE omb_file.omb16t,  #應收本幣金額
                omb31     LIKE omb_file.omb31,   #出貨單號
                azi04     LIKE azi_file.azi04,   #金額小位數
                azi05     LIKE azi_file.azi05    #小計,總計小位數
                ,omb44     LIKE omb_file.omb44    #No.FUN-A10098 ---add
                END RECORD
#FUN-760076--start
   DEFINE l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021
   DEFINE       l_oag02   LIKE oag_file.oag02
   DEFINE l_i          LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
#   DEFINE l_dbs        LIKE azp_file.azp03                 #No.FUN-8A0065           #No:FUN-A10098 ----mark
   DEFINE l_azp03      LIKE azp_file.azp03                 #No.FUN-8A0065
   DEFINE l_occ37      LIKE occ_file.occ37                 #No.FUN-8A0065
   DEFINE i            LIKE type_file.num5                 #No.FUN-8A0065      
   DEFINE l_oga02      LIKE oga_file.oga02                 #No.FUN-A10098 ADD
   DEFINE l_oga14      LIKE oga_file.oga14                 #No.FUN-A10098 ADD

      CALL cl_del_data(l_table)                            #No.FUN-8A0065  
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang       #No.TQC-790126
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "        ?,?,?,?,?, ?,?,?,?,?,?,?,?)"                          #FUN-8A0065 Add ?,?,?,?,?
      PREPARE insert_pre FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
         EXIT PROGRAM
      END IF
#FUN-760076--end
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF     
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030

#No.FUN-A10098 ---mark start     
#   #FUN-8A0065--Begin--#
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
#   #FUN-8A0065--End--#   
 
#   FOR l_i = 1 to 8                                                          #FUN-8A0065
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
#       LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065     
#No.FUN-A10098 ---mark  end 
     #no.5196
     DELETE FROM curr_tmp;
     #no.5196
     #No.TQC-5C0086  --Begin                                                                                                        
     #No.TQC-A50082  --Begin
     IF g_ooz.ooz62 = 'N' THEN                                                  
        IF g_ooz.ooz07 = 'N' THEN 
           LET l_sql="SELECT '','','',gem02,gen02,'','',oma02,oma03,",
                     "       oma032,oma11,oma14,oma15,oma23,oma32, ",
                     "       omb04,omb14t,omb16t,omb31,azi04,azi05,omb44 ",
                     " FROM oma_file LEFT OUTER JOIN azi_file ON oma_file.oma23=azi_file.azi01 ",
                     "               LEFT OUTER JOIN gem_file ON oma_file.oma15=gem_file.gem01 ",
                     "               LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 ",
                     "     ,omb_file",
                     " WHERE ",tm.wc CLIPPED,
                     "   AND omavoid = 'N' AND omaconf='Y' ",
                     "   AND oma11 < '",tm.bdate,"'",
                     "   AND oma00 MATCHES '1*' ",
                     "   AND oma56t-oma57 > 0 ",
                     "   AND oma00=omb00 AND oma01=omb01 "
        ELSE
           LET l_sql="SELECT '','','',gem02,gen02,'','',oma02,oma03,",
                     "       oma032,oma11,oma14,oma15,oma23,oma32, ",
                     "       omb04,omb14t,omb16t,omb31,azi04,azi05,omb44 ",
                     " FROM oma_file LEFT OUTER JOIN azi_file ON oma_file.oma23=azi_file.azi01 ",
                     "               LEFT OUTER JOIN gem_file ON oma_file.oma15=gem_file.gem01 ",
                     "               LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 ",
                     "     ,omb_file",
                     " WHERE ",tm.wc CLIPPED,
                     "   AND omavoid = 'N' AND omaconf='Y' ",
                     "   AND oma11 < '",tm.bdate,"'",
                     "   AND oma00 MATCHES '1*' ",
                     "   AND oma61 > 0 ",
                     "   AND oma00=omb00 AND oma01=omb01 "
        END IF
     ELSE                                                                                                                           
        IF g_ooz.ooz07 = 'N' THEN 
           LET l_sql="SELECT '','','',gem02,gen02,'','',oma02,oma03,",
                     "       oma032,oma11,oma14,oma15,oma23,oma32, ",
                     "       omb04,omb14t,omb16t,omb31,azi04,azi05,omb44 ",
                     " FROM oma_file LEFT OUTER JOIN azi_file ON oma_file.oma23=azi_file.azi01 ",
                     "               LEFT OUTER JOIN gem_file ON oma_file.oma15=gem_file.gem01 ",
                     "               LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 ",
                     "     ,omb_file",
                     " WHERE ",tm.wc CLIPPED,                                                                                          
                     "   AND omavoid = 'N' AND omaconf='Y' ",                                                                          
                     "   AND oma11 < '",tm.bdate,"'",                                                                                  
                     "   AND oma00 MATCHES '1*' ",                                                                                     
                     "   AND omb16t-omb35 > 0 ",
                     "   AND oma00=omb00 AND oma01=omb01 "                                                                            
        ELSE
           LET l_sql="SELECT '','','',gem02,gen02,'','',oma02,oma03,",
                     "       oma032,oma11,oma14,oma15,oma23,oma32, ",
                     "       omb04,omb14t,omb16t,omb31,azi04,azi05,omb44 ",
                     " FROM oma_file LEFT OUTER JOIN azi_file ON oma_file.oma23=azi_file.azi01 ",
                     "               LEFT OUTER JOIN gem_file ON oma_file.oma15=gem_file.gem01 ",
                     "               LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 ",
                     "     ,omb_file",
                     " WHERE ",tm.wc CLIPPED,                                                                                          
                     "   AND omavoid = 'N' AND omaconf='Y' ",                                                                          
                     "   AND oma11 < '",tm.bdate,"'",                                                                                  
                     "   AND oma00 MATCHES '1*' ",                                                                                     
                     "   AND omb37 > 0 ",                                  #No.A057                                                    
                     "   AND oma00=omb00 AND oma01=omb01 "                                                                            
        END IF                                                                                                                         
     END IF                                                                                                                         
     #No.TQC-A50082  --End  
     #No.TQC-5C0086  --End
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE axrr631_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr631_curs1 CURSOR FOR axrr631_prepare1
 
#FUN-760076--start
#     CALL cl_outnam('axrr631') RETURNING l_name
#     START REPORT axrr631_rep TO l_name
 
#     LET g_pageno = 0
#     CALL cl_del_data(l_table)                                   #FUN-8A0065 Mark
#FUN-760076--end
 
     FOREACH axrr631_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
       LET l_sql = "SELECT oga02,oga14 ",
                   "  FROM ", cl_get_target_table(sr.omb44, 'oga_file' ),
                   " WHERE oga01 = '",sr.omb31,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,sr.omb44) RETURNING  l_sql           #No.FUN-A10098 -----add
       PREPARE oga_prepare1 FROM l_sql
       DECLARE oga_c1  CURSOR FOR oga_prepare1
       OPEN oga_c1
       FETCH oga_c1 INTO l_oga02,l_oga14
       LET sr.oga02 = l_oga02
       LET sr.oga14 = l_oga14
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end

#      SELECT occ39 INTO sr.occ39 FROM occ_file WHERE occ01=sr.oma03   #MOD-840110     #FUN-8A0065 Mark
       #FUN-8A0065--Begin--#
       SELECT azi05 INTO sr.azi05 FROM azi_file                                        #FUN-8B0118
        WHERE azi01 = sr.oma23                                                         #FUN-8B0118 
#NO.FUN-A10098 ---begin
#       LET l_sql = "SELECT occ37,occ39 ",                                                                              
#                   "  FROM ",l_dbs CLIPPED,"occ_file",                                                                          
       LET l_sql = "SELECT occ37,occ39 FROM occ_file",
#NO.FUN-A10098 ---end
                   " WHERE occ01= '",sr.oma03,"'"                                                                                                                                                                              
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE occ_prepare3 FROM l_sql                                                                                          
       DECLARE occ_c3  CURSOR FOR occ_prepare3                                                                                 
       OPEN occ_c3                                                                                    
       FETCH occ_c3 INTO l_occ37,sr.occ39                      
      IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
      IF tm.type = '1' THEN
         IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
      END IF
      IF tm.type = '2' THEN 
         IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
      END IF
      #FUN-8A0065--End--#
       IF sr.occ39 IS NULL THEN LET sr.occ39=' ' END IF   #MOD-840110
       LET sr.beenday=tm.bdate-sr.oga02   #已出天數: 基準日期-出貨日期
       LET sr.overday=sr.oma11-tm.bdate   #超出天數: 預計收款日-基準日期
 
       IF cl_null(sr.beenday) THEN LET sr.beenday=0 END IF
       IF cl_null(sr.overday) THEN LET sr.overday=0 END IF
       IF tm.b='N' THEN LET sr.omb04=' ' END IF #No.6441
       #no.5196
       #INSERT INTO curr_tmp VALUES(sr.oma23,sr.oma03,sr.oga14,sr.omb14t,sr.omb16t)
       #no.5196(end)
#FUN-760076--start
#       OUTPUT TO REPORT axrr631_rep(sr.*)
       #FUN-8A0065--Begin--#
#       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#        WHERE ima01 = sr.omb04
#NO.FUN-A10098 ---begin
#       LET l_sql = "SELECT ima02,ima021 ",                                                                              
#                   "  FROM ",l_dbs CLIPPED,"ima_file",                                                                          
        LET l_sql = "SELECT ima02,ima021 FROM ima_file",
#NO.FUN-A10098 ---end
                   " WHERE ima01 = '",sr.omb04,"'"                                                                                                                                                                               
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE ima_prepare3 FROM l_sql                                                                                          
       DECLARE ima_c3  CURSOR FOR ima_prepare3                                                                                 
       OPEN ima_c3                                                                                    
       FETCH ima_c3 INTO l_ima02,l_ima021
       #FUN-8A0065--END--#            
                        
        #-----FUN-6B0076---------
        LET l_oag02 = ''
       #FUN-8A0065--Begin--# 
#      SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = sr.oma32
#NO.FUN-A10098 ---begin
#       LET l_sql = "SELECT oag02 ",                                                                              
#                   "  FROM ",l_dbs CLIPPED,"oag_file",                                                                          
        LET l_sql = "SELECT oag02 FROM oag_file",
#NO.FUN-A10098 ---end
                   " WHERE oag01 = '",sr.oma32,"'"                                                                                                                                                                               
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE oag_prepare3 FROM l_sql                                                                                          
       DECLARE oag_c3  CURSOR FOR oag_prepare3                                                                                 
       OPEN oag_c3                                                                                    
       FETCH oag_c3 INTO l_oag02
       #FUN-8A0065--END--#        
                
        EXECUTE insert_pre USING sr.oma03,sr.oma032,sr.omb31,sr.oga02,sr.oma11,
                                 sr.beenday,sr.overday,sr.omb04,l_ima02,l_ima021,
                                 sr.oma23,sr.omb14t,sr.omb16t,sr.occ39,l_oag02,   #MOD-840110
                                 sr.azi04,sr.oga14,sr.gen02,
#                                 sr.oma14,sr.oma15,sr.oma02,m_dbs[l_i],sr.azi05               #FUN-8A0065 Add  #NO.FUN-A10098 ---mark
                                 sr.oma14,sr.oma15,sr.oma02,'',sr.azi05   #NO.FUN-A10098 ---add                              
#FUN-760076--end
     END FOREACH
#   END FOR                  #FUN-8A0065    #No.FUN-A10098 -MARK 
          
#FUN-760076--start
    # FINISH REPORT axrr631_rep
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)    
    LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET l_str = tm.bdate CLIPPED,";",tm.a CLIPPED,";",tm.b CLIPPED,";",
                g_azi04 CLIPPED,";",g_azi05 CLIPPED,";",t_azi05,";",
                tm.type,";",tm.s[1,1],";",tm.s[2,2],";",                        #FUN-8A0065
#                tm.s[3,3],";",tm.t,";",tm.u,";",tm.b_1                          #FUN-8A0065    #No.FUN-A10098 ---mark
                tm.s[3,3],";",tm.t,";",tm.u                                      #No.FUN-A10098 ---add 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axrr631'
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'oma14,oma03,oma11,oma15,oma02,omb31,omb04')
           RETURNING tm.wc
       LET l_str = l_str ,";",tm.wc
    END IF
    CALL cl_prt_cs3('axrr631','axrr631',g_sql,l_str)                        
#FUN-760076--end
END FUNCTION


###GP5.2  #NO.FUN-A10098  mark begin 

#FUN-8A0065--Begin--#
#FUNCTION r631_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r631_set_no_entry_1()
#    IF tm.b_1 = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '8' THEN
#          LET tm2.s1 = ' '
#       END IF
#       IF tm2.s2 = '8' THEN
#          LET tm2.s2 = ' '
#       END IF
#       IF tm2.s3 = '8' THEN
#          LET tm2.s3 = ' '
#       END IF                 
#    END IF
#END FUNCTION
#FUNCTION r631_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b_1 ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-981' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7,8'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-980' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
##FUN-8A0065--End--#

###GP5.2  #NO.FUN-A10098  mark end 
 
#FUN-760076--start
#REPORT axrr631_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1)
#          g_head1      STRING,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          sr        RECORD
#                oga02     LIKE oga_file.oga02,   #出貨日期
#                oga14     LIKE oga_file.oga14,   #業務員
#                occ39a    LIKE occ_file.occ39a,  #客戶付款日二
#                gem02     LIKE gem_file.gem02,   #部門
#                gen02     LIKE gen_file.gen02,   #業務員姓名
#                beenday   LIKE type_file.num5,   #已出天數 #No.FUN-680123
#                overday   LIKE type_file.num5,   #超出天數 #No.FUN-680123   
#                oma02     LIKE oma_file.oma02,   #帳款日期
#                oma03     LIKE oma_file.oma03,   #客戶
#                oma032    LIKE oma_file.oma032,  #簡稱
#                oma11     LIKE oma_file.oma11,   #應收款日
#                oma14     LIKE oma_file.oma14,   #業務員
#                oma15     LIKE oma_file.oma15,   #部門
#                oma23     LIKE oma_file.oma23,   #幣別
#                oma32     LIKE oma_file.oma32,   #收款條件
#                omb04     LIKE omb_file.omb04,   #料號
#                omb14t    LIKE omb_file.omb14t,  #應收原幣金額
#                omb16t    LIKE omb_file.omb16t,  #應收本幣金額
#                omb31     LIKE omb_file.omb31,   #出貨單號
#                azi04     LIKE azi_file.azi04,   #金額小位數
#                azi05     LIKE azi_file.azi05    #小計,總計小位數
#                END RECORD,
#                 l_amt1         LIKE omb_file.omb14t,
#                 l_amt2         LIKE omb_file.omb16t,
#                 l_curr         LIKE azi_file.azi01,          #No.FUN-680123 VARCHAR(04)
#                 l_flag         LIKE type_file.chr1          #No.FUN-680123 VARCHAR(01)
##       l_time                 LIKE type_file.chr8             #No.FUN-6A0095
#  DEFINE       l_oag02   LIKE oag_file.oag02   #FUN-6B0076
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.oga14,sr.oma03,sr.omb31
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051
#      LET g_head1 = g_x[11] CLIPPED,tm.bdate
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[12] CLIPPED,sr.oga14 CLIPPED,' ',sr.gen02
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#      PRINT g_dash1
#      LET l_last_sw='n'
#      LET l_flag='Y'
#
#   BEFORE GROUP OF sr.oga14
#      IF l_flag='N' THEN PRINT END IF
#      LET l_flag='Y'
#      IF tm.a='Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.oma03
#      IF l_flag='N' THEN PRINT END IF
#      PRINT COLUMN g_c[31],sr.oma03,
#            COLUMN g_c[32],sr.oma032;
#      LET l_flag='N'
#
#   ON EVERY ROW
#    IF tm.b='Y' THEN
#    SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#        WHERE ima01 = sr.omb04
#    #-----FUN-6B0076---------
#    LET l_oag02 = ''
#    SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = sr.oma32
#    #-----END FUN-6B0076-----
#      PRINT COLUMN g_c[33],sr.omb31,
#            COLUMN g_c[34],sr.oga02 USING 'YYYYMMDD',
#            COLUMN g_c[35],sr.oma11 USING 'YYYYMMDD',
#            COLUMN g_c[36],sr.beenday USING '-------&',  #No.MOD-580211
#            COLUMN g_c[37],sr.overday USING '-------&',  #No.MOD-580211
#            COLUMN g_c[38],sr.omb04,
#            COLUMN g_c[39],l_ima02,
#            COLUMN g_c[40],l_ima021,
#            COLUMN g_c[41],sr.oma23,
#            COLUMN g_c[42],cl_numfor(sr.omb14t,42,sr.azi04),
#            COLUMN g_c[43],cl_numfor(sr.omb16t,43,g_azi04),
#            COLUMN g_c[44],sr.occ39a USING '---&',  #No.TQC-6A0087
#            #COLUMN g_c[45],sr.oma32   #FUN-6B0076
#            COLUMN g_c[45],l_oag02   #FUN-6B0076
#    END IF
#       #no.5196
#       INSERT INTO curr_tmp VALUES(sr.oma23,sr.oma03,sr.oga14,sr.omb14t,sr.omb16t)
#       #no.5196(end)
# 
#   #No.6441
#   AFTER GROUP OF sr.omb31
#    #-----FUN-6B0076---------
#    LET l_oag02 = ''
#    SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = sr.oma32
#    #-----END FUN-6B0076-----
#    IF tm.b='N' THEN
#      PRINT COLUMN g_c[33],sr.omb31,
#            COLUMN g_c[34],sr.oga02 USING 'YYYYMMDD',
#            COLUMN g_c[35],sr.oma11 USING 'YYYYMMDD',
#            COLUMN g_c[36],sr.beenday USING '------&',
#            COLUMN g_c[37],sr.overday USING '------&',
#           #COLUMN g_c[38],sr.omb04,
#            COLUMN g_c[41],sr.oma23,
#            COLUMN g_c[42],cl_numfor(GROUP SUM(sr.omb14t),42,sr.azi04),
#            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.omb16t),43,g_azi04),
#            COLUMN g_c[44],sr.occ39a USING '--&',
#            #COLUMN g_c[45],sr.oma32   #FUN-6B0076
#            COLUMN g_c[45],l_oag02   #FUN-6B0076
#    END IF
# 
#   AFTER GROUP OF sr.oma03
#        #no.5196
#         DECLARE curr_temp1 CURSOR FOR
#          SELECT curr,SUM(amt1),SUM(amt2) FROM curr_tmp
#           WHERE oma03=sr.oma03
#             AND oga14=sr.oga14
#           GROUP BY curr
#         PRINT
#         FOREACH curr_temp1 INTO l_curr,l_amt1,l_amt2
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         PRINT COLUMN g_c[40],g_x[14] CLIPPED,
#               COLUMN g_c[41],l_curr CLIPPED,
#               COLUMN g_c[42],cl_numfor(l_amt1,42,t_azi05),
#               COLUMN g_c[43],cl_numfor(l_amt2,43,g_azi05)
#         #No.MOD-580211 -start--
#         #PRINT COLUMN g_c[42],'------------------ ------------------'
#         PRINT   COLUMN g_c[42],g_dash2[1,g_w[42]],
#                 COLUMN g_c[43],g_dash2[1,g_w[43]]
#          #No.MOD-580211 -end--
#         END FOREACH
#         #no.5196(end)
#   AFTER GROUP OF sr.oga14
#        #no.5196
#         DECLARE curr_temp2 CURSOR FOR
#          SELECT curr,SUM(amt1),SUM(amt2) FROM curr_tmp
#           WHERE oga14=sr.oga14
#           GROUP BY curr
#         PRINT
#         FOREACH curr_temp2 INTO l_curr,l_amt1,l_amt2
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         PRINT COLUMN g_c[40],g_x[15] CLIPPED,
#               COLUMN g_c[41],l_curr CLIPPED,
#               COLUMN g_c[42],cl_numfor(l_amt1,42,t_azi05),
#               COLUMN g_c[43],cl_numfor(l_amt2,43,g_azi05)
#         END FOREACH
#         #no.5196(end)
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_amt1= SUM(sr.omb16t)
#      PRINT COLUMN g_c[40],g_x[16] CLIPPED,
#            COLUMN g_c[43], cl_numfor(l_amt1,43,g_azi05)
#      PRINT g_dash[1,g_len]
##     PRINT g_x[13],COLUMN g_c[45],g_x[9] CLIPPED    #No.TQC-6B0051
#      PRINT g_x[13],COLUMN g_len-9,g_x[9] CLIPPED    #No.TQC-6B0051
#      LET l_last_sw='y'
#
#   PAGE TRAILER
#      IF l_last_sw='n' THEN
#         PRINT g_dash[1,g_len]
##        PRINT g_x[13],COLUMN g_c[45],g_x[8] CLIPPED #No.TQC-6B0051
#         PRINT g_x
