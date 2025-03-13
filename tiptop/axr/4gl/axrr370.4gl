# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr370.4gl
# Descriptions...: 銷貨日報表
# Date & Author..: 95/10/06 by Nick
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.MOD-540137 05/05/06 By ching fix期間問題
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表        
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期與報表名稱所在的行數顛倒
# Modify.........: No.FUN-830151 08/04/03 By sherry 報表改由CR輸出
# Modify.........: No.FUN-8C0019 08/12/14 By jan 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No.TQC-A70128 10/08/02 By lixia dateadd相關修改
# Modify.........: No.MOD-BA0032 11/10/09 By Dido 發票別變數放大 
# Modify.........: No:FUN-C10042 12/05/28 By jinjj 将tm.a,tm.b,tm.c三个栏位,改成一个QBE"发票别"(oma05),可开窗挑选要列印出的发票别资料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm RECORD
             wc         LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(1000)
            #a,b,c      LIKE type_file.chr1,           #No.FUN-680123 VARCHAR(1) #MOD-BA0032 mark
            #a,b,c      LIKE oma_file.oma05,           #MOD-BA0032  #FUN-C10042 mark
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#             p1         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p2         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p3         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p4         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p5         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p6         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p7         LIKE azp_file.azp01,           #No.FUN-8C0019
#             p8         LIKE azp_file.azp01,           #No.FUN-8C0019
#             d,m,n      LIKE type_file.chr1,           #No.FUN-8C0019
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
             bdate      LIKE type_file.dat,            #No.FUN-680123 DATE
             edate      LIKE type_file.dat,            #No.FUN-680123 DATE
             more       LIKE type_file.chr1            # FUN-580121 Input more condition(Y/N) #No.FUN-680123 VARCHAR(1)
          END RECORD
 
DEFINE   g_i            LIKE type_file.num5            #count/index for any purpose #No.FUN-680123 SMALLINT
#No.FUN-830151---Begin                                                          
DEFINE   g_sql           STRING                                                 
DEFINE   g_str           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-830151---End  
DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0019 ARRAY[10] OF VARCHAR(20)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.a = ARG_VAL(8)                  #No.FUN-580121  #FUN-C10042 mark
  #LET tm.b = ARG_VAL(9)                  #No.FUN-580121  #FUN-C10042 mark
  #LET tm.c = ARG_VAL(10)                 #No.FUN-580121  #FUN-C10042 mark
   LET tm.bdate = ARG_VAL(11)             #No.FUN-580121
   LET tm.edate = ARG_VAL(12)             #No.FUN-580121
   LET g_rep_user = ARG_VAL(13)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(14)           #No.FUN-570264
   LET g_template = ARG_VAL(15)           #No.FUN-570264
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-580121 ---end---
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
   #No.FUN-8C0019---Begin
#   LET tm.d = ARG_VAL(17)                 #No.FUN-8C0019
#   LET tm.m = ARG_VAL(18)                 #No.FUN-8C0019
#   LET tm.n = ARG_VAL(19)                 #No.FUN-8C0019
#   LET tm.p1 = ARG_VAL(20)
#   LET tm.p2 = ARG_VAL(21)
#   LET tm.p3 = ARG_VAL(22)
#   LET tm.p4 = ARG_VAL(23)
#   LET tm.p5 = ARG_VAL(24)
#   LET tm.p6 = ARG_VAL(25)
#   LET tm.p7 = ARG_VAL(26)
#   LET tm.p8 = ARG_VAL(27)
   #No.FUN-8C0019---End 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
    #No.FUN-830151---Begin                                                      
    LET g_sql = "oma01.oma_file.oma01,",
                "oma03.oma_file.oma03,",
                "oma032.oma_file.oma032,",
                "oma10.oma_file.oma10,",
                "oma56.oma_file.oma56,",
                "oma56x.oma_file.oma56x,",
                "oma56t.oma_file.oma56t,",
                "omavoid.oma_file.omavoid,",
                "oma00.oma_file.oma00,",
                "ooo1.type_file.num20_6,",
                "tot1.type_file.num20_6,",
                "tot2.type_file.num20_6,",
                "tot3.type_file.num20_6,",
                "mmm1.type_file.num20_6,",
                "mmm2.type_file.num20_6,",
                "mmm3.type_file.num20_6,",
                "oma53.oma_file.oma53,",
                "oma02.oma_file.oma02,",
                "plant.azp_file.azp01"        #No.FUN-8C0019
 
    LET l_table = cl_prt_temptable('axrr370',g_sql) CLIPPED                     
    IF l_table = -1 THEN EXIT PROGRAM END IF                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"     #FUN-8C0019 add ?    
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                              
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
    END IF                                                                      
    #NO.FUN-830151---End
 
       
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL axrr370_tm(0,0)             # Input print condition
   ELSE
      CALL axrr370()                   # Read data and create out-file
   END IF
   #No.FUN-580121 ---end---
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr370_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 20
 
   OPEN WINDOW axrr370_w AT p_row,p_col WITH FORM "axr/42f/axrr370"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL
   LET tm.bdate= TODAY-1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.more = "N"
   #No.FUN-580121 ---end---
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
   #No.FUN-8C0019---Begin
#   LET tm.m ='N '
#   LET tm.n ='N  '
#   LET tm.d ='N'
#   LET tm.p1=g_plant
#   CALL r370_set_entry_1()               
#   CALL r370_set_no_entry_1()
   #No.FUN-8C0019---End
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
WHILE TRUE
  #FUN-C10042---start---                                                                                                          
   CONSTRUCT BY NAME tm.wc ON oma05                                                                                                 
      BEFORE CONSTRUCT                                                                                                              
         CALL cl_qbe_init()                                                                                                         
                                                                                                                                    
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(oma05)                                                                                                     
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_oma05"                                                                                    
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO oma05                                                                               
                 NEXT FIELD oma05                                                                                                   
            OTHERWISE EXIT CASE                                                                                                     
          END CASE                                                                                                                  
      ON ACTION locale                                                                                                              
         CALL cl_show_fld_cont()                                                                                                    
         LET g_action_choice = "locale"                                                                                             
         EXIT CONSTRUCT                                                                                                             
                                                                                                                                    
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr374_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                                
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF                                                            
  #FUN-C10042---end---

   #INPUT BY NAME tm.a,tm.b,tm.c,tm.bdate,tm.edate,   #FUN-C10042 mark
   INPUT BY NAME tm.bdate,tm.edate,                   #FUN-C10042
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                 tm.d,tm.p1,tm.p2,tm.p3,tm.p4,     #No.FUN-8C0019   
#                 tm.p5,tm.p6,tm.p7,tm.p8,          #No.FUN-8C0019  
#                 tm.m,tm.n,                        #No.FUN-8C0019
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
                 tm.more WITHOUT DEFAULTS  #No.FUN-580121
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         IF cl_null(tm.edate) THEN
            LET tm.edate=tm.bdate
            DISPLAY BY NAME tm.edate
         END IF
 
      AFTER FIELD edate
         IF tm.edate < tm.bdate THEN
            NEXT FIELD bdate
         END IF
         
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
      #No.FUN-8C0019---Begin
#      AFTER FIELD d
#          IF NOT cl_null(tm.d)  THEN
#             IF tm.d NOT MATCHES "[YN]" THEN
#                NEXT FIELD d       
#             END IF
#          END IF
#                    
#       ON CHANGE  d
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL r370_set_entry_1()      
#          CALL r370_set_no_entry_1()     
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
      #No.FUN-8C0019---End      
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
 
      #No.FUN-580121 --start--
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      #No.FUN-580121 ---end---
      
      #No.FUN-8C0019---Begin
      ON ACTION CONTROLP
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#       CASE 
#         WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#         WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#         WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#         WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#         WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#         WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#         WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#         WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#             #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#       END CASE        
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
      #No.FUN-8C0019---End
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axrr370_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr370'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr370','9031',1)
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
                         " '",tm.wc CLIPPED,"'",                #No.FUN-580121
                         #" '",tm.a CLIPPED,"'",                 #No.FUN-580121  #FUN-C10042 mark
                         #" '",tm.b CLIPPED,"'",                 #No.FUN-580121  #FUN-C10042 mark
                         #" '",tm.c CLIPPED,"'",                 #No.FUN-580121  #FUN-C10042 mark
                         " '",tm.bdate,"'",                     #No.FUN-580121
                         " '",tm.edate,"'",                     #No.FUN-580121
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#                         " '",tm.d  CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.m  CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.n  CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p1 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p2 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p3 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p4 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p5 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p6 CLIPPED,"'" ,               #No.FUN-8C0019
#                         " '",tm.p7 CLIPPED,"'"  ,              #No.FUN-8C0019
#                         " '",tm.p8 CLIPPED,"'"                 #No.FUN-8C0019
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
         CALL cl_cmdat('axrr370',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr370_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr370()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr370_w
END FUNCTION
 
FUNCTION axrr370()
   DEFINE
          l_name    LIKE type_file.chr20,             # External(Disk) file name #No.FUN-680123 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(40)
          sr        RECORD
                    oma00     LIKE oma_file.oma00,    #No.FUN-680123 VARCHAR(02)
                    oma02     LIKE oma_file.oma02,    #No.FUN-680123 DATE
#No.FUN540057--begin
                    oma10     LIKE oma_file.oma10,    #No.FUN-680123 VARCHAR(16)
#No.FUN540057--end
                    oma03     LIKE oma_file.oma03,    #No.FUN-680123 VARCHAR(06)
                    oma032    LIKE oma_file.oma032,   #No.FUN-680123 VARCHAR(08)
                    oma01     LIKE oma_file.oma01,    #No.FUN-550071
                    oma53     LIKE oma_file.oma53,    #No.FUN-680123 DEC(20,6)
                    oma56     LIKE oma_file.oma56,    #No.FUN-680123 DEC(20,6)
                    oma56x    LIKE oma_file.oma56x,   #No.FUN-680123 DEC(20,6)
                    oma56t    LIKE oma_file.oma56t,   #No.FUN-680123 DEC(20,6)
                    omavoid   LIKE oma_file.omavoid   #No.FUN-680123 VARCHAR(01)
                    END RECORD
     #No.FUN-830151---Begin
     DEFINE  ooo1,tot1,tot2,tot3,mmm1,mmm2,mmm3 LIKE type_file.num20_6
     DEFINE  l_oma53        LIKE oma_file.oma53
     DEFINE  l_oma56        LIKE oma_file.oma56
     DEFINE  l_oma56x       LIKE oma_file.oma56x
     DEFINE  l_oma56t       LIKE oma_file.oma56t  
     DEFINE  l_oma56_1      LIKE oma_file.oma56
     DEFINE  l_oma56x_1     LIKE oma_file.oma56x
     DEFINE  l_oma56t_1     LIKE oma_file.oma56t
     DEFINE  l_i            LIKE type_file.num5       #No.FUN-8C0019 SMALLINT
     DEFINE  l_dbs          LIKE azp_file.azp03       #No.FUN-8C0019
     DEFINE  l_azp03        LIKE azp_file.azp03       #No.FUN-8C0019
     DEFINE  i              LIKE type_file.num5 
     DEFINE  l_date         LIKE type_file.dat        #No.TQC-A70128
       
     #No.FUN-830151---End
     CALL cl_del_data(l_table)                     #No.FUN-830151
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 ='axrr370'   #No.FUN-830151
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF cl_null(tm.wc) THEN
         LET tm.wc = ' 1=1'
     END IF
 
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
   
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
     #No.FUN-8C0019---Begin
#     FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#     LET m_dbs[1]=tm.p1
#     LET m_dbs[2]=tm.p2
#     LET m_dbs[3]=tm.p3
#     LET m_dbs[4]=tm.p4
#     LET m_dbs[5]=tm.p5
#     LET m_dbs[6]=tm.p6
#     LET m_dbs[7]=tm.p7
#     LET m_dbs[8]=tm.p8
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end

        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin      
#      FOR l_i = 1 to 8                                                                                                                 
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#       LET l_azp03 = l_dbs CLIPPED 
#       LET l_dbs = s_dbstring(l_dbs CLIPPED) 
     #No.FUn-8C0019---End 
 
     LET l_sql =" SELECT oma00,oma02,oma10,oma03,oma032,oma01,",
                "        oma53,oma56,oma56x,oma56t,omavoid",
#               "   FROM oma_file ",                            #FUN-8C0019
#               "   FROM ",l_dbs CLIPPED,"oma_file ",           #FUN-8C0019
                "   FROM oma_file ", 
                "  WHERE oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                #"    AND (oma05 = '",tm.a,"' OR oma05 = '",tm.b,"'",        #FUN-C10042 mark
                #"     OR oma05 = '", tm.c,"')",                             #FUN-C10042 mark
                 "    AND oma00 NOT IN ('23','24') ",  #MOD-540137
                "    AND ",tm.wc CLIPPED
 
     display  l_sql
     PREPARE axrr370_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
            
     END IF
     DECLARE axrr370_curs1 CURSOR FOR axrr370_prepare1
 
{
     DECLARE axrr370_curs1 CURSOR FOR
                SELECT oma00,oma02,oma10,oma03,oma032,oma01,
                       oma53,oma56,oma56x,oma56t,omavoid
                  FROM oma_file
                 WHERE oma02 BETWEEN tm.bdate AND tm.edate
                   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)   
                   AND oma00 NOT IN ('23','24')                    
 
}
     #No.FUN-830151---Begin
     #CALL cl_outnam('axrr370') RETURNING l_name
     #START REPORT axrr370_rep TO l_name
 
     #LET g_pageno = 0
     #No.FUN-830151---End
     LET l_date = tm.bdate - 1     #TQC-A70128
     FOREACH axrr370_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.omavoid = 'Y' THEN
          LET sr.oma53  = 0
          LET sr.oma56  = 0
          LET sr.oma56x = 0
          LET sr.oma56t = 0
       END IF
       IF sr.oma00 MATCHES '2*' THEN
          LET sr.oma53  = sr.oma53  * -1
          LET sr.oma56  = sr.oma56  * -1
          LET sr.oma56x = sr.oma56x * -1
          LET sr.oma56t = sr.oma56t * -1
       END IF
       #No.FUN-830151---Begin
       #OUTPUT TO REPORT axrr370_rep(sr.*)
       #No.FUN-8C0019---Begin
       #SELECT SUM(oma53) INTO ooo1
       #  FROM oma_file
       # WHERE oma02 = tm.bdate-1 #MOD-540137
       #   AND oma00 = '12'
       #   AND omavoid='N'
       #   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
       
       LET l_sql = "SELECT SUM(oma53) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oma_file",                                                                          
                      "  FROM oma_file",  
                      #" WHERE oma02=dateadd(day,-1,'",tm.bdate,"')",#TQC-A70128
                      " WHERE oma02=",l_date,                        #TQC-A70128 
                      "   AND oma00='12' AND omavoid='N'",
                      #"   AND (oma05='",tm.a,"' OR oma05='",tm.b,"' OR oma05='",tm.c,"') "   #FUN-C10042 mark 
                      "    AND ",tm.wc CLIPPED                                                 #FUN-C10042 add                                                                                                                                                                               
          PREPARE oma_prepare3 FROM l_sql                                                                                          
          DECLARE oma_c3  CURSOR FOR oma_prepare3                                                                                 
          OPEN oma_c3                                                                                    
          FETCH oma_c3 INTO ooo1
          
       IF ooo1 IS NULL THEN LET ooo1=0 END IF
       
       #SELECT SUM(oma56),sum(oma56x),sum(oma56t) INTO tot1,tot2,tot3
       #  FROM oma_file
       # WHERE oma02 = tm.bdate-1 #MOD-540137
       #   AND oma00 IN ('11','12','13','31')
       #   AND omavoid='N'
       #   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
       
       LET l_sql = "SELECT SUM(oma56),SUM(oma56x),SUM(oma56t) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oma_file",                                                                          
                      "  FROM oma_file", 
                      #" WHERE oma02=dateadd(day,-1,'",tm.bdate,"')",#TQC-A70128 
                      " WHERE oma02=",l_date,                        #TQC-A70128 
                      "   AND oma00 IN('11','12','13','31') AND omavoid='N'",
                      #"   AND (oma05='",tm.a,"' OR oma05='",tm.b,"' OR oma05='",tm.c,"') "   #FUN-C10042 mark        
                      "    AND ",tm.wc CLIPPED                                                 #FUN-C10042 add                                                                                                                                                                        
          PREPARE oma_prepare4 FROM l_sql                                                                                          
          DECLARE oma_c4  CURSOR FOR oma_prepare4                                                                                 
          OPEN oma_c4                                                                                    
          FETCH oma_c4 INTO tot1,tot2,tot3
           
          IF tot1 IS NULL THEN LET tot1=0 END IF
          IF tot2 IS NULL THEN LET tot2=0 END IF
          IF tot3 IS NULL THEN LET tot3=0 END IF
          
       #SELECT SUM(oma56),sum(oma56x),sum(oma56t) INTO mmm1,mmm2,mmm3
       #  FROM oma_file
       # WHERE oma02 = tm.bdate-1 #MOD-540137
       #   AND oma00 MATCHES "2*"
       #   AND omavoid='N'
       #   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
       
       LET l_sql = "SELECT SUM(oma56),SUM(oma56x),SUM(oma56t) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oma_file",                                                                          
                      "  FROM oma_file",
                      #" WHERE oma02=dateadd(day,-1,'",tm.bdate,"')",#TQC-A70128
                      " WHERE oma02=",l_date,                        #TQC-A70128
                      "   AND oma00 MATCHES '","2*","' AND omavoid='N'",
                      #"   AND (oma05='",tm.a,"' OR oma05='",tm.b,"' OR oma05='",tm.c,"') "   #FUN-C10042 mark         
                      "    AND ",tm.wc CLIPPED                                                 #FUN-C10042 add                                                                                                                                                                       
          PREPARE oma_prepare5 FROM l_sql                                                                                          
          DECLARE oma_c5  CURSOR FOR oma_prepare5                                                                                 
          OPEN oma_c5                                                                                    
          FETCH oma_c5 INTO mmm1,mmm2,mmm3
       #No.FUN-8C0019---End
 
       IF mmm1 IS NULL THEN LET mmm1=0 END IF
       IF mmm2 IS NULL THEN LET mmm2=0 END IF
       IF mmm3 IS NULL THEN LET mmm3=0 END IF
       LET mmm1=mmm1*-1 LET mmm2=mmm2*-1 LET mmm3=mmm3*-1
       EXECUTE insert_prep USING sr.oma01,sr.oma03,sr.oma032,sr.oma10,sr.oma56,
                                 sr.oma56x,sr.oma56t,sr.omavoid,sr.oma00,
                                 ooo1,tot1,tot2,tot3,mmm1,mmm2,mmm3, 
#                                sr.oma53,sr.oma02,m_dbs[l_i]     #No.FUN-8C0019   
                                 sr.oma53,sr.oma02,''  
       #No.FUN-830151---End
     END FOREACH
#  END FOR                                #FUN-8C0019

     #No.FUN-830151---Begin
     #FINISH REPORT axrr370_rep
     #FUN-8C0019--BEGIN--
#    IF tm.d = 'Y' THEN                                     
#       LET l_name = 'axrr370_1'                            
#    ELSE                                                   
   	    LET l_name = 'axrr370'                              
#    END IF
     #No.FUN-8C0019---End
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #LET g_str = g_azi04,";",g_azi05,";",tm.a,";",tm.b,";",tm.c,";",   #FUN-C10042 mark
     LET g_str = g_azi04,";",g_azi05,";",tm.wc,";",'',";",'',";",       #FUN-C10042
#                tm.bdate,";",tm.edate,";",tm.m,";",tm.n    #FUN-8C0019                                               
                 tm.bdate,";",tm.edate,";",'',";",''
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
     CALL cl_prt_cs3('axrr370',l_name,l_sql,g_str)                            
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
     #No.FUN-830151---End 
END FUNCTION
 
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#FUN-8C0019---Begin
#FUNCTION r370_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8,m,n",TRUE)
#END FUNCTION
# 
#FUNCTION r370_set_no_entry_1()
#    IF tm.d = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8,m,n",FALSE)
#       LET tm.m = 'N'
#       LET tm.n = 'N'
#       DISPLAY BY NAME tm.m,tm.n
#    END IF
#END FUNCTION
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
#FUN-8C0019---End
 
#No.FUN-830151---Begin
#REPORT axrr370_rep(sr)
#  DEFINE 
#  	  l_last_sw      LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)
#         g_head1        STRING,
#         ooo1,tot1,tot2,tot3,mmm1,mmm2,mmm3 LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6)
#         l_oma53        LIKE oma_file.oma53,         #No.FUN-680123 DEC(20,6)
#         l_oma56        LIKE oma_file.oma56,         #No.FUN-680123 DEC(20,6)
#         l_oma56x       LIKE oma_file.oma56x,        #No.FUN-680123 DEC(20,6)
#         l_oma56t       LIKE oma_file.oma56t,        #No.FUN-680123 DEC(20,6)
#         l_tot1,l_tot2  LIKE type_file.chr1000,      #No.FUN-680123 DEC(20,6)
#         sr        RECORD
#                   oma00     LIKE oma_file.oma00,    #No.FUN-680123 VARCHAR(02)
#                   oma02     LIKE oma_file.oma02,    #No.FUN-680123 DATE
##No.FUN540057--begin
#                   oma10     LIKE oma_file.oma10,    #No.FUN-680123 VARCHAR(16)
##No.FUN540057--end
#                   oma03     LIKE oma_file.oma03,    #No.FUN-680123 VARCHAR(06)
#                   oma032    LIKE oma_file.oma032,   #No.FUN-680123 VARCHAR(08)
#                   oma01     LIKE oma_file.oma01,    #No.FUN-550071 
#                   oma53     LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6)
#                   oma56     LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6)
#                   oma56x    LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6)
#                   oma56t    LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6)
#                   omavoid   LIKE oma_file.omavoid   #No.FUN-680123 VARCHAR(01)
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.oma00, sr.oma02, sr.oma10
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6B0051
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
##     PRINT g_head CLIPPED, pageno_total  #No.TQC-770028 mark
#     PRINT                               #No.TQC-770028
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6B0051
#     LET g_head1 = g_x[11] CLIPPED,' ',tm.a,' ',tm.b,' ',tm.c
#     PRINT g_head1;
#     LET g_head1 = g_x[12] CLIPPED,' ',tm.bdate,'-',tm.edate
#     PRINT g_head1
#     PRINT g_head CLIPPED, pageno_total  #No.TQC-770028
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#    PRINT COLUMN g_c[31],sr.oma01,
#          COLUMN g_c[32],sr.oma03,
#          COLUMN g_c[33],sr.oma032,
#          COLUMN g_c[34],sr.oma10,
#          COLUMN g_c[35],cl_numfor(sr.oma56,35,g_azi04),
#          COLUMN g_c[36],cl_numfor(sr.oma56x,36,g_azi04),
#          COLUMN g_c[37],cl_numfor(sr.oma56t,37,g_azi04);
#
#     CASE WHEN sr.omavoid ='Y' PRINT COLUMN g_c[38],g_x[22] CLIPPED
#          WHEN sr.oma00 MATCHES '2*'  PRINT COLUMN g_c[38],g_x[23] CLIPPED
#          OTHERWISE            PRINT
#     END CASE
 
#  ON LAST ROW
#     PRINT
#     SELECT SUM(oma53) INTO ooo1
#             FROM oma_file
#           #WHERE YEAR(oma02)=YEAR(sr.oma02)
#             #AND MONTH(oma02)=MONTH(sr.oma02)
#             #AND oma02 < sr.oma02
#             WHERE oma02 = tm.bdate-1 #MOD-540137
#              AND oma00 = '12'
#              AND omavoid='N'
#              AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
#     IF ooo1 IS NULL THEN LET ooo1=0 END IF
#     SELECT SUM(oma56),sum(oma56x),sum(oma56t) INTO tot1,tot2,tot3
#             FROM oma_file
#           #WHERE YEAR(oma02)=YEAR(sr.oma02)
#             #AND MONTH(oma02)=MONTH(sr.oma02)
#             #AND oma02 < sr.oma02
#             WHERE oma02 = tm.bdate-1 #MOD-540137
#              AND oma00 IN ('11','12','13','31')
#              AND omavoid='N'
#              AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
#     IF tot1 IS NULL THEN LET tot1=0 END IF
#     IF tot2 IS NULL THEN LET tot2=0 END IF
#     IF tot3 IS NULL THEN LET tot3=0 END IF
#     SELECT SUM(oma56),sum(oma56x),sum(oma56t) INTO mmm1,mmm2,mmm3
#             FROM oma_file
#           #WHERE YEAR(oma02)=YEAR(sr.oma02)
#             #AND MONTH(oma02)=MONTH(sr.oma02)
#             #AND oma02 < sr.oma02
#             WHERE oma02 = tm.bdate-1 #MOD-540137
#              AND oma00 MATCHES "2*"
#              AND omavoid='N'
#              AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
#     IF mmm1 IS NULL THEN LET mmm1=0 END IF
#     IF mmm2 IS NULL THEN LET mmm2=0 END IF
#     IF mmm3 IS NULL THEN LET mmm3=0 END IF
#     LET mmm1=mmm1*-1 LET mmm2=mmm2*-1 LET mmm3=mmm3*-1
#PRINT COLUMN g_c[33],g_x[13] CLIPPED,
#      COLUMN g_c[35],cl_numfor(ooo1,35,g_azi05),
#      COLUMN g_c[37],cl_numfor(ooo1,37,g_azi05)
#PRINT COLUMN g_c[33],g_x[14] CLIPPED,
#      COLUMN g_c[35],cl_numfor(tot1,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(tot2,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(tot3,37,g_azi05)
#PRINT COLUMN g_c[33],g_x[25] CLIPPED,
#      COLUMN g_c[35],cl_numfor(mmm1,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(mmm2,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(mmm3,37,g_azi05)
#LET tot1=ooo1+tot1+mmm1 LET tot2=tot2+mmm2 LET tot3=ooo1+tot3+mmm3
#PRINT COLUMN g_c[33],g_x[22] CLIPPED,
#      COLUMN g_c[35],cl_numfor(tot1,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(tot2,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(tot3,37,g_azi05)
#PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#      COLUMN g_c[36],g_dash2[1,g_w[36]],
#      COLUMN g_c[37],g_dash2[1,g_w[37]]
 
# LET l_oma53 = SUM(sr.oma53)  WHERE sr.oma00[1,1]!='2'  #MOD-540137
# LET l_oma56 = SUM(sr.oma56)  WHERE sr.oma00[1,1]!='2'  #MOD-540137
# LET l_oma56x= SUM(sr.oma56x) WHERE sr.oma00[1,1]!='2'  #MOD-540137
# LET l_oma56t= SUM(sr.oma56t) WHERE sr.oma00[1,1]!='2'  #MOD-540137
#IF l_oma53 IS NULL THEN LET l_oma53 = 0 END IF
#IF l_oma56 IS NULL THEN LET l_oma56 = 0 END IF
#IF l_oma56x IS NULL THEN LET l_oma56x = 0 END IF
#IF l_oma56t IS NULL THEN LET l_oma56t = 0 END IF
#PRINT COLUMN g_c[33],g_x[17] CLIPPED,
#      COLUMN g_c[35],cl_numfor(l_oma53,35,g_azi05),
#      COLUMN g_c[37],cl_numfor(l_oma53,37,g_azi05)
#PRINT COLUMN g_c[33],g_x[18] CLIPPED,
#      COLUMN g_c[35],cl_numfor(l_oma56,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(l_oma56x,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(l_oma56t,37,g_azi05)
 
#LET l_oma56 = 0
#LET l_oma56x= 0
#LET l_oma56t= 0
# LET l_oma56 = SUM(sr.oma56)  WHERE sr.oma00[1,1]='2'  #MOD-540137
# LET l_oma56x= SUM(sr.oma56x) WHERE sr.oma00[1,1]='2'  #MOD-540137
# LET l_oma56t= SUM(sr.oma56t) WHERE sr.oma00[1,1]='2'  #MOD-540137
#IF l_oma56 IS NULL THEN LET l_oma56 = 0 END IF
#IF l_oma56x IS NULL THEN LET l_oma56x = 0 END IF
#IF l_oma56t IS NULL THEN LET l_oma56t = 0 END IF
#PRINT COLUMN g_c[33],g_x[19] CLIPPED,
#      COLUMN g_c[35],cl_numfor(l_oma56,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(l_oma56x,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(l_oma56t,37,g_azi05)
 
# LET l_oma53 = SUM(sr.oma53)   #MOD-540137
# LET l_oma56 = SUM(sr.oma56)   #MOD-540137
# LET l_oma56x= SUM(sr.oma56x)  #MOD-540137
# LET l_oma56t= SUM(sr.oma56t)  #MOD-540137
#IF l_oma53 IS NULL THEN LET l_oma53 = 0 END IF
#IF l_oma56 IS NULL THEN LET l_oma56 = 0 END IF
#IF l_oma56x IS NULL THEN LET l_oma56x = 0 END IF
#IF l_oma56t IS NULL THEN LET l_oma56t = 0 END IF
 
#LET l_tot1 = l_oma53 + l_oma56
#LET l_tot2 = l_oma53 + l_oma56t
#PRINT COLUMN g_c[33],g_x[20] CLIPPED,
#      COLUMN g_c[35],cl_numfor(l_tot1,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(l_oma56x,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(l_tot2,37,g_azi05)
#PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#      COLUMN g_c[36],g_dash2[1,g_w[36]],
#      COLUMN g_c[37],g_dash2[1,g_w[37]]
#PRINT COLUMN g_c[33],g_x[21] CLIPPED,
#      COLUMN g_c[35],cl_numfor(l_tot1+tot1,35,g_azi05),
#      COLUMN g_c[36],cl_numfor(l_oma56x+tot2,36,g_azi05),
#      COLUMN g_c[37],cl_numfor(l_tot2+tot3,37,g_azi05)
#      LET l_last_sw ='y'  #No.TQC-6B0051 
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     #No.TQC-6B0051  --begin
#     IF l_last_sw = 'y' THEN
#        PRINT g_x[24] CLIPPED, COLUMN g_len-9,g_x[9] CLIPPED
#     ELSE
#        PRINT g_x[24] CLIPPED, COLUMN g_len-9,g_x[8] CLIPPED
#     END IF
#     #No.TQC-6B0051  --end
 
#        
#END REPORT
#No.FUN-830151---End
