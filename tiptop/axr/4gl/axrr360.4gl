# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr360.4gl
# Descriptions...: 逾期應收帳款明細表
# Date & Author..: 95/03/10 by Nick
# Modify.........: 97/07/29 By Sophia 1.未沖金額為0者也印出來
#                                     2.tm.u(最少逾期天數)無判斷
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-5C0015 06/05/30 By rainy 新增發票號碼oma10及INVOICE No. oma67
# Modify.........: No.MOD-660004 06/06/06 By Smapmin 修改未沖金額計算方式
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng 修改報表
# Modify.........: No.FUN-750129 07/06/22 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-840050 08/04/09 by Smapmin 放大變數定義大小
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.MOD-920015 09/02/02 By wujie      逾期的月數不應該除以30，應該按照自然月來推算
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0115 09/11/20 By wujie 报表改抓多帐期资料
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:FUN-B20019 11/02/11 By yinhy SQL增加ooa37='1'的条件
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc       LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000),
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#              b        LIKE type_file.chr1,    #No.FUN-8A0065 VARCHAR(1)
#              p1       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p2       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p3       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p4       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10) 
#              p5       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p6       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p7       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)
#              p8       LIKE azp_file.azp01,    #No.FUN-8A0065 VARCHAR(10)            
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
              s        LIKE type_file.chr6,    # Order by sequence  #No.FUN-680123 VARCHAR(3)
              t        LIKE type_file.chr3,    # Eject sw #No.FUN-680123 VARCHAR(3)
              u        LIKE type_file.chr3,    # Group total sw #No.FUN-680123 VARCHAR(3)
	      edate    LIKE type_file.dat,     #No.FUN-680123 DATE
	      n        LIKE type_file.num5,    #No.FUN-680123 SMALLINT
              a        LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(1)               
              more     LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(1)
              END RECORD
 
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i             LIKE type_file.num5     #No.FUN-680123 SMALLINT
DEFINE l_table         STRING  #No.FUN-750129
DEFINE g_str           STRING  #No.FUN-750129
DEFINE g_sql           STRING  #No.FUN-750129
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
# DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   #WHENEVER ERROR CONTINUE
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #No.FUN-750129  --Begin
   LET g_sql = " order1.oma_file.oma03,",
               " order2.oma_file.oma03,",
               " order3.oma_file.oma03,",
               " gem01.gem_file.gem01,", 
               " gem02.gem_file.gem02,", 
               " gen01.gen_file.gen01,", 
               " gen02.gen_file.gen02,", 
               " oma03.oma_file.oma03,", 
               " oma032.oma_file.oma032,",
               " oma00.oma_file.oma00,", 
               #" oma00_desc.type_file.chr4,",   #MOD-840050
               " oma00_desc.type_file.chr1000,",   #MOD-840050
               " oma02.oma_file.oma02,", 
               " oma11.oma_file.oma11,", 
               " oma14.oma_file.oma14,", 
               " oma15.oma_file.oma15,", 
               " overday.type_file.num5,",
               " oma01.oma_file.oma01,", 
               " oma16.oma_file.oma16,", 
               " oma23.oma_file.oma23,", 
               " oma54t.oma_file.oma54t,",
               " oma10.oma_file.oma10,", 
               " oma67.oma_file.oma67,", 
               " balance.oma_file.oma54,",
               " oma32.oma_file.oma32,", 
               " azi03.azi_file.azi03,", 
               " azi04.azi_file.azi04,", 
               " azi05.azi_file.azi05,", 
               " str.type_file.chr1000,",
               " str2.type_file.chr1000, ",
               " plant.azp_file.azp01"                                           #FUN-8A0065                                              
   LET l_table = cl_prt_temptable('axrr360',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"                          #FUN-8A0065 Add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.a = ARG_VAL(11)
   LET tm.edate = ARG_VAL(12)
   LET tm.n = ARG_VAL(13) 
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
   #No.FUN-8A0065 --start--
#   LET tm.b     = ARG_VAL(18)
#   LET tm.p1    = ARG_VAL(19)
#   LET tm.p2    = ARG_VAL(20)
#   LET tm.p3    = ARG_VAL(21)
#   LET tm.p4    = ARG_VAL(22)
#   LET tm.p5    = ARG_VAL(23)
#   LET tm.p6    = ARG_VAL(24)
#   LET tm.p7    = ARG_VAL(25)
#   LET tm.p8    = ARG_VAL(26)   
   #No.FUN-8A0065 ---end---     
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end       
   #genero版本default 排序,跳頁,合計值
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
   #no.5196  #No.FUN-680123
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp
    (curr LIKE azi_file.azi01,
     amt1 LIKE type_file.num20_6,
     amt2 LIKE type_file.num20_6,
     order1 LIKE oma_file.oma03,
     order2 LIKE oma_file.oma03,
     order3 LIKE oma_file.oma03)
   #no.5196(end) #No.FUN-680123 end
 
   IF cl_null(tm.wc)
      THEN CALL axrr360_tm(0,0)                     # Input print condition
   ELSE                                   
      CALL axrr360()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr360_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr360_w AT p_row,p_col
        WITH FORM "axr/42f/axrr360"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s='123'
   LET tm.t='Y  '
   LET tm.u='Y  '
   LET tm.edate=g_today
   LET tm.n=30
   LET tm.a='1'
   #FUN-8A0065-Begin--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin   
#   LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL r360_set_entry_1()               
#   CALL r360_set_no_entry_1()
#   CALL r360_set_comb()
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end              
   #FUN-8A0065-End--#   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma15,oma14,oma03,oma00,oma02,oma11,oma01,
							  oma16,oma23
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
        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oma01)  #genero要改查單據單(未改)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_oma6'
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry()  RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma01
                   NEXT FIELD oma01
              WHEN INFIELD(oma03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma03
              WHEN INFIELD(oma14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14
              WHEN INFIELD(oma15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.plant = g_plant
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma15
                   NEXT FIELD oma15
              WHEN INFIELD(oma23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma23
                   NEXT FIELD oma23
              END CASE
        #No.FUN-C40001  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr360_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8A0065
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                                             #FUN-8A0065
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,tm.edate,tm.n,tm.a,tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin         
       #FUN-8A0065--Begin--#
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
#          CALL r360_set_entry_1()      
#          CALL r360_set_no_entry_1()
#          CALL r360_set_comb()                               
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
       #FUN-8A0065--End--#         
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n<0 THEN
            NEXT FIELD n
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
 
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,2],tm2.s2[1,2],tm2.s3[1,2]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr360_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr360'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr360','9031',1)
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
                         " '",tm.s CLIPPED,"'" ,    #TQC-610059
                         " '",tm.t CLIPPED,"'" ,    #TQC-610059
                         " '",tm.u CLIPPED,"'" ,    #TQC-610059
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                         " '",tm.b CLIPPED,"'" ,    #FUN-8A0065
#                         " '",tm.p1 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p2 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p3 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p4 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p5 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p6 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p7 CLIPPED,"'" ,   #FUN-8A0065
#                         " '",tm.p8 CLIPPED,"'"     #FUN-8A0065                         
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end                         
         CALL cl_cmdat('axrr360',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr360_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr360()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr360_w
END FUNCTION
 
FUNCTION axrr360()
   DEFINE 
          l_name      LIKE type_file.chr20,     # External(Disk) file name #No.FUN-680123 VARCHAR(20)  
#       l_time          LIKE type_file.chr8          #No.FUN-6A0095
         #l_sql       VARCHAR(1000),               #MOD-660004
          l_sql       STRING,                   #MOD-660004    
          l_amt       LIKE oob_file.oob09,      #MOD-660004
          l_za05      LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(40)
	  l_omavoid   LIKE oma_file.omavoid,
	  l_omaconf   LIKE oma_file.omaconf,
          l_order     ARRAY[5] OF LIKE oma_file.oma03,  #No.FUN-680123 VARCHAR(10)
          sr         RECORD
		            order1    LIKE oma_file.oma03,          #No.FUN-680123 VARCHAR(10)
		            order2    LIKE oma_file.oma03,          #No.FUN-680123 VARCHAR(10)
		            order3    LIKE oma_file.oma03,          #No.FUN-680123 VARCHAR(10)
                gem01	    LIKE gem_file.gem01,		#部門編號
                gem02	    LIKE gem_file.gem02,		#部門名稱
                gen01     LIKE gen_file.gen01,		#業務員編號
                gen02     LIKE gen_file.gen02,		#業務員姓名
	              oma03	    LIKE oma_file.oma03,		#客戶
                oma032    LIKE oma_file.oma032,		#簡稱
                oma00     LIKE oma_file.oma00,		#類別
          #	oma00_desc LIKE oma_file.oma00,         #類別說明 #No.FUN-680123 VARCHAR(6)
                #oma00_desc LIKE type_file.chr4,         #類型說明 #No.TQC-6B0051   #MOD-840050
                oma00_desc LIKE type_file.chr1000,       #類型說明 #No.TQC-6B0051   #MOD-840050
		            oma02     LIKE oma_file.oma02,		#帳款日期
		            oma11	    LIKE oma_file.oma11,		#應收款日
	            	oma14	    LIKE oma_file.oma14,		#人員編號
		            oma15	    LIKE oma_file.oma15,		#部門編號
                overday   LIKE type_file.num5,          #逾期天數 #No.FUN-680123 SMALLINT
                oma01	    LIKE oma_file.oma01,		#帳款編號
                oma16     LIKE oma_file.oma16,		#參考單號
		            oma23	    LIKE oma_file.oma23,		#幣別
                oma54t    LIKE oma_file.oma54t,		#應收金額
                oma10     LIKE oma_file.oma10,          #發票號碼
                oma67     LIKE oma_file.oma67,          #INVOICE No.
                balance   LIKE oma_file.oma54,		#未沖金額
		            oma32	    LIKE oma_file.oma32,		#收款條件
		            azi03	    LIKE azi_file.azi03,		#
		            azi04	    LIKE azi_file.azi04,		#
		            azi05	    LIKE azi_file.azi05		#
                END RECORD
#No.FUN-750129  --Begin
DEFINE          str       LIKE type_file.chr1000,
                str2      LIKE type_file.chr1000
#No.FUN-750129  --End
DEFINE     l_i        LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
DEFINE     l_dbs      LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     l_azp03    LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     i          LIKE type_file.num5                 #No.FUN-8A0065
#No.MOD-920015 --begin
DEFINE l_yy,l_yy1,l_mm,l_mm1,l_dd,l_dd1  LIKE type_file.num5
DEFINE l_str3       LIKE type_file.chr1000
#No.MOD-920015 --end
DEFINE l_month   LIKE type_file.num5   #NO.FUN-A10098
DEFINE l_date    LIKE type_file.num5   #NO.FUN-A10098
DEFINE l_year    LIKE type_file.num5   #NO.FUN-A10098

 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
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
 
     #No.FUN-750129  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     ##no.5196
     #DELETE FROM curr_tmp;
 
     #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",
     #          "   FROM curr_tmp ",
     #          "  WHERE order1=? ",
     #          "  GROUP BY curr  "
     #PREPARE r360_prepare_1 FROM l_sql
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
     #END IF
     #DECLARE curr_temp1 CURSOR FOR r360_prepare_1
 
     #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",
     #          "   FROM curr_tmp ",
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "  GROUP BY curr  "
     #PREPARE r360_prepare_2 FROM l_sql
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
     #END IF
     #DECLARE curr_temp2 CURSOR FOR r360_prepare_2
 
     #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2) ",
     #          "   FROM curr_tmp ",
     #          "  WHERE order1=? ",
     #          "    AND order2=? ",
     #          "    AND order3=? ",
     #          "  GROUP BY curr  "
     #PREPARE r360_prepare_3 FROM l_sql
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
     #END IF
     #DECLARE curr_temp3 CURSOR FOR r360_prepare_3
     ##no.5196(end)
     #No.FUN-750129  --End
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin     

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
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   FOR l_i = 1 to 8                                                          #FUN-8A0065
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
#       LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065     
 
 
     LET l_date=DAY(tm.edate)           #NO.FUN-A10098
     LET l_month= MONTH(tm.edate)       #NO.FUN-A10098 
     LET l_year = YEAR(tm.edate)        #NO.FUN-A10098 
     LET l_sql=" SELECT '','','',gem01,gem02,gen01,gen02,oma03,oma032,oma00,'',",
#No.MOD-9B0115 --begin
                "oma02,omc04,oma14,oma15,0,oma01,oma16,oma23,omc08,omc12,oma67,", #FUN-5C0014 add oma10,oma67
                "omc08-omc10,oma32,azi03,azi04,azi05 ",      
#              "oma02,oma11,oma14,oma15,0,oma01,oma16,oma23,oma54t,oma10,oma67,", #FUN-5C0014 add oma10,oma67
#              "oma54t-oma55,oma32,azi03,azi04,azi05 ",
#No.MOD-9B0115 --end
#              " FROM oma_file,OUTER gem_file,OUTER gen_file,OUTER azi_file ",            #FUN-8A0065 Mark
#              " FROM ",l_dbs CLIPPED,"oma_file, OUTER ",l_dbs CLIPPED,"gem_file, ",      #FUN-8A0065 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#              " FROM ",l_dbs CLIPPED,"oma_file, OUTER ",l_dbs CLIPPED,"gem_file, ",l_dbs CLIPPED,"omc_file,",
#              " OUTER ",l_dbs CLIPPED,"gen_file, OUTER ",l_dbs CLIPPED,"azi_file ",      #FUN-8A0065               
               " FROM oma_file LEFT OUTER join gem_file ON oma_file.oma15=gem_file.gem01 ",
               " LEFT OUTER join gen_file ON oma_file.oma14=gen_file.gen01 ",
               " LEFT OUTER join azi_file ON oma_file.oma23=azi_file.azi01,", 
               " omc_file ",
#              " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 AND oma11<='",tm.edate,"'",
               " WHERE oma11<='",tm.edate,"'", 
              #-----MOD-660004---------
              #"   AND oma54t-oma55 > 0 ",     #97/07/29 modify未沖金額
              "   AND oma01 = omc01",    #No.MOD-9B0115   
              "   AND (oma54t-oma55 > 0 OR ",     #97/07/29 modify未沖金額
#             "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file ",   #FUN-8A0065 Add ",l_dbs CLIPPED,"
              "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ", 
              "                   WHERE ooa01=oob01 ",
              "                     AND ooaconf = 'Y' ",
              "                     AND ooa37 = '1' ",                  #FUN-B20019 add
              "                     AND ooa02 >'",tm.edate,"' )) ",
              #-----END MOD-660004-----
             #"   AND ('",tm.edate,"' - oma11) > ",tm.n, #97/07/29最少逾期天數     #NO.FUN-A10098
             "   AND (MDY(",l_month,",",l_date,",",l_year,") - oma11) > ",tm.n, #97/07/29最少逾期天數   #NO.FUN-A10098 
              "   AND omavoid = 'N'",
#              "   AND oma_file.oma23=azi_file.azi01 AND  oma00 MATCHES '1*' AND ",tm.wc
#             "   AND oma_file.oma23=azi_file.azi01 AND  oma00 like '1%' AND ",tm.wc    #No.MOD-9B0115
              "   AND  oma00 like '1%' AND ",tm.wc
       ###GP5.2  #NO.FUN-A10098 dxfwo mark end
     CASE WHEN tm.a = '1'   #已確認
             LET l_sql = l_sql CLIPPED," AND omaconf = 'Y'"
          WHEN tm.a = '2'   #未確認
             LET l_sql = l_sql CLIPPED," AND omaconf = 'N'"
          WHEN tm.a = '3'   #全部
	     LET l_sql= l_sql CLIPPED
     END CASE
 
 
	 LET l_sql= l_sql CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE axrr360_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr360_curs1 CURSOR FOR axrr360_prepare1
 
     #No.FUN-750129  --Begin
     #CALL cl_outnam('axrr360') RETURNING l_name
     #START REPORT axrr360_rep TO l_name
 
     #LET g_pageno = 0
     #No.FUN-750129  --End
     FOREACH axrr360_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
	         LET sr.overday=tm.edate-sr.oma11
           #-----MOD-660004---------
           LET l_amt = 0
           #FUN-8A0065--Begin--#
           SELECT azi05 INTO sr.azi05 FROM azi_file
            WHERE azi01 = sr.oma23           
#          SELECT SUM(oob09) INTO l_amt FROM oob_file,ooa_file
#            WHERE ooa01 = oob01 AND
#                  oob06 = sr.oma01 AND
#                  ooaconf = 'Y' AND
#                  ooa02 > tm.edate
          LET l_sql = "SELECT SUM(oob09) ",                                                                              
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                     "  FROM ",l_dbs CLIPPED,"oob_file,",                                                                          
#                               l_dbs CLIPPED,"ooa_file ",
                      "  FROM oob_file,ooa_file",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
                      " WHERE ooa01 = oob01",
                      "   AND oob06 = '",sr.oma01,"'",
                      "   AND ooaconf = 'Y'",   
                      "   AND ooa37 = '1'",                  #FUN-B20019 add  
                      "   AND ooa02 > '",tm.edate,"'"                                                                                                                                                                                   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE oob09_prepare3 FROM l_sql                                                                                          
          DECLARE oob09_c3  CURSOR FOR oob09_prepare3                                                                                 
          OPEN oob09_c3                                                                                    
          FETCH oob09_c3 INTO l_amt
          #FUN-8A0065--End--#                   
           IF cl_null(l_amt) THEN LET l_amt = 0 END IF
           LET sr.balance = sr.balance + l_amt
           #-----END MOD-660004-----
       #No.FUN-750129  --Begin
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oma15
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oma14
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oma03
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oma00
       #        WHEN tm.s[g_i,g_i] = '5'
       #             LET l_order[g_i] = sr.oma02 USING 'YYYYMMDD'
       #        WHEN tm.s[g_i,g_i] = '6'
       #             LET l_order[g_i] = sr.oma11 USING 'YYYYMMDD'
       #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oma01
       #        WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oma16
       #        WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oma23
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #No.FUN-750129  --End
       CALL r360_getdesc(sr.oma00) RETURNING sr.oma00_desc
       #No.FUN-750129  --Begin			
       #IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       #IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       #IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
       #OUTPUT TO REPORT axrr360_rep(sr.*)
#No.MOD-920015 --begin
       LET l_yy =YEAR(tm.edate)
       LET l_mm =MONTH(tm.edate)
       LET l_dd =DAY(tm.edate)
       LET l_yy1=YEAR(sr.oma11)
       LET l_mm1=MONTH(sr.oma11)
       LET l_dd1=DAY(sr.oma11)
       LET l_str3=l_yy*12+l_mm-l_yy1*12-l_mm1
       IF l_str3 >=0 THEN
          IF l_dd>l_dd1 THEN
             LET l_str3 =l_str3+1
          END IF
       END IF
       LET l_str3 =l_str3 CLIPPED
#      LET str = sr.overday USING '##&','(',sr.overday/30 USING '#&',')'
       LET str = sr.overday USING '##&','(',l_str3 USING '#&',')'
#No.MOD-920015 --end
       #LET str2 = sr.oma00,' ',sr.oma00_desc[1,4]   #MOD-840050
       LET str2 = sr.oma00,' ',sr.oma00_desc CLIPPED   #MOD-840050
#       EXECUTE insert_prep USING sr.*,str,str2,m_dbs[l_i]                                    #FUN-8B0118 Add m_dbs[l_i]
       EXECUTE insert_prep USING sr.*,str,str2,''
       #No.FUN-750129  --End
     END FOREACH
#  END FOR                                                                      #FUN-8A0065
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
     #No.FUN-750129  --Begin
     #FINISH REPORT axrr360_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oma15,oma14,oma03,oma00,oma02,oma11,oma01,oma16,oma23')
             RETURNING g_str
     END IF
#    IF tm.b = 'Y' THEN                                                          #FUN-8A0065
#       LET l_name = 'axrr360_1'                                                 #FUN-8A0065
#    ELSE                                                                        #FUN-8A0065
     	  LET l_name = 'axrr360'                                                   #FUN-8A0065
#    END IF	                                                                     #FUN-8A0065     
#    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",            #FUN-8A0065 Mark     
     LET g_str = g_str,";",tm2.s1,";",tm2.s2,";",tm2.s3,";",                     #FUN-8A0065
#                 tm.edate+tm.n,";",tm.edate,";",tm.n,";",tm.t,";",tm.u,";",tm.b  #FUN-8A0065 Add tm.b
                 tm.edate+tm.n,";",tm.edate,";",tm.n,";",tm.t,";",tm.u,";",''
     CALL cl_prt_cs3('axrr360',l_name,g_sql,g_str)                               #FUN-8A0065 Add l_name 
     #No.FUN-750129  --End
END FUNCTION
 
FUNCTION r360_getdesc(l_oma00)
DEFINE l_oma00     LIKE oma_file.oma00,
       #l_desc      LIKE type_file.chr4                #No.FUN-680123 VARCHAR(4)   #MOD-840050
       l_desc      LIKE type_file.chr1000                #No.FUN-680123 VARCHAR(4)   #MOD-840050
CASE l_oma00
	WHEN '11' LET l_desc=cl_getmsg('axr-231',g_lang)
	WHEN '12' LET l_desc=cl_getmsg('axr-232',g_lang)
	WHEN '13' LET l_desc=cl_getmsg('axr-233',g_lang)
	WHEN '14' LET l_desc=cl_getmsg('axr-234',g_lang)
END CASE
RETURN l_desc
END FUNCTION
 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#FUN-8A0065--Begin--#
#FUNCTION r360_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r360_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '10' THEN
#          LET tm2.s1 = ' '
#       END IF
#       IF tm2.s2 = '10' THEN
#          LET tm2.s2 = ' '
#       END IF
#       IF tm2.s3 = '10' THEN
#          LET tm2.s3 = ' '
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r360_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6,7,8,9'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-987' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7,8,9,10'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-986' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8A0065--End--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
#No.FUN-750129  --Begin
{
REPORT axrr360_rep(sr)
   DEFINE
          l_last_sw    LIKE type_file.chr1,           #No.FUN-680123 VARCHAR(1)
          str          STRING,
          str2         STRING,
          g_head1      STRING,
          sr        RECORD
		order1    LIKE oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
		order2    LIKE oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
		order3    LIKE oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
                gem01	  LIKE gem_file.gem01,	      #部門編號
                gem02	  LIKE gem_file.gem02,	      #部門名稱
                gen01     LIKE gen_file.gen01,	      #業務員編號
                gen02     LIKE gen_file.gen02,	      #業務員姓名
	        oma03	  LIKE oma_file.oma03,	      #客戶
                oma032    LIKE oma_file.oma032,	      #簡稱
                oma00     LIKE oma_file.oma00,	      #類別
       #	oma00_desc LIKE oma_file.oma00,       #類別說明 #No.FUN-680123 VARCHAR(6)
                oma00_desc LIKE type_file.chr4,       #類型說明 #No.TQC-6B0051
		oma02     LIKE oma_file.oma02,	      #帳款日期
		oma11	  LIKE oma_file.oma11,	      #應收款日
		oma14	  LIKE oma_file.oma14,	      #人員編號
		oma15	  LIKE oma_file.oma15,	      #部門編號
                overday   LIKE type_file.num5,        #逾期天數 #No.FUN-680123 SMALLINT
                oma01	  LIKE oma_file.oma01,	      #帳款編號
                oma16     LIKE oma_file.oma16,	      #參考單號
		oma23	  LIKE oma_file.oma23,	      #幣別
                oma54t    LIKE oma_file.oma54t,	      #應收金額
                oma10     LIKE oma_file.oma10,        #發票號碼
                oma67     LIKE oma_file.oma67,        #INVOICE NO.
                balance   LIKE oma_file.oma54,	      #未沖金額
		oma32	  LIKE oma_file.oma32,	      #收款條件
		azi03	  LIKE azi_file.azi03,	      #
		azi04	  LIKE azi_file.azi04,	      #
		azi05	  LIKE azi_file.azi05	      #
                END RECORD,
         l_flag           LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
		l_oma54t  LIKE oma_file.oma54t,
		l_balance LIKE oma_file.oma54t,
		l_amt1	  LIKE oma_file.oma54,
		l_amt2	  LIKE oma_file.oma54x,
		l_amt3	  LIKE oma_file.oma54t,
		l_amt4	  LIKE oma_file.oma55,
		l_buf	  LIKE type_file.chr1000,     #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
#       l_time	        LIKE type_file.chr8	      #No.FUN-6A0095
	        l_curr    LIKE azi_file.azi01         #No.FUN-680123 VARCHAR(04)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.oma01
  FORMAT
   PAGE HEADER
	  LET l_flag = 'N'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0051
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0051
      LET g_head1 = g_x[24] CLIPPED,' '
	  FOR i=1 TO 3
		 CASE tm.s[i,i]
			WHEN '1' LET g_head1 = g_head1,g_x[15] CLIPPED,' '
			WHEN '2' LET g_head1 = g_head1,g_x[16] CLIPPED,' '
			WHEN '3' LET g_head1 = g_head1,g_x[17] CLIPPED,' '
			WHEN '4' LET g_head1 = g_head1,g_x[18] CLIPPED,' '
			WHEN '5' LET g_head1 = g_head1,g_x[19] CLIPPED,' '
			WHEN '6' LET g_head1 = g_head1,g_x[20] CLIPPED,' '
			WHEN '7' LET g_head1 = g_head1,g_x[21] CLIPPED,' '
			WHEN '8' LET g_head1 = g_head1,g_x[22] CLIPPED,' '
			WHEN '9' LET g_head1 = g_head1,g_x[23] CLIPPED,' '
		END CASE
	  END FOR
      PRINT g_head1
      #LET g_head1 = g_x[12] CLIPPED,tm.edate+tm.n USING 'yy/mm/dd' #FUN-570250 mark
      LET g_head1 = g_x[12] CLIPPED,tm.edate+tm.n #FUN-570250 add
      PRINT g_head1;
#No.TQC-6B0051  --begin
      LET str = g_x[11] CLIPPED,tm.edate
      PRINT COLUMN 27,str;
      LET str = g_x[12] CLIPPED,tm.n USING '###' 
      PRINT COLUMN 52,str 
#No.TQC-6B0051  --end  
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],
            g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48] #FUN-5C0014
      PRINT g_dash1
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
            LET str = sr.overday USING '##&','(',sr.overday/30 USING '#&',')'
            LET str2 = sr.oma00,' ',sr.oma00_desc[1,4]
      PRINT COLUMN g_c[31],sr.gem01,
            COLUMN g_c[32],sr.gem02,
            COLUMN g_c[33],sr.gen01,
            COLUMN g_c[34],sr.gen02,
            COLUMN g_c[35],sr.oma03,
            COLUMN g_c[36],sr.oma032,
            COLUMN g_c[37],str2,
            COLUMN g_c[38],sr.oma02,
            COLUMN g_c[39],sr.oma11,
            COLUMN g_c[40],str,
            COLUMN g_c[41],sr.oma01,
            COLUMN g_c[42],sr.oma16,
            COLUMN g_c[43],sr.oma23,
            COLUMN g_c[44],cl_numfor(sr.oma54t,44,sr.azi04),
            COLUMN g_c[45], cl_numfor(sr.balance,45,sr.azi04),
            COLUMN g_c[46],sr.oma32,
            COLUMN g_c[47],sr.oma10,
            COLUMN g_c[48],sr.oma67
            
      #no.5196
         INSERT INTO curr_tmp VALUES(sr.oma23,sr.oma54t,sr.balance,sr.order1,sr.order2,sr.order3)
      #no.5196(end)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
		 CASE tm.s[1,1]
			WHEN '1' LET l_buf= g_x[15] CLIPPED
			WHEN '2' LET l_buf= g_x[16] CLIPPED
			WHEN '3' LET l_buf= g_x[17] CLIPPED
			WHEN '4' LET l_buf= g_x[18] CLIPPED
			WHEN '5' LET l_buf= g_x[19] CLIPPED
			WHEN '6' LET l_buf= g_x[20] CLIPPED
			WHEN '7' LET l_buf= g_x[21] CLIPPED
			WHEN '8' LET l_buf= g_x[22] CLIPPED
			WHEN '9' LET l_buf= g_x[23] CLIPPED
		 END CASE
     #no.5196
         PRINT COLUMN g_c[43],g_dash2[1,g_w[43]+g_w[44]+g_w[45]+2]
         FOREACH curr_temp1 USING sr.order1
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05   #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
         PRINT COLUMN g_c[42],g_x[13] CLIPPED,
               COLUMN g_c[43],l_curr CLIPPED,
               COLUMN g_c[44], cl_numfor(l_amt1,44,t_azi05),  #No.CHI-6A0004
               COLUMN g_c[45], cl_numfor(l_amt2,45,t_azi05)   #No.CHI-6A0004 
         END FOREACH
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
		 CASE tm.s[2,2]
			WHEN '1' LET l_buf= g_x[15] CLIPPED
			WHEN '2' LET l_buf= g_x[16] CLIPPED
			WHEN '3' LET l_buf= g_x[17] CLIPPED
			WHEN '4' LET l_buf= g_x[18] CLIPPED
			WHEN '5' LET l_buf= g_x[19] CLIPPED
			WHEN '6' LET l_buf= g_x[20] CLIPPED
			WHEN '7' LET l_buf= g_x[21] CLIPPED
			WHEN '8' LET l_buf= g_x[22] CLIPPED
			WHEN '9' LET l_buf= g_x[23] CLIPPED
		 END CASE
     #no.5196
         PRINT COLUMN g_c[43],"------------------------------------------"
         FOREACH curr_temp2 USING sr.order1,sr.order2
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05    #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
         PRINT COLUMN g_c[42],g_x[13] CLIPPED,
               COLUMN g_c[43],l_curr CLIPPED,
               COLUMN g_c[44], cl_numfor(l_amt1,44,t_azi05),   #No.CHI-6A0004
               COLUMN g_c[45], cl_numfor(l_amt2,45,t_azi05)    #No.CHI-6A0004
         END FOREACH
         PRINT ''
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
		 CASE tm.s[3,3]
			WHEN '1' LET l_buf= g_x[15] CLIPPED
			WHEN '2' LET l_buf= g_x[16] CLIPPED
			WHEN '3' LET l_buf= g_x[17] CLIPPED
			WHEN '4' LET l_buf= g_x[18] CLIPPED
			WHEN '5' LET l_buf= g_x[19] CLIPPED
			WHEN '6' LET l_buf= g_x[20] CLIPPED
			WHEN '7' LET l_buf= g_x[21] CLIPPED
			WHEN '8' LET l_buf= g_x[22] CLIPPED
			WHEN '9' LET l_buf= g_x[23] CLIPPED
		 END CASE
     #no.5196
         PRINT COLUMN g_c[43],"------------------------------------------"
         FOREACH curr_temp3 USING sr.order1,sr.order2,sr.order3
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05    #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
         PRINT COLUMN g_c[43],l_curr CLIPPED,
               COLUMN g_c[44], cl_numfor(l_amt1,44,t_azi05),   #No.CHI-6A0004 
               COLUMN g_c[45], cl_numfor(l_amt2,45,t_azi05)    #No.CHI-6A0004 
         END FOREACH
         PRINT ''
      END IF
      #no.5196(end)
   ON LAST ROW
        LET l_flag='Y' 
 
   PAGE TRAILER
         PRINT g_dash[1,g_len]
#        PRINT COLUMN g_c[31],'(axrr360)';  #No.TQC-6B0051 
         PRINT COLUMN g_c[31],g_x[25] CLIPPED; #No.TQC-6B0051
#No.TQC-6B0051  --begin
#        LET str = g_x[11] CLIPPED,tm.edate
#        PRINT COLUMN g_c[37],str;
#        LET str = g_x[12] CLIPPED,tm.n USING '###' 
#        PRINT COLUMN g_c[40],str;
#No.TQC-6B0051  --end
         #No.TQC-6B0051  --begin
         IF l_flag ='Y' THEN
            PRINT COLUMN g_len-9,g_x[9] CLIPPED
            PRINT
         ELSE 
            PRINT COLUMN g_len-9,g_x[8] CLIPPED
            PRINT
         END IF
         #No.TQC-6B0051  --end
         PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
END REPORT
}
#No.FUN-750129  --End
