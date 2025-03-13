# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr361.4gl
# Descriptions...: 逾期應收帳款明細表-已收款
# Date & Author..: 97/09/11 by Sophia
# Modify.........: 99/07/28 By Kammy(金額改show本幣)
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-5B0123 05/11/14 By CoCo 頁碼寫法調整
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表        
# Modify.........: No.MOD-720047 07/03/15 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.MOD-920015 09/02/02 By wujie      逾期的月數不應該除以30，應該按照自然月來推算
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:FUN-B20019 11/02/11 By yinhy SQL增加ooa37='1'的条件
# Modify.........: No:CHI-B40013 11/04/25 By Sarah 報表增加顯示ooa01與oma01,ooa01放在收款日前面,oma01放在發票號碼前面
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
             #wc       VARCHAR(1000),             # Where condition
              wc       LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
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
              s        LIKE type_file.chr3,    # Order by sequence #No.FUN-680123 VARCHAR(3)
              t        LIKE type_file.chr3,    # Eject sw #No.FUN-680123 VARCHAR(3)
              u        LIKE type_file.chr3,    # Group total sw #No.FUN-680123 VARCHAR(3)
	      n        LIKE type_file.num5,    #No.FUN-680123 SMALLINT   
              a        LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(1)
              more     LIKE type_file.chr1     # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD
 
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680123 SMALLINT
DEFINE   i             LIKE type_file.num5     #No.FUN-680123 SMALLINT
DEFINE    l_table     STRING,                 ### CR11 ###
          g_str       STRING,                 ### CR11 ###
          g_sql       STRING                  ### CR11 ###
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#DEFINE    m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end 
        
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #MOD-720047 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/03/16 TSD.Martin  *** ##
   LET g_sql ="gen01.gen_file.gen01,",	   #業務員編號
              "gen02.gen_file.gen02,",	   #業務員姓名
              "ooa03.ooa_file.ooa03,",	   #客戶
              "ooa032.ooa_file.ooa032,",   #簡稱
              "ooa02.ooa_file.ooa02,",	   #收款日
              "ooa14.ooa_file.ooa14,",	   #人員編號
              "ooa15.ooa_file.ooa15,",	   #部門編號
              "overday.type_file.num5,",   #逾期天數 #No.FUN-680123 SMALLINT
              "ooa01.ooa_file.ooa01,",	   #帳款編號
      	      "ooa23.ooa_file.ooa23,",	   #幣別
              "oob06.oob_file.oob06,",     #參考單號
              "oma01.oma_file.oma01,",     #帳款編號 #CHI-B40013 add
              "oma10.oma_file.oma10,",     #發票號碼
      	      "oma32.oma_file.oma32,",	   #收款條件
              "oma11.oma_file.oma11,",     #應收款日
              "oma12.oma_file.oma12,",     #票據到期日
              "balance.oob_file.oob10,",   #收款金額
      	      "azi03.azi_file.azi03,",
              "azi04.azi_file.azi04,",
      	      "azi05.azi_file.azi05,",
              "str.type_file.chr1000,",
              "plant.azp_file.azp01"                                                #FUN-8A0065
 
    LET l_table = cl_prt_temptable('axrr361',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?,", 
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #FUN-8A0065 Add ?  #CHI-B40013 add ?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
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
   LET tm.n = ARG_VAL(12)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
       ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
   #No.FUN-8A0065 --start--
#   LET tm.b     = ARG_VAL(17)
#   LET tm.p1    = ARG_VAL(18)
#   LET tm.p2    = ARG_VAL(19)
#   LET tm.p3    = ARG_VAL(20)
#   LET tm.p4    = ARG_VAL(21)
#   LET tm.p5    = ARG_VAL(22)
#   LET tm.p6    = ARG_VAL(23)
#   LET tm.p7    = ARG_VAL(24)
#   LET tm.p8    = ARG_VAL(25)       
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
     order1 LIKE ooa_file.ooa03,
     order2 LIKE ooa_file.ooa03,
     order3 LIKE ooa_file.ooa03)
   #no.5196(end)  #No.FUN-680123 end
 
   IF cl_null(tm.wc)
      THEN CALL axrr361_tm(0,0)                     # Input print condition
   ELSE 
      CALL axrr361()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr361_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr361_w AT p_row,p_col
        WITH FORM "axr/42f/axrr361"
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
   LET tm.n=30
   LET tm.a='1'
   #FUN-8A0065-Begin--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#   LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL r361_set_entry_1()               
#   CALL r361_set_no_entry_1()
#   CALL r361_set_comb()           
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
   #FUN-8A0065-End--#    
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa15,ooa14,ooa03,ooa02,ooa01,oob06,ooa23
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
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa"
                 LET g_qryparam.arg1 = "1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ool"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa13
                 NEXT FIELD ooa13
              WHEN INFIELD(ooa14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa14
                 NEXT FIELD ooa14
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              WHEN INFIELD(ooa23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa23
                 NEXT FIELD ooa23
              END CASE
        #No.FUN-C40001  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr361_w 
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
                 tm2.u1,tm2.u2,tm2.u3,tm.a,tm.n,tm.more
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
#          CALL r361_set_entry_1()      
#          CALL r361_set_no_entry_1()
#          CALL r361_set_comb()                     
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
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr361_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr361'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr361','9031',1)
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
                                 
         CALL cl_cmdat('axrr361',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr361_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr361()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr361_w
END FUNCTION
 
FUNCTION axrr361()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#         l_time    LIKE type_file.chr8           #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          str1      LIKE type_file.chr1000,  
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
	  l_ooaconf LIKE ooa_file.ooaconf,
         #l_order   ARRAY[5] OF VARCHAR(10),
          l_order   ARRAY[5] OF LIKE ooa_file.ooa03,  #No.FUN-680123 VARCHAR(10)
          sr        RECORD
            order1   LIKE ooa_file.ooa03,        #No.FUN-680123 VARCHAR(10)		
	    order2   LIKE ooa_file.ooa03,        #No.FUN-680123 VARCHAR(10)
	    order3   LIKE ooa_file.ooa03,        #No.FUN-680123 VARCHAR(10)
            gen01    LIKE gen_file.gen01,	 #業務員編號
            gen02    LIKE gen_file.gen02,	 #業務員姓名
	    ooa03    LIKE ooa_file.ooa03,	 #客戶
            ooa032   LIKE ooa_file.ooa032,	 #簡稱
	    ooa02    LIKE ooa_file.ooa02,	 #收款日
	    ooa14    LIKE ooa_file.ooa14,	 #人員編號
	    ooa15    LIKE ooa_file.ooa15,	 #部門編號
	    overday  LIKE type_file.num5,        #逾期天數 #No.FUN-680123 SMALLINT
            ooa01    LIKE ooa_file.ooa01,        #帳款編號
	    ooa23    LIKE ooa_file.ooa23,	 #幣別
            oob06    LIKE oob_file.oob06,        #參考單號
            oma01    LIKE oma_file.oma01,        #帳款編號 #CHI-B40013 add
            oma10    LIKE oma_file.oma10,        #發票號碼
            oma32    LIKE oma_file.oma32,        #收款條件
            oma11    LIKE oma_file.oma11,        #應收款日
            oma12    LIKE oma_file.oma12,        #票據到期日
            balance  LIKE oob_file.oob10,        #收款金額
            azi03    LIKE azi_file.azi03,
            azi04    LIKE azi_file.azi04,
            azi05    LIKE azi_file.azi05
                    END RECORD
   DEFINE l_i       LIKE type_file.num5          #No.FUN-8A0065 SMALLINT
   DEFINE l_dbs     LIKE azp_file.azp03          #No.FUN-8A0065
   DEFINE l_azp03   LIKE azp_file.azp03          #No.FUN-8A0065
   DEFINE i         LIKE type_file.num5          #No.FUN-8A0065                
#No.MOD-920015 --begin
   DEFINE l_yy,l_yy1,l_mm,l_mm1,l_dd,l_dd1  LIKE type_file.num5
   DEFINE l_str3    LIKE type_file.chr1000
#No.MOD-920015 --end
 
     #MOD-720047 - START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #MOD-720047 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ooauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ooagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ooagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
     #End:FUN-980030
 
     #no.5196
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt1) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "  GROUP BY curr  "
     PREPARE r361_prepare_1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp1 CURSOR FOR r361_prepare_1
 
     LET l_sql=" SELECT curr,SUM(amt1) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "  GROUP BY curr  "
     PREPARE r361_prepare_2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp2 CURSOR FOR r361_prepare_2
 
     LET l_sql=" SELECT curr,SUM(amt1) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               "  GROUP BY curr  "
     PREPARE r361_prepare_3 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp3 CURSOR FOR r361_prepare_3
     #no.5196(end)

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
   #FUN-8A0065--End--#   
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end

        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin  
#   FOR l_i = 1 to 8                                                          #FUN-8A0065
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
#       LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065     
 
     LET l_sql="SELECT '','','',gen01,gen02,ooa03,ooa032,ooa02,ooa14,",
               "ooa15,0,ooa01,ooa23,oob06,oma01,oma10,oma32,oma11,oma12,",   #CHI-B40013 add oma01
               "oob10,azi03,azi04,azi05 ",
#              " FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file,",l_dbs CLIPPED,"oma_file,",       #FUN-8A0065 Add ",l_dbs CLIPPED,"   
#              " OUTER ",l_dbs CLIPPED,"gen_file, OUTER ",l_dbs CLIPPED,"azi_file ",                         #FUN-8A0065 Add ",l_dbs CLIPPED,"
               " FROM ooa_file LEFT OUTER join gen_file ON ooa14 = gen01 ", 
               " LEFT OUTER join azi_file ON ooa23=azi01,oob_file,oma_file  ",
               " WHERE ooa01 = oob01 AND oob06 = oma01",
#              "   AND ooa_file.ooa14=gen_file.gen01 ",
               "   AND ooaconf !='X' ", #010804 增
               "   AND (ooa02 - oma11)>",tm.n, #97/07/29最少逾期天數
               "   AND ooa37 = '1' ",           #FUN-B20019 add
#              "   AND ooa_file.ooa23=azi_file.azi01 AND  ",tm.wc
               "   AND ",tm.wc 
     CASE WHEN tm.a = '1'   #已確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'Y'"
          WHEN tm.a = '2'   #未確認
             LET l_sql = l_sql CLIPPED," AND ooaconf = 'N'"
          WHEN tm.a = '3'   #全部
	     LET l_sql= l_sql CLIPPED
     END CASE
 
	 LET l_sql= l_sql CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE axrr361_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr361_curs1 CURSOR FOR axrr361_prepare1
 
     LET g_pageno = 0
     FOREACH axrr361_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.overday=sr.ooa02-sr.oma11
 
       #MOD-720047 - START
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       SELECT azi05 into sr.azi05 
         FROM azi_file
        WHERE azi01=sr.ooa23
#No.MOD-920015 --begin
       LET l_yy =YEAR(sr.ooa02)
       LET l_mm =MONTH(sr.ooa02)
       LET l_dd =DAY(sr.ooa02)
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
#      LET str1 = sr.overday USING '##&', ' (',sr.overday/30 USING '#&',') '
       LET str1 = sr.overday USING '##&', ' (',l_str3 USING '#&',') '
#No.MOD-920015 --end
       EXECUTE insert_prep USING 
          sr.gen01,  sr.gen02,  sr.ooa03,   sr.ooa032, sr.ooa02,
       	  sr.ooa14,  sr.ooa15,  sr.overday, sr.ooa01,  sr.ooa23,
          sr.oob06,  sr.oma01,  sr.oma10,   sr.oma32,  sr.oma11,   #CHI-B40013 add sr.oma01
          sr.oma12,  sr.balance,sr.azi03,   sr.azi04,  sr.azi05,
         #str1,      m_dbs[l_i]    #FUN-8B0118 Add m_dbs[l_i]
          str1,      ''
       #------------------------------ CR (3) ------------------------------#
       #MOD-720047 - END
     END FOREACH
#   END FOR                                                                      #FUN-8A0065
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
         
     #MOD-720047 - START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ooa15,ooa14,ooa03,ooa02,ooa01,oob06,ooa23') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
#     IF tm.b = 'Y' THEN                                                                       #FUN-8A0065
#        LET l_name = 'axrr361_1'                                                              #FUN-8A0065
#     ELSE                                                                                     #FUN-8A0065
     	  LET l_name = 'axrr361'                                                              #FUN-8A0065
#     END IF	                                                                              #FUN-8A0065     
#     LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",tm.b  #FUN-8A0065 Add tm.b 
     LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",''
     CALL cl_prt_cs3('axrr361',l_name,l_sql,g_str)   #FUN-710080 modify                       #FUN-8A0065 Add l_name
     #------------------------------ CR (4) ------------------------------#
     #MOD-720047 - END
END FUNCTION

        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#FUN-8A0065--Begin--#
#FUNCTION r361_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r361_set_no_entry_1()
#    IF tm.b = 'N' THEN
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
#FUNCTION r361_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-985' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7,8'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-984' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8A0065--End--#
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
