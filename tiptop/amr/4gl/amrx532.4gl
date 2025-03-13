# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: amrx532.4gl
# Descriptions...: MRP交期延后建議表
# Input parameter: 
# Return code....: 
# Date & Author..: 05/08/29 By Hay
# Modify.........: No.FUN-570081 05/08/30 By Tracy 6X轉GP版本
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-670040 06/07/13 By Pengu 允許可延遲量應該考慮交期調整的數量
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.MOD-710188 07/02/08 By pengu 系統目前限制只允P part做交期延後這樣不合理應於程式畫面輸入條件過濾(來源碼)
# Modify.........: No.FUN-750097 07/06/26 By cheunl 現有報表轉為CR報表
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-8A0030 09/02/10 By Pengu 列印出來的來源單據+項次和料號不合
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/04/09 By JCC  修改表mss_file的操作 
# Modify.........: No:MOD-A50170 10/05/25 By Sarah 交期延遲起始天數(tm.yc)不論設定多少對報表產出都沒有影響
# Modify.........: No:MOD-A80087 10/08/11 By Pengu 調整交期延遲建議規則
# Modify.........: No.FUN-CB0003 12/11/02 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By chenying XtraGrid报表修改
# Modify.........: No.FUN-D30053 13/03/18 By yangtt mark grup_field后跳頁失效需還原
# Modify.........: No.FUN-D40128 13/05/08 By wangrr "來源碼"增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"         
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition #NO.FUN-680082 VARCHAR(600)        
             #n       VARCHAR(1),        #TQC-610074      
              ver_no  LIKE mss_file.mss_v,        #NO.FUN-680082 VARCHAR(10)        
              yc      LIKE type_file.num5,        #NO.FUN-680082 SMALLINT
              per     LIKE type_file.num5,        #NO.FUN-680082 SMALLINT
              s       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3) 
              t       LIKE type_file.chr3,        #NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1         # Input more condition(Y/N)   #NO.FUN-680082 VARCHAR(1)        
              END RECORD
   DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #NO.FUN-680082 SMALLINT 
DEFINE l_table        STRING                 #No.FUN-750097                                                                         
DEFINE g_str          STRING                 #No.FUN-750097                                                                         
DEFINE g_sql          STRING                 #No.FUN-75009
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function
   
 
   IF (NOT cl_user()) THEN                                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
                                                                                                                                    
   WHENEVER ERROR CALL cl_err_msg_log                                                                                               
                                                                                                                                    
   IF (NOT cl_setup("AMR")) THEN                                                                                                    
      EXIT PROGRAM                                                                                                                  
   END IF                                     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
#No.FUN-750097 -----------start-----------------                                                                                    
    LET g_sql = " ima02.ima_file.ima02,",
                " ima25.ima_file.ima25,",
                " mss00.mss_file.mss00,",
                " mss01.mss_file.mss01,",
                " mss03.mss_file.mss03,",
                " mss061.mss_file.mss061,",
                " mss11.mss_file.mss11,",
                " mst06.mst_file.mst06,",
                " mst061.mst_file.mst061,",
                " mst07.mst_file.mst07,",
                " mst08.mst_file.mst08, ", 
            #FUN-CB0003--add--start--
                "ima021.ima_file.ima021,",
                "pmc03.pmc_file.pmc03,",
                " cancel.type_file.num5,",
                " ima08.ima_file.ima08,",
                " ima67.ima_file.ima67,",
                " ima43.ima_file.ima43,",
                " mss02.mss_file.mss02"
            #FUN-CB0003--add--end---
    LET l_table = cl_prt_temptable('amrx532',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?,",                                                                          
                "        ?, ?, ?, ?, ? , ?,?,?,?,?,?,?)"           #FUN-CB0003 add 7?                                                                                 
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-750097---------------end------------
 
   LET g_trace    = 'N'               # default trace off
   LET g_pdate    = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.ver_no  = ARG_VAL(8)
   LET tm.yc      = ARG_VAL(9)
   LET tm.per     = ARG_VAL(10)
   LET tm.s       = ARG_VAL(11)
   LET tm.t       = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrx532_tm(0,0)              # Input print condition
      ELSE CALL amrx532()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx532_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680082 SMALLINT 
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrx532_w AT p_row,p_col
        WITH FORM "amr/42f/amrx532" 
   ATTRIBUTE (STYLE = g_win_style)                                                                                               
   CALL cl_ui_init()         
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.n    = '1'                 #TQC-610074
   LET tm.s     = '123'
   LET tm.more  = 'N'
   LET tm.yc    = 0      
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]                                                                                                         
   LET tm2.s2   = tm.s[2,2]                                                                                                         
   LET tm2.s3   = tm.s[3,3]                                                                                                         
   LET tm2.t1   = tm.t[1,1]                                                                                                         
   LET tm2.t2   = tm.t[2,2]                                                                                                         
   LET tm2.t3   = tm.t[3,3]                                                                                                         
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF                                                                                  
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF                                                                                  
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF             
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF                                                                                  
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF                                                                                  
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF       
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima08,ima67,ima43,mss02,mss03 HELP 1
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
        IF INFIELD(mss01) THEN                                                                                                  
           CALL cl_init_qry_var()                                                                                               
           LET g_qryparam.form = "q_ima"                                                                                       
           LET g_qryparam.state = "c"                                                                                           
           CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
           DISPLAY g_qryparam.multiret TO mss01                                                                                 
           NEXT FIELD mss01                                                                                                     
        END IF  
#FUN-CB0003--add--str--
        IF INFIELD(ima67) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima67"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima67
           NEXT FIELD ima67
        END IF
        IF INFIELD(mss02) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_pmc2"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO mss02
           NEXT FIELD mss02
        END IF
        #FUN-D40128--add--str--
        IF INFIELD(ima08) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima7"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima08
           NEXT FIELD ima08
        END IF
        #FUN-D40128--add--end
        IF INFIELD(ima43) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima43"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima43
           NEXT FIELD ima43
        END IF
#FUN-CB0003--add--end--
     ON ACTION locale                                                                                                               
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT                                                                                                                       
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN                                                                                           
      LET g_action_choice = ""                                                                                                  
      CALL cl_dynamic_locale()                                                                                                  
      CONTINUE WHILE                                                                                                            
   END IF                         
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrx532_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME   tm.ver_no,tm.yc,tm.per,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS  
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR                                                                                                               
         CALL cl_show_req_fields()        
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution      
 
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW amrx532_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx532'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx532','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.yc CLIPPED,"'",
                         " '",tm.per CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",  
                         " '",g_rep_clas CLIPPED,"'", 
                         " '",g_template CLIPPED,"'"    
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('amrx532',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx532_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx532()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx532_w
END FUNCTION
 
FUNCTION amrx532()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name     #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     STRING,                       # RDSQL STATEMENT             
          l_chr     LIKE type_file.chr1,          #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #NO.FUN-680082 VARCHAR(40) 
          l_order ARRAY[3] OF LIKE mss_file.mss01 , #FUN-5B0105 20->40 #NO.FUN-680082 VARCHAR(40)
          sr    RECORD
                l_order1 LIKE mss_file.mss01,   #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
                l_order2 LIKE mss_file.mss01,   #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
                l_order3 LIKE mss_file.mss01    #FUN-5B0105 20->40     #NO.FUN-680082 VARCHAR(40)
          END RECORD,
          mss	RECORD 
                   mss_v    LIKE mss_file.mss_v,
                   mss00    LIKE mss_file.mss00,
                   mss01    LIKE mss_file.mss01,
                   mss02    LIKE mss_file.mss02,
                   mss03    LIKE mss_file.mss03,
                   mss041   LIKE mss_file.mss041,
                   mss043   LIKE mss_file.mss043,
                   mss044   LIKE mss_file.mss044,
                   mss051   LIKE mss_file.mss051,
                   mss052   LIKE mss_file.mss052,
                   mss053   LIKE mss_file.mss053,
                   mss061   LIKE mss_file.mss061,
                   mss062   LIKE mss_file.mss062,
                   mss063   LIKE mss_file.mss063,
                   mss064   LIKE mss_file.mss064,
                   mss065   LIKE mss_file.mss065,
                   mss06_fz LIKE mss_file.mss06_fz,
                   mss071   LIKE mss_file.mss071,
                   mss072   LIKE mss_file.mss072,
                   mss08    LIKE mss_file.mss08,
                   mss09    LIKE mss_file.mss09,
                   mss10    LIKE mss_file.mss10,
                   mss11    LIKE mss_file.mss11,
                   mss12    LIKE mss_file.mss12,
                   mssplant LIKE mss_file.mssplant,#FUN-A40023
                   msslegal LIKE mss_file.msslegal,#FUN-A40023
                   mss13    LIKE mss_file.mss13,    #FUN-CB0003
                   s0       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)                  
                   s1       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #多余的供給量
                   s2       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #供給調整后的增加量
                   s3       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #調整后的減少量
                   s_date   LIKE type_file.dat     #NO.FUN-680082 DATE
            END RECORD,
          ima	RECORD LIKE ima_file.*,
          mst	RECORD LIKE mst_file.*,
          sss   ARRAY[400] OF RECORD 
                   mss_v    LIKE mss_file.mss_v,
                   mss00    LIKE mss_file.mss00,
                   mss01    LIKE mss_file.mss01,
                   mss02    LIKE mss_file.mss02,
                   mss03    LIKE mss_file.mss03,
                   mss041   LIKE mss_file.mss041,
                   mss043   LIKE mss_file.mss043,
                   mss044   LIKE mss_file.mss044,
                   mss051   LIKE mss_file.mss051,
                   mss052   LIKE mss_file.mss052,
                   mss053   LIKE mss_file.mss053,
                   mss061   LIKE mss_file.mss061,
                   mss062   LIKE mss_file.mss062,
                   mss063   LIKE mss_file.mss063,
                   mss064   LIKE mss_file.mss064,
                   mss065   LIKE mss_file.mss065,
                   mss06_fz LIKE mss_file.mss06_fz,
                   mss071   LIKE mss_file.mss071,
                   mss072   LIKE mss_file.mss072,
                   mss08    LIKE mss_file.mss08,
                   mss09    LIKE mss_file.mss09,
                   mss10    LIKE mss_file.mss10,
                   mss11    LIKE mss_file.mss11,
                   mss12    LIKE mss_file.mss12,
                   mssplant LIKE mss_file.mssplant,#FUN-A40023
                   msslegal LIKE mss_file.msslegal,#FUN-A40023
                   mss13    LIKE mss_file.mss13,    #FUN-CB0003
                   s0       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)
                   s1       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #多余的供給量
                   s2       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #供給調整后的增加量
                   s3       LIKE mss_file.mss061,  #NO.FUN-680082 DEC(12,3)  #調整后的減少量
                   s_date   LIKE type_file.dat     #NO.FUN-680082 DATE     
            END RECORD,
          j   LIKE type_file.num10,         #NO.FUN-680082 INTEGER 
          i   LIKE type_file.num10,         #NO.FUN-680082 INTEGER
          l   LIKE type_file.num10,         #NO.FUN-680082 INTEGER
          n   LIKE type_file.num10,         #NO.FUN-680082 INTEGER
          l_mst08  LIKE mst_file.mst08,
          l_leave  LIKE mst_file.mst08,
          last_qty LIKE mst_file.mst08,
          l_flag   LIKE type_file.num10,     #NO.FUN-680082 INTEGER
          mss01_t  LIKE mss_file.mss01,      #NO.FUN-680082 VARCHAR(20)
          l_qty2   LIKE mss_file.mss061      #NO.FUN-680082 DECIMAL(12,3) 
   DEFINE l_cancel LIKE type_file.num5       #NO.FUN-CB0003        
   DEFINE l_pmc03  LIKE pmc_file.pmc03       #NO.FUN-CB0003

     LET mss01_t='  '
#No.FUN-750097-----------------start--------------                                                                                  
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#No.FUN-750097-----------------end----------------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT mss_file.*,0,0,0,0,'',ima_file.*",
                 "  FROM mss_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                #-----------#No.MOD-710188
                #"   AND mss01=ima01 AND ima08='P'", 
                 "   AND mss01=ima01 ", 
                #-----------#No.MOD-710188
                 "   AND mss_v='",tm.ver_no CLIPPED,"' ORDER BY mss01,mss03"
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE amrx532_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx532_curs1 CURSOR FOR amrx532_prepare1
 
#    CALL cl_outnam('amrx532') RETURNING l_name        #No.FUN-750097
#    START REPORT amrx532_rep TO l_name                #No.FUN-750097
     LET g_pageno = 0
     FOREACH amrx532_curs1 INTO mss.*,ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_cancel = 0
       IF mss.mss01<>mss01_t THEN
           #MOD-A80087---modify---start---
       	   #FOR l=1 TO 400              #尋找可延遲的采購單
       	   #     IF sss[l].mss01 IS NULL THEN EXIT FOR END IF
	   #     IF sss[l].s1 > 0 THEN  #如果有可延遲的采購單
           #LET l_leave=sss[l].mss061+sss[l].mss062+sss[l].mss063-sss[l].s0
           #declare sss_cs2 CURSOR FOR
           #  select * from mst_file where mst01=sss[l].mss01
           #   AND mst02=sss[l].mss02 AND mst03=sss[l].mss03 
           #   AND mst_v=sss[l].mss_v AND (mst05='61' OR mst05='62' OR mst05='63') ORDER BY mst08 ,mst06,mst061
           #FOREACH sss_cs2 INTO mst.*
           #   IF l_leave<=0 THEN 
           #     #No.FUN-750097-------start-----------------
           #     #OUTPUT TO REPORT amrx532_rep(sr.*,sss[l].*,ima.*,mst.*)  
           #      IF (mss.s_date-mss.mss03>tm.yc) OR cl_null(mss.s_date) THEN
           #         EXECUTE insert_prep USING
           #            #---------------No.MOD-8A0030 modify
           #            #ima.ima02,ima.ima25,mss.mss00,mss.mss01,mss.mss03,
           #            #mss.s1,mss.s_date,mst.mst06,mst.mst061,
           #            #mst.mst07,mst.mst08
           #             ima.ima02,ima.ima25,sss[l].mss00,sss[l].mss01,
           #             sss[l].mss03,sss[l].s1,sss[l].s_date,
           #             mst.mst06,mst.mst061,
           #             mst.mst07,mst.mst08
           #            #---------------No.MOD-8A0030 end
           #      END IF
           #     #No.FUN-750097-------end-----------------
           #   END IF 
           #   LET l_leave=l_leave-mst.mst08
           #END FOREACH
           #    END IF      	    
           #END FOR
            FOR l=1 TO 400 
       	        IF sss[l].mss01 IS NULL THEN EXIT FOR END IF
                IF sss[l].s0 > 0 THEN
                  LET l_leave=sss[l].s0
                  DECLARE sss_cs2 CURSOR FOR
                    SELECT * from mst_file where mst01=sss[l].mss01
                     AND mst02=sss[l].mss02 AND mst03=sss[l].mss03 
                     AND mst_v=sss[l].mss_v AND (mst05='61' OR mst05='62' OR mst05='63') ORDER BY mst08 ,mst06,mst061
                  FOREACH sss_cs2 INTO mst.*
                     LET l_leave = l_leave - mst.mst08
                     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = mst.mst07  #FUN-CB0003
                     IF l_leave >= 0 THEN
                        FOR i = l+1 TO 400
                           IF (sss[i].mss03-sss[l].mss03>tm.yc) AND (tm.yc != 0) THEN  
                              EXIT FOR
                           END IF
                           IF sss[i].s0 + sss[i].s1 + sss[i].s2 < 0 THEN
                              LET sss[i].s1 = sss[i].s1 + mst.mst08
                              EXECUTE insert_prep USING 
                                 ima.ima02,ima.ima25,sss[l].mss00,sss[l].mss01,
                                 sss[l].mss03,sss[l].s0,sss[i].mss03,
                                 mst.mst06,mst.mst061,
                                 mst.mst07,mst.mst08
                                ,ima.ima021,l_pmc03,l_cancel,ima.ima08,ima.ima67,ima.ima43,sss[l].mss02    #FUN-CB0003 add 
                              EXIT FOR
                           END IF
                        END FOR
                     ELSE 
                        EXIT FOREACH
                     END IF 
                  END FOREACH
                END IF
            END FOR
           #MOD-A80087---modify---end---
            FOR l = 1 TO 400 
              INITIALIZE sss[l].* TO NULL
              LET sss[l].s0=0  
              LET sss[l].s1=0  
              LET sss[l].s2=0  
              LET sss[l].s3=0  
            END FOR
            LET i=0 
            LET l=0      	
            LET n=0      	
       	    LET mss01_t=mss.mss01 
       END IF 
       LET i=i+1
       LET sss[i].*=mss.*
       #計算可延遲交貨的數量
      #MOD-A80087---modify---start---
      #IF i=1 THEN
      #   LET last_qty=0
      #ELSE
      # #--------No.MOD-670040 modify
      #  #LET last_qty=sss[i-1].mss08-sss[i-1].mss09
      #   LET last_qty=sss[i-1].mss08+sss[i-1].mss09
      # #--------No.MOD-670040 end
      #END IF 
      # IF sss[i].mss041 IS NULL                                          
      #    THEN LET sss[i].s0=last_qty-tm.per                                   
      #    ELSE LET sss[i].s0=last_qty-tm.per                                   
      #            +sss[i].mss051+sss[i].mss052+sss[i].mss053 
      #            +sss[i].mss061+sss[i].mss062+sss[i].mss063 
      #            +sss[i].mss064+sss[i].mss065-sss[i].mss06_fz                     
      #            -sss[i].mss041-sss[i].mss043-sss[i].mss044 
      #            +sss[i].mss072-sss[i].mss071               #No.MOD-670040 add
      # END IF 
      #IF i=1 THEN   #除了第一期以外其他期的可延遲量只能是本期供給(不包括期初庫存)大于需求的部分
      #  IF sss[i].s0>0 THEN
      #     LET l_leave=sss[i].mss061+sss[i].mss062+sss[i].mss063-sss[i].s0
      #     declare sss_cs1 CURSOR FOR
      #       select mst08 from mst_file where mst01=sss[i].mss01
      #        AND mst02=sss[i].mss02 AND mst03=sss[i].mss03 
      #        AND mst_v=sss[i].mss_v AND (mst05='61' OR mst05='62' OR mst05='63') ORDER BY mst08 ,mst06,mst061
      #     FOREACH sss_cs1 INTO l_mst08
      #        IF  l_leave<=0 THEN EXIT FOREACH END IF 
      #        LET l_leave=l_leave-l_mst08
      #     END FOREACH
      #	    LET sss[i].s1=sss[i].s0+l_leave
      #     LET sss[i].s2=0 
      #     LET sss[i].s3=sss[i].s1
      #  END IF  
      #ELSE
      #  IF sss[i].s0>sss[i-1].s3 THEN
      #     LET l_leave=sss[i].mss061+sss[i].mss062+sss[i].mss063-sss[i].s0
      #     declare sss_cs3 CURSOR FOR
      #       select mst08 from mst_file where mst01=sss[i].mss01
      #        AND mst02=sss[i].mss02 AND mst03=sss[i].mss03 
      #        AND mst_v=sss[i].mss_v
      #        AND (mst05='61' OR mst05='62' OR mst05='63')
      #      ORDER BY mst08 ,mst06,mst061
      #     FOREACH sss_cs3 INTO l_mst08
      #        IF  l_leave<=0 THEN EXIT FOREACH END IF 
      #        LET l_leave=l_leave-l_mst08
      #     END FOREACH
      #	    LET sss[i].s1=sss[i].s0+l_leave
      #     LET sss[i].s2=0 
      #     LET sss[i].s3=sss[i].s1+sss[i-1].s3
      #  ELSE
      #     LET sss[i].s1=0
      #     LET sss[i].s3=0
      #     LET sss[i].s2=sss[i-1].s3
      #     LET sss[i].s_date=sss[i].mss03
      #     FOR n = i-1 TO 1 STEP -1 
      #     IF sss[n].s3<>0 THEN
      #     LET sss[n].s_date = sss[i].mss03
      #     ELSE 
      #      EXIT FOR
      #     END IF
      #     END FOR
      #  END IF
      #END IF                  
      #可延遲數量等於該實據的結存數量
      #s0:可延遲數量  s1:本期新增數量  s2:本期減少數量
       LET sss[i].s0 =sss[i].mss051+sss[i].mss052+sss[i].mss053 
                      +sss[i].mss061+sss[i].mss062+sss[i].mss063 
                      +sss[i].mss064+sss[i].mss065-sss[i].mss06_fz                     
                      -sss[i].mss041-sss[i].mss043-sss[i].mss044 
                      +sss[i].mss072-sss[i].mss071-tm.per          
      #MOD-A80087---modify---end---
     END FOREACH
    #MOD-A80087---modify---start---
    #FOR l=1 TO 400              #尋找可延遲的采購單
    #     IF sss[l].mss01 IS NULL THEN EXIT FOR END IF
    #     IF sss[l].s1 > 0 THEN  #如果有可延遲的采購單
    #LET l_leave=sss[l].mss061+sss[l].mss062+sss[l].mss063-sss[l].s0
    #declare sss_cs4 CURSOR FOR
    #  select * from mst_file where mst01=sss[l].mss01
    #   AND mst02=sss[l].mss02 AND mst03=sss[l].mss03 
    #   AND mst_v=sss[l].mss_v AND (mst05='61' OR mst05='62' OR mst05='63') ORDER BY mst08 ,mst06,mst061
    #FOREACH sss_cs4 INTO mst.*
    #   IF  l_leave<=0 THEN 
    #   #No.FUN-750097-------start-----------------
    #   #OUTPUT TO REPORT amrx532_rep(sr.*,sss[l].*,ima.*,mst.*)  
    #     #IF (mss.s_date-mss.mss03>tm.yc) OR cl_null(mss.s_date) THEN           #MOD-A50170 mark
    #      IF (sss[l].s_date-sss[l].mss03>tm.yc) OR cl_null(sss[l].s_date) THEN  #MOD-A50170
    #         EXECUTE insert_prep USING
    #              #---------------No.MOD-8A0030 modify
    #              #ima.ima02,ima.ima25,mss.mss00,mss.mss01,mss.mss03,
    #              #mss.s1,mss.s_date,mst.mst06,mst.mst061,
    #              #mst.mst07,mst.mst08
    #               ima.ima02,ima.ima25,sss[l].mss00,sss[l].mss01,
    #               sss[l].mss03,sss[l].s1,sss[l].s_date,
    #               mst.mst06,mst.mst061,
    #               mst.mst07,mst.mst08
    #              #---------------No.MOD-8A0030 end
    #      END IF
    #     #No.FUN-750097-------end-------------------
    #   END IF 
    #   LET l_leave=l_leave-mst.mst08
    #END FOREACH
    #    END IF      	    
    #END FOR
     FOR l=1 TO 400 
         IF sss[l].mss01 IS NULL THEN EXIT FOR END IF
         IF sss[l].s0 > 0 THEN
           LET l_leave=sss[l].s0
           DECLARE sss_cs4 CURSOR FOR
             SELECT * from mst_file where mst01=sss[l].mss01
              AND mst02=sss[l].mss02 AND mst03=sss[l].mss03 
              AND mst_v=sss[l].mss_v AND (mst05='61' OR mst05='62' OR mst05='63') ORDER BY mst08 ,mst06,mst061
           FOREACH sss_cs4 INTO mst.*
              LET l_leave = l_leave - mst.mst08
              SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = mst.mst07  #FUN-CB0003
              IF l_leave >= 0 THEN
                 FOR i = l+1 TO 400
                    IF (sss[i].mss03-sss[l].mss03>tm.yc) AND (tm.yc != 0) THEN  
                       EXIT FOR
                    END IF
                    IF sss[i].s0 + sss[i].s1 + sss[i].s2 < 0 THEN
                       LET sss[i].s1 = sss[i].s1 + mst.mst08
                       EXECUTE insert_prep USING 
                          ima.ima02,ima.ima25,sss[l].mss00,sss[l].mss01,
                          sss[l].mss03,sss[l].s0,sss[i].mss03,
                          mst.mst06,mst.mst061,
                          mst.mst07,mst.mst08
                         ,ima.ima021,l_pmc03,l_cancel,ima.ima08,ima.ima67,ima.ima43,sss[l].mss02    #FUN-CB0003 add
                       EXIT FOR
                    END IF
                 END FOR
              ELSE 
                 EXIT FOREACH
              END IF 
           END FOREACH
         END IF
     END FOR
    #MOD-A80087---modify---end---
 
#No.FUN-750097-------------end--------------------
#    FINISH REPORT amrx532_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'mss01')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
###XtraGrid###     LET g_str = g_str                                        
###XtraGrid###     CALL cl_prt_cs3('amrx532','amrx532',l_sql,g_str)                                                                                 
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003--str---
   LET g_xgrid.order_field = cl_get_order_field(tm.s,"mss01,ima08,ima67,ima43,mss02,mss03")
   LET g_xgrid.grup_field = cl_get_order_field(tm.s,"mss01,ima08,ima67,ima43,mss02,mss03")  #FUN-D30053
   LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mss01,ima08,ima67,ima43,mss02,mss03")
   LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
#FUN-CB0003--end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750097-------------end--------------------
END FUNCTION
 
#No.FUN-750097-------------end--------------------
{REPORT amrx532_rep(sr,mss, ima,mst)
   DEFINE l_last_sw    LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(1)
   DEFINE l_pmc03      LIKE pmc_file.pmc03     #NO.FUN-680082 VARCHAR(10)
   DEFINE  mss	RECORD 
                   mss_v    LIKE mss_file.mss_v,
                   mss00    LIKE mss_file.mss00,
                   mss01    LIKE mss_file.mss01,
                   mss02    LIKE mss_file.mss02,
                   mss03    LIKE mss_file.mss03,
                   mss041   LIKE mss_file.mss041,
                   mss043   LIKE mss_file.mss043,
                   mss044   LIKE mss_file.mss044,
                   mss051   LIKE mss_file.mss051,
                   mss052   LIKE mss_file.mss052,
                   mss053   LIKE mss_file.mss053,
                   mss061   LIKE mss_file.mss061,
                   mss062   LIKE mss_file.mss062,
                   mss063   LIKE mss_file.mss063,
                   mss064   LIKE mss_file.mss064,
                   mss065   LIKE mss_file.mss065,
                   mss06_fz LIKE mss_file.mss06_fz,
                   mss071   LIKE mss_file.mss071,
                   mss072   LIKE mss_file.mss072,
                   mss08    LIKE mss_file.mss08,
                   mss09    LIKE mss_file.mss09,
                   mss10    LIKE mss_file.mss10,
                   mss11    LIKE mss_file.mss11,
                   mss12    LIKE mss_file.mss12,
                   mssplant LIKE mss_file.mssplant,#NO.FUN-A40023
                   msslegal LIKE mss_file.msslegal,#NO.FUN-A40023
                   s0       LIKE mss_file.mss061,  #NO.FUN-680082 DECIMAL(12,3)     
                   s1       LIKE mss_file.mss061,  #多余的供給量         #NO.FUN-680082 DECIMAL(12,3)
                   s2       LIKE mss_file.mss061,  #供給調整后的增加量   #NO.FUN-680082 DECIMAL(12,3)
                   s3       LIKE mss_file.mss061,  #調整后的減少量       #NO.FUN-680082 DECIMAL(12,3)
                   s_date   LIKE type_file.dat     #NO.FUN-680082 DATE
                END RECORD
   DEFINE mst		RECORD LIKE mst_file.*
   DEFINE ima		RECORD LIKE ima_file.*
   DEFINE sr RECORD
             l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40    #NO.FUN-680082 VARCHAR(40)
             l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40    #NO.FUN-680082 VARCHAR(40)
             l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40    #NO.FUN-680082 VARCHAR(40)
          END RECORD
   DEFINE l_qty1   LIKE mss_file.mss041  #NO.FUN-680082 DECIMAL(12,3)
 
  OUTPUT TOP MARGIN g_top_margin 
  LEFT MARGIN g_left_margin 
  BOTTOM MARGIN g_bottom_margin 
  PAGE LENGTH g_page_line 
  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mss.mss01,mss.mss02,mss.mss03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company                                                                        
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] 
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
      PRINT g_head CLIPPED, pageno_total   
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42]
      PRINT g_dash1
 
      LET l_last_sw = 'n'
     
   BEFORE GROUP OF sr.l_order1
      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order2
      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order3
      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      IF (mss.s_date-mss.mss03>tm.yc) OR cl_null(mss.s_date) THEN
      PRINT COLUMN g_c[31],mss.mss01  CLIPPED, #FUN-5B0014 [1,20],                                                                                       
            COLUMN g_c[32],ima.ima02  CLIPPED,                                              
            COLUMN g_c[33],ima.ima25  CLIPPED,                                              
            COLUMN g_c[34],mss.mss00  USING '###&', #FUN-590118                                             
            COLUMN g_c[35],mss.mss03  USING 'mm/dd',                                        
            COLUMN g_c[36],mss.s1     USING '---,---,---,--&',                                         
            COLUMN g_c[37],0          USING '---,---,---,--&',                                                 
            COLUMN g_c[38],mst.mst07  CLIPPED,                                               
            COLUMN g_c[39],mss.s_date USING 'mm/dd',                                               
            COLUMN g_c[40],mst.mst06  CLIPPED,                                                   
            COLUMN g_c[41],mst.mst061 USING '####',
            COLUMN g_c[42],mst.mst08  USING '---,---,---,--&'
   END IF 
 
   AFTER GROUP OF mss.mss01
      PRINT g_dash [1,g_len] CLIPPED
 
   ON LAST ROW                                                                                                                      
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED                                                                 
      LET l_last_sw = 'y'                                                                                                                                        
 
   PAGE TRAILER                                                                                                                     
      IF l_last_sw = 'n'                                                                                                            
         THEN PRINT g_dash[1,g_len] CLIPPED                                                                                        
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]                                                                        
         ELSE SKIP 2 LINES                                                                                                           
      END IF                      
END REPORT}
#No.FUN-750097-------------end--------------------
#TQC-790177


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

