# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr630.4gl
# Descriptions...: 收款天數明細表(axrr630)
# Date & Author..: 99/01/08 by Billy
# Modify.........: No.FUN-4C0100 04/12/31 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0102 06/11/21 By johnray 報表修改
# Modify.........: No.TQC-6B0190 06/12/04 By Smapmin 增加報表列印條件
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  修改報表格式   
# Modify.........: No.TQC-790085 07/09/13 By lumxa  表名和制表日期位置顛倒。
# Modify.........: No.MOD-840109 08/04/15 By Smapmin 修改變數定義型態
# Modify.........: NO.FUN-840051 08/04/17 By zhaijie 報表輸出改為CR
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B20033 11/02/17 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.MOD-B30072 11/03/09 By yinhy “出貨日”欄位錯誤（會顯示有1899年的資料）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc       LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000) # Where condition
              bdate    LIKE type_file.dat,       #No.FUN-680123 DATE # 基準日期
              edate    LIKE type_file.dat,       #No.FUN-680123 DATE # 基準日期
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#              b        LIKE type_file.chr1,            #No.FUN-8A0065 VARCHAR(1)
#              p1       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p2       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p3       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p4       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10) 
#              p5       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p6       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p7       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#              p8       LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
              s        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
              t        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
              u        LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)              
              more     LIKE type_file.chr1       # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i           LIKE type_file.num5       #count/index for any purpose #No.FUN-680123 SMALLINT
#NO.FUN-840051----START-----
   DEFINE g_sql           STRING
   DEFINE g_str           STRING
   DEFINE l_table         STRING
#NO.FUN-840051----END-----
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#NO.FUN-840051----START-----
   LET g_sql = "oma01.oma_file.oma01,",
               "oma02.oma_file.oma02,",
               "oma03.oma_file.oma03,",
               "oma032.oma_file.oma032,",
               "oma11.oma_file.oma11,",
               "oma23.oma_file.oma23,",
               "oma32.oma_file.oma32,",
               "omb03.omb_file.omb03,",
               "omb31.omb_file.omb31,",
               "omb04.omb_file.omb04,",
               "omb14t.omb_file.omb14t,",
               "omb16t.omb_file.omb16t,",
               "omb32.omb_file.omb32,",
               "omb34.omb_file.omb34,",
               "omb35.omb_file.omb35,",
               "oga02.oga_file.oga02,",
               "day.type_file.num10,",
               "term.oag_file.oag02,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05,",
               "oma14.oma_file.oma14,",                                         #FUN-8A0065
               "oma15.oma_file.oma15,",                                         #FUN-8A0065
               "plant.azp_file.azp01"                                           #FUN-8A0065               
   LET l_table = cl_prt_temptable('axrr630',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"                                                 #FUN-8A0065 Add ?,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                        
#NO.FUN-840051----END-----
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   #No.FUN-8A0065 --start--
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   LET tm.b     = ARG_VAL(13)
#   LET tm.p1    = ARG_VAL(14)
#   LET tm.p2    = ARG_VAL(15)
#   LET tm.p3    = ARG_VAL(16)
#   LET tm.p4    = ARG_VAL(17)
#   LET tm.p5    = ARG_VAL(18)
#   LET tm.p6    = ARG_VAL(19)
#   LET tm.p7    = ARG_VAL(20)
#   LET tm.p8    = ARG_VAL(21) 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
   LET tm.s     = ARG_VAL(13)
   LET tm.t     = ARG_VAL(14)
   LET tm.u     = ARG_VAL(15)   
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
   #No.B620 010626 add  #No.FUN-680123 
   DROP TABLE r630_file
   CREATE TEMP TABLE r630_file
    (oma23 LIKE oma_file.oma23,
     omb14t LIKE omb_file.omb14t,
     omb34 LIKE omb_file.omb34,
     day LIKE omb_file.omb01)
       #No.FUN-680123 end
   DELETE FROM r630_file WHERE 1=1
   #No.B620 end---
   IF cl_null(tm.wc) THEN
      CALL axrr630_tm(0,0)                # Input print condition
   ELSE
      CALL axrr630()                      # Read data and create out-file
   END IF
   DROP TABLE r630_file   #No.B620
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr630_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr630_w AT p_row,p_col
        WITH FORM "axr/42f/axrr630"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate=g_today
   LET tm.edate=g_today
   #FUN-8A0065-Begin--#
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL r630_set_entry_1()               
#   CALL r630_set_no_entry_1()
#   CALL r630_set_comb()  
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end         
   #FUN-8A0065-End--#   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma03, oma15, oma14, omb31
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate ,tm.edate ,
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8A0065
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                                             #FUN-8A0065 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8A0065
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8A0065   
                 tm.more
                WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
         
       #FUN-8A0065--Begin--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                    
#       ON CHANGE  b
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL r630_set_entry_1()      
#          CALL r630_set_no_entry_1()
#          CALL r630_set_comb()       
#       
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
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
       #FUN-8A0065--End--#         
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      #FUN-8A0065--Begin--#      
      ON ACTION CONTROLP
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#         CASE                                                    
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE                        
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
         #FUN-8A0065--End--#      
      
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      
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
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr630','9031',1) 
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,                         
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                         " '",tm.b CLIPPED,"'" ,    #FUN-8A0065
#                         " '",tm.p1 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p2 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p3 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p4 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p5 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p6 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p7 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p8 CLIPPED,"'" ,   #FUN-8A0065          
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                         " '",tm.s CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.t CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.u CLIPPED,"'"      #FUN-8A0065                         
                         
         CALL cl_cmdat('axrr630',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr630()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr630_w
END FUNCTION
 
FUNCTION axrr630()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE za_file.za05,             #No.FUN-680123 VARCHAR(40)
          l_oag02   LIKE oag_file.oag02,
          l_oga02   LIKE oga_file.oga02,
          l_ooa02   LIKE ooa_file.ooa02,
          sr        RECORD
                oma01     LIKE  oma_file.oma01 ,
                oma02     LIKE  oma_file.oma02 ,
                oma03     LIKE  oma_file.oma03 ,
                oma032    LIKE  oma_file.oma032 ,
                oma11     LIKE  oma_file.oma11 ,
                oma23     LIKE  oma_file.oma23 ,
                oma32     LIKE  oma_file.oma32 ,
                omb03     LIKE  omb_file.omb03 ,
                omb31     LIKE  omb_file.omb31 ,
                omb04     LIKE  omb_file.omb04 ,
                omb14t    LIKE  omb_file.omb14t,
                omb16t    LIKE  omb_file.omb16t,
                omb32     LIKE  omb_file.omb32 ,
                omb34     LIKE  omb_file.omb34 ,
                omb35     LIKE  omb_file.omb35 ,
                oga02     LIKE  oga_file.oga02 ,
                day       LIKE  type_file.num10,        #No.FUN-680123 DEC(16,0)   #MOD-840109
                term      LIKE  oag_file.oag02,         #No.FUN-680123 VARCHAR(15)
                omb44     LIKE  omb_file.omb44  
                END RECORD
#NO.FUN-840051---start----
DEFINE     l_ima02      LIKE ima_file.ima02
DEFINE     l_ima021     LIKE ima_file.ima021
DEFINE     l_i          LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
DEFINE     l_dbs        LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     l_azp03      LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     i            LIKE type_file.num5                 #No.FUN-8A0065
DEFINE     l_oma14      LIKE oma_file.oma14                 #No.FUN-8A0065
DEFINE     l_oma15      LIKE oma_file.oma15                 #No.FUN-8A0065
 
 
   CALL cl_del_data(l_table) 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr630'
#NO.FUN-840051---end----     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
   #FUN-8A0065--Begin--#
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
 
#  FOR l_i = 1 to 8                                                          #FUN-8A0065
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
#      LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065
 
     LET l_sql = " SELECT oma01, oma02, oma03, oma032, oma11, oma23, oma32,",
                 " omb03, omb31, omb04, omb14t, omb16t,omb32,omb34,omb35, ",
#                " oga02, '','',oma14,oma15 " ,                              #FUN-8A0065 Add oma14,oma15
                 " '', '','',omb44,oma14,oma15 " ,
#                " FROM ",l_dbs CLIPPED,"oma_file, ",l_dbs CLIPPED,"omb_file, OUTER ",l_dbs CLIPPED,"oga_file ",     #FUN-8A0065 Add ",l_dbs CLIPPED,"
                 " FROM oma_file,omb_file",
                 " WHERE oma02 BETWEEN '" ,tm.bdate,"' AND '",tm.edate,"'",
                 "   AND oma00[1,1] = '1' " ,
                 "   AND oma01 = omb01 ",
#                "   AND omb_file.omb31 = oga_file.oga01 " ,
                 "   AND omaconf = 'Y' AND omavoid = 'N' ",
                 "   AND ", tm.wc CLIPPED
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE axrr630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr630_curs1 CURSOR FOR axrr630_prepare1
 
     DELETE FROM r630_file WHERE 1=1    #No.B620
 
#     CALL cl_outnam('axrr630') RETURNING l_name            #NO.FUN-840051
#     START REPORT axrr630_rep TO l_name                    #NO.FUN-840051
 
     LET g_pageno = 0
     LET l_oga02=''      #No.MOD-B30072
     FOREACH axrr630_curs1 INTO sr.*,l_oma14,l_oma15        #FUN-8A0065 Add l_oma14,l_oma15
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
       LET l_sql = "SELECT oga02 ",                                                                              
                   "  FROM ", cl_get_target_table(sr.omb44, 'oga_file' ),                                                                          
                   " WHERE oga01 = '",sr.omb31,"'"                                                                                                                                                                               
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,sr.omb44) RETURNING l_sql #FUN-A50102        
       PREPARE oga_prepare1 FROM l_sql                                                                                          
       DECLARE oga_c1  CURSOR FOR oga_prepare1                                                                                 
       OPEN oga_c1                                                                                    
       FETCH oga_c1 INTO l_oga02
       LET sr.oga02 = l_oga02  
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
       #-->取最後收款日
       IF g_ooz.ooz62='Y' THEN # bugno.5871
        #FUN-8A0065--Begin--#
#         SELECT MAX(ooa02) INTO l_ooa02 FROM ooa_file,oob_file
#                           WHERE ooa01 = oob01
#                             AND oob06 = sr.oma01
#                             AND oob15 = sr.omb03
#                             AND ooaconf = 'Y'
          LET l_sql = "SELECT MAX(ooa02) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"ooa_file,",                                                                          
#                               l_dbs CLIPPED,"oob_file ",
                      "  FROM ooa_file,oob_file ",
                      " WHERE ooa01 = oob01",
                      "   AND ooa37 = '1'",       #FUN-B20033
                      "   AND oob06 = '",sr.oma01,"'",
                      "   AND oob15 = '",sr.omb03,"'",   
                      "   AND ooaconf = 'Y'"                                                                                                                                                                                   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE ooa_prepare3 FROM l_sql                                                                                          
          DECLARE ooa_c3  CURSOR FOR ooa_prepare3                                                                                 
          OPEN ooa_c3                                                                                    
          FETCH ooa_c3 INTO l_ooa02
        #FUN-8A0065--END--#                              
       ELSE
        #FUN-8A0065--Begin--#
#         SELECT MAX(ooa02) INTO l_ooa02 FROM ooa_file,oob_file
#                           WHERE ooa01 = oob01
#                             AND oob06 = sr.oma01
#                             AND ooaconf = 'Y'
          LET l_sql = "SELECT MAX(ooa02) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"ooa_file,",                                                                          
#                               l_dbs CLIPPED,"oob_file ",
                      "  FROM ooa_file,oob_file ",  
                      " WHERE ooa01 = oob01",
                      "   AND oob06 = '",sr.oma01,"'",  
                      "   AND ooa37 = '1'",        #FUN-B20033
                      "   AND ooaconf = 'Y'"                                                                                                                                                                                   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE ooa_prepare2 FROM l_sql                                                                                          
          DECLARE ooa_c2  CURSOR FOR ooa_prepare2                                                                                 
          OPEN ooa_c2                                                                                    
          FETCH ooa_c2 INTO l_ooa02
        #FUN-8A0065--END--#                              
       END IF
       IF SQLCA.sqlcode OR cl_null(l_ooa02) THEN LET l_ooa02 = NULL END IF
       LET sr.oma11 = l_ooa02
 
       IF cl_null(sr.oga02) THEN LET sr.oga02 = sr.oma02 END IF
       LET sr.day = sr.oma11 - sr.oga02
       IF cl_null(sr.day) THEN LET sr.day=0 END IF
 
       #FUN-8A0065--Begin--#
#      SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = sr.oma32               
       LET l_sql = "SELECT oag02 ",                                                                              
                   #"  FROM ",l_dbs CLIPPED,"oag_file",
                   "  FROM ",cl_get_target_table(sr.omb44,'oag_file'), #FUN-A50102                  
                   " WHERE oag01 = '",sr.oma32,"'"                                                                                                                                                                               
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,sr.omb44) RETURNING l_sql #FUN-A50102
       PREPARE oag_prepare3 FROM l_sql                                                                                          
       DECLARE oag_c3  CURSOR FOR oag_prepare3                                                                                 
       OPEN oag_c3                                                                                    
       FETCH oag_c3 INTO l_oag02
       #FUN-8A0065--END--#
       IF SQLCA.sqlcode OR cl_null(l_oag02) THEN LET l_oag02 = sr.oma32 END IF
       LET sr.term = l_oag02
 
#       OUTPUT TO REPORT axrr630_rep(sr.*)                  #NO.FUN-840051
#NO.FUN-840051-----start------
       #FUN-8A0065--Begin--#       
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
#       FROM azi_file
#       WHERE azi01=sr.oma23
       SELECT azi05 INTO t_azi05
        FROM azi_file
        WHERE azi01=sr.oma23
       LET l_sql = "SELECT azi03,azi04 ",                                                                              
#                  "  FROM ",l_dbs CLIPPED,"azi_file",                                                                          
                   "  FROM azi_file",
                   " WHERE azi01='",sr.oma23,"'"                                                                                                                                                                               
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE azi_prepare3 FROM l_sql                                                                                          
       DECLARE azi_c3  CURSOR FOR azi_prepare3                                                                                 
       OPEN azi_c3                                                                                    
       FETCH azi_c3 INTO t_azi03,t_azi04        
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#       WHERE ima01 = sr.omb04
       LET l_sql = "SELECT ima02,ima021 ",                                                                              
#                  "  FROM ",l_dbs CLIPPED,"ima_file",                                                                          
                   "  FROM ima_file",
                   " WHERE ima01 = '",sr.omb04,"'"                                                                                                                                                                               
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       PREPARE ima_prepare3 FROM l_sql                                                                                          
       DECLARE ima_c3  CURSOR FOR ima_prepare3                                                                                 
       OPEN ima_c3                                                                                    
       FETCH ima_c3 INTO l_ima02,l_ima021
       #FUN-8A0065--END--#          
       EXECUTE insert_prep USING
         sr.oma01,sr.oma02,sr.oma03,sr.oma032,sr.oma11,sr.oma23,sr.oma32,
         sr.omb03,sr.omb31,sr.omb04,sr.omb14t,sr.omb16t,sr.omb32,sr.omb34,
         sr.omb35,sr.oga02,sr.day,sr.term,l_ima02,l_ima021,t_azi04,t_azi05,
#        l_oma14,l_oma15,m_dbs[l_i]                                                #FUN-8A0065  ADD l_oma14,l_oma15 #FUN-8B0118 ADD m_dbs[l_i]
         l_oma14,l_oma15,''  
#NO.FUN-840051---end-------
       #NO.B620 010626 by linda add
       INSERT INTO r630_file VALUES(sr.oma23,sr.omb14t,sr.omb34,sr.day)
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('ins r630_file',SQLCA.SQLCODE,0)   #No.FUN-660116
          CALL cl_err3("ins","r630_file",sr.oma23,sr.omb14t,SQLCA.sqlcode,"","ins r630_file",0)   #No.FUN-660116
          EXIT FOREACH
       END IF
       #No.B620
     END FOREACH
#  END FOR                                                                      #FUN-8A0065     
 
#     FINISH REPORT axrr630_rep                             #NO.FUN-840051
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-840051
#NO.FUN-840051---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'oma03, oma15, oma14, omb31')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",
               tm.s[1,1],";",tm.s[2,2],";",                               #FUN-8A0065
#              tm.s[3,3],";",tm.t,";",tm.u,";",tm.b                       #FUN-8A0065     
               tm.s[3,3],";",tm.t,";",tm.u,";",''
     CALL cl_prt_cs3('axrr630','axrr630',g_sql,g_str)              
#NO.FUN-840051---end----
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
END FUNCTION
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#FUN-8A0065--Begin--#
#FUNCTION r630_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r630_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '5' THEN
#          LET tm2.s1 = ' '
#       END IF
#       IF tm2.s2 = '5' THEN
#          LET tm2.s2 = ' '
#       END IF
#       IF tm2.s3 = '5' THEN
#          LET tm2.s3 = ' '
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r630_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-983' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-982' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8A0065--End--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
#NO.FUN-840051---start--mark----
#REPORT axrr630_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
#          l_flag       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
#          g_head1      STRING,
#          str          STRING,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          sr        RECORD
#                oma01     LIKE  oma_file.oma01,
#                oma02     LIKE  oma_file.oma02,
#                oma03     LIKE  oma_file.oma03,
#                oma032    LIKE  oma_file.oma032,
#                oma11     LIKE  oma_file.oma11,
#                oma23     LIKE  oma_file.oma23,
#                oma32     LIKE  oma_file.oma32,
#                omb03     LIKE  omb_file.omb03,
#                omb31     LIKE  omb_file.omb31,
#                omb04     LIKE  omb_file.omb04,
#                omb14t    LIKE  omb_file.omb14t,
#                omb16t    LIKE  omb_file.omb16t,
#                omb32     LIKE  omb_file.omb32,
#                omb34     LIKE  omb_file.omb34,
#                omb35     LIKE  omb_file.omb35,
#                oga02     LIKE  oga_file.oga02,
#                day       LIKE  type_file.num10,        #No.FUN-680123 DEC(16,0)   #MOD-840109
#                term      LIKE  oag_file.oag02         #No.FUN-680123 VARCHAR(15)
#                END RECORD,
#                 l_oma23        LIKE oma_file.oma23,
#                 l_amt1         LIKE omb_file.omb16t,  ###出貨金額加總
#                 l_amt2         LIKE omb_file.omb35,   ###已收金額加總
#                 l_count1       LIKE type_file.num5,   #No.FUN-680123 SMALLINT
#                 l_ave1         LIKE type_file.num5    #No.FUN-680123 SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
## ORDER BY sr.oma03
#  ORDER BY sr.oma03,sr.oma23
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #No.TQC-6B0051
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790085
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051 #TQC-790085 mark
#      LET g_head1 = g_x[11] CLIPPED,tm.bdate USING'yyyymmdd' ,' - ',
#            tm.edate USING'yyyymmdd'
#      #PRINT g_head1                        #FUN-660060 remark
#      PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#      PRINT g_dash1
#      LET l_last_sw='n'    #No.TQC-6A0102
#      LET l_flag='Y'
#
#
#   BEFORE GROUP OF sr.oma03
#      PRINT COLUMN g_c[31],sr.oma03 CLIPPED,
#            COLUMN g_c[32],sr.oma032 CLIPPED;
#
#   ON EVERY ROW
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位
#        FROM azi_file
#       WHERE azi01=sr.oma23
#      LET str = sr.omb31 CLIPPED, '-', sr.omb32 USING'###'
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#          WHERE ima01 = sr.omb04
#      PRINT COLUMN g_c[33],str,
#            COLUMN g_c[34],sr.oga02,
#            COLUMN g_c[35],sr.oma11,
#            COLUMN g_c[36],sr.day USING '########',  #No.TQC-6A0087 #No.TQC-6A0102
#            COLUMN g_c[36],sr.day,     #No.TQC-6A0102
#            COLUMN g_c[37],sr.omb04 CLIPPED,
#            COLUMN g_c[38],l_ima02 CLIPPED,
#            COLUMN g_c[39],l_ima021 CLIPPED,
#            COLUMN g_c[40],sr.oma23 CLIPPED,
#            COLUMN g_c[41],cl_numfor(sr.omb14t,41,t_azi04),  #出貨金額
#            COLUMN g_c[42],cl_numfor(sr.omb34 ,42,t_azi04),  #已收金額
#            COLUMN g_c[43],sr.term CLIPPED
#
# # AFTER GROUP OF sr.oma03
#   AFTER GROUP OF sr.oma23    #No.B620
#     LET l_ave1   = GROUP AVERAGE(sr.day)  WHERE sr.day > 0
#      LET l_ave1   = GROUP AVG(sr.day)  WHERE sr.day > 0
#      LET l_amt1 = GROUP SUM(sr.omb14t)
#      LET l_amt2 = GROUP SUM(sr.omb34)
#      PRINT COLUMN g_c[38],g_x[12] CLIPPED,
#            COLUMN g_c[39],l_ave1 USING '######&',
#            COLUMN g_c[40],sr.oma23 CLIPPED,             #No.B620 幣別
#            COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi05),  #出貨金額
#            COLUMN g_c[42],cl_numfor(l_amt2,42,t_azi05)   #已收金額
#      PRINT ''
#
#   ON LAST ROW
##     LET l_ave1 = AVERAGE(sr.day)  WHERE sr.day > 0
#      LET l_ave1 = AVG(sr.day)  WHERE sr.day > 0
#      LET l_amt1 = SUM(sr.omb14t)
#      LET l_amt2 = SUM(sr.omb34)
#      PRINT COLUMN g_c[38],g_x[13] CLIPPED,
#            COLUMN g_c[39],l_ave1 USING '######&';
#      #     COLUMN 88, cl_numfor(l_amt1,15,t_azi05),  #出貨金額
#      #     COLUMN 105, cl_numfor(l_amt2,15,t_azi05)   #已收金額
#      #No.B620 010626 by linda add
#      DECLARE r630_t1 CURSOR FOR
#         SELECT oma23,SUM(omb14t),SUM(omb34)
#          FROM r630_file
#         GROUP BY oma23
#         ORDER BY oma23
#      FOREACH r630_t1 INTO l_oma23,l_amt1,l_amt2
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位
#            FROM azi_file
#           WHERE azi01=l_oma23
#          IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
#          PRINT COLUMN  g_c[40], l_oma23 CLIPPED,                #No.B620 幣別
#                COLUMN  g_c[41], cl_numfor(l_amt1,41,t_azi05),   #出貨金額
#                COLUMN  g_c[42], cl_numfor(l_amt2,42,t_azi05)   #已收金額
#      END FOREACH
#      #No.B620 end---
#      #-----TQC-6B0190---------
#      IF  g_zz05 = 'Y' THEN
#          CALL cl_wcchp(tm.wc,'oma03, oma15, oma14, omb31')
#               RETURNING tm.wc
#          PRINT g_dash
#          CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      #-----END TQC-6B0190-----
#      PRINT g_dash[1,g_len]               #No.TQC-6A0102   #TQC-6B0190 unmark
#      LET l_last_sw='y' 
#      #PRINT g_x[14] CLIPPED,g_x[9] CLIPPED     #No.TQC-6A0102   
#      PRINT g_x[14] CLIPPED ,COLUMN g_len-9,g_x[7]   #TQC-6B0190
#
#   PAGE TRAILER
##No.TQC-6A0102 -- begin --
#      IF l_last_sw='n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[14] CLIPPED,g_x[9] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#      #PRINT g_dash[1,g_len]   #TQC-6B0190
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash   #TQC-6B0190
#         #PRINT g_x[14], COLUMN (g_len-9), g_x[8] CLIPPED   #TQC-6B0190
#         PRINT g_x[14], COLUMN (g_len-9), g_x[6] CLIPPED   #TQC-6B0190
#      ELSE
#         #PRINT g_x[14], COLUMN (g_len-9), g_x[9] CLIPPED   #TQC-6B0190
#         SKIP 2 LINE   #TQC-6B0190
#      END IF
##No.TQC-6A0102 -- end --
#END REPORT
#NO.FUN-840051--end---mark---
