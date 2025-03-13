# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr310.4gl
# Descriptions...: 應收帳款明細表
# Date & Author..: 95/02/14 by Nick
# Modify.........: 95/05/10 By Danny (是否將原幣金額換成本幣金額)
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-540057 05/05/09 By vivien 發票號碼調整
# Modify.........: No.FUN-540057 05/05/10 By jackie 欄位長度調整
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-590110 05/09/23 By yoyo  報表修改
# Modify.........: No.MOD-5B0209 05/11/221By Smapmin 如果"原幣金額轉成本幣金額"打勾時,
#                                                    列印資料的"幣別"，應該全部列印本國幣別
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: NO.MOD-5C0153 05/12/27 BY kim 資料和資料間會多一空白行
# Modify.........: No.MOD-640308 06/04/10 By Smapmin 選已作癈時,無法印出作廢的單據
# Modify.........: No.TQC-5C0086 05/12/20 By Carrier AR月底重評修改 
# Modify.........: No.FUN-5C0014 06/05/30 By rainy   新增INVOICE No. oma67
# Modify.........: No.MOD-510068 06/06/09 By rainy   依幣別總計
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-670072 06/07/17 By Smapmin 修改合計金額
# Modify.........: No.TQC-670090 06/07/26 By Smapmin 排序無預設值,表尾資料呈現有誤
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/11 By xufeng 修改報表           
# Modify.........: No.TQC-770028 07/07/05 By Rayven 報表中制表日期與報表名稱所在的行數顛倒
#                                                   "項"欄位項次位置錯位
#                                                   類型編號和帳款編號下方均不勾選跳頁和小計,勾選打印產品明細,顯示的報表中,在總計上一行的產品編號欄出現很亂的明細資料
# Modify.........: No.FUN-7B0026 07/11/21 By baofei  報表輸出至Crystal Reports功能
# Modify.........: No.MOD-7C0041 07/12/06 By Smapmin 增加規格欄位
# Modify.........: No.MOD-830147 08/03/19 By Smapmin 若oma00 matches '2*',則金額應為負數
# Modify.........: No.FUN-860094 08/08/21 By xiaofeizhu 依原幣,本幣,全部的方式打印資料
# Modify.........: No.MOD-8B0053 08/11/06 By Sarah 折讓在本幣欄位未以負數呈現
# Modify.........: No.FUN-8B0024 08/12/26 By jan 提供INPUT加上關系人與營運中心
#............................................... 本幣無明細(axrr310_0_std.rpt),  本幣印明細(axrr310_0_std_1.rpt) 合并為 axrr310_0_std.rpt,  營運中心 axrr310_0_std_3.rpt
#............................................... 原幣無明細(axrr310_0_std_2.rpt),原幣印明細(axrr310_0_std_3.rpt) 合并為 axrr310_0_std_1.rpt   "      axrr310_0_std_4.rpt
#............................................... 全部無明細(axrr310_0_std_4.rpt),全部印明細(axrr310_0_std_5.rpt) 合并為 axrr310_0_std_2.rpt   "      axrr310_0_std_5.rpt 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-980003 09/08/07 By liuxqa 修正FUN-8B0024 導致的問題。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/21 By baofei GP5.2跨DB報表--財務類 
# Modify.........: No.TQC-A50082 10/05/20 By Carrier MOD-A40076 追单
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
# Modify.........: No.FUN-C50105 12/06/22 By bart 增加omb15,omb16t欄位
# Modify.........: No.MOD-C80083 12/08/13 By Polly 將tm.wc與l_sql的型態改為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                               # Print condition RECORD
             #wc       LIKE type_file.chr1000,      # Where condition  #No.FUN-680123 VARCHAR(1000) #MOD-C80083 mark
              wc       STRING,                      #MOD-C80083 add
           #FUN-A10098---begin
          #    b        LIKE type_file.chr1,    #No.FUN-8B0024 
          #    p1       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p2       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p3       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p4       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p5       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p6       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p7       LIKE azp_file.azp01,    #No.FUN-8B0024 
          #    p8       LIKE azp_file.azp01,    #No.FUN-8B0024
          #FUN-A10098---end
              s        LIKE type_file.chr3,        # Order by sequence #No.FUN-680123 VARCHAR(3)
              t        LIKE type_file.chr3,        # Eject sw #No.FUN-680123 VARCHAR(3)
              u        LIKE type_file.chr3,        # Group total sw #No.FUN-680123 VARCHAR(3)
	      i        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
	      j        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
	      k        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
	      l        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
	      y        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
              a        LIKE type_file.chr1,        #No.FUN-860094
              more     LIKE type_file.chr1         # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD
 
DEFINE   g_i           LIKE type_file.num5         #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i             LIKE type_file.num5         #No.FUN-680123 SMALLINT
DEFINE #l_sql      LIKE type_file.chr1000 
       l_sql   STRING      #NO.FUN-910082                                                                                                            
DEFINE l_table        STRING,                                                                                                       
       l_table1       STRING,
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                       
#DEFINE   m_dbs       ARRAY[10] OF LIKE type_file.chr20   #FUN-A10098 #No.FUN-8B0024 ARRAY[10] OF VARCHAR(20)   
 
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
   LET g_sql = "oma00.oma_file.oma00,",                                         
               "oma00_desc.oma_file.oma00,",                                         
               "oma01.oma_file.oma01,",                                                                   
               "oma02.oma_file.oma02,",                                         
               "oma03.oma_file.oma03,",                                         
               "oma032.oma_file.oma032,",                                         
               "oma08.oma_file.oma08,",                                         
               "oma10.oma_file.oma10,",                                         
               "oma11.oma_file.oma11,",                                         
               "oma15.oma_file.oma15,",      #TQC-A50082 add
               "oma23.oma_file.oma23,",                                       
               "oma54.oma_file.oma54,",                                       
               "oma54x.oma_file.oma54x,",
               "oma54t.oma_file.oma54t,",
               "oma67.oma_file.oma67,",
               "l_oox10.oox_file.oox10,",
               "gem02.gem_file.gem02,",
               "gen02.gen_file.gen02,",
               "balance.oma_file.oma54,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",                                         
               "azi07.azi_file.azi07,",
               "aza17.aza_file.aza17,",                          #FUN-860094                                                        
               "oma56.oma_file.oma56,",                          #FUN-860094                                                        
               "oma56x.oma_file.oma56x,",                        #FUN-860094                                                        
               "oma56t.oma_file.oma56t,",                        #FUN-860094                                                        
               "balance2.oma_file.oma56,",                       #FUN-860094
               "plant.azp_file.azp01"                            #FUN-8B0024                                                            
     LET l_table = cl_prt_temptable('axrr310',g_sql) CLIPPED                      
     IF l_table = -1 THEN EXIT PROGRAM END IF 
    LET g_sql = "omb01.omb_file.omb01,",
                "omb03.omb_file.omb03,",
                "omb04.omb_file.omb04,",
                "omb05.omb_file.omb05,",
                "omb06.omb_file.omb06,",
                "ima021.ima_file.ima021,",   #MOD-7C0041
                "omb12.omb_file.omb12,",
                "omb13.omb_file.omb13,",
                "omb14t.omb_file.omb14t,",
                "omb31.omb_file.omb31,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "omb15.omb_file.omb15,",   #FUN-C50105
                "omb16t.omb_file.omb16t "  #FUN-C50105
    LET l_table1 = cl_prt_temptable('axrr3101',g_sql) CLIPPED                      
    IF l_table1 = -1 THEN EXIT PROGRAM END IF         
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
   LET tm.i = ARG_VAL(11)
   LET tm.j = ARG_VAL(12)
   LET tm.k = ARG_VAL(13)
   LET tm.l = ARG_VAL(14)
   LET tm.a = ARG_VAL(15)                       #FUN-860094
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
#FUN-A10098---begin
#   LET tm.b     = ARG_VAL(20)
#   LET tm.p1    = ARG_VAL(21)
#   LET tm.p2    = ARG_VAL(22)
#   LET tm.p3    = ARG_VAL(23)
#   LET tm.p4    = ARG_VAL(24)
#   LET tm.p5    = ARG_VAL(25)
#   LET tm.p6    = ARG_VAL(26)
#   LET tm.p7    = ARG_VAL(27)
#   LET tm.p8    = ARG_VAL(28) 
#FUN-A10098---end
   IF cl_null(tm.wc)
      THEN CALL axrr310_tm(0,0)                  # Input print condition
      ELSE
      CALL axrr310()                             # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr310_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 2 LET p_col =15
   ELSE LET p_row = 3 LET p_col =13
   END IF
 
   OPEN WINDOW axrr310_w AT p_row,p_col
        WITH FORM "axr/42f/axrr310"
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
   LET tm.s='23 '
   LET tm.t='Y  '
   LET tm.u='Y  '
   LET tm.i='1'
   LET tm.j='1'
   LET tm.k='2'
   LET tm.l='N'
   LET tm.a='1'                       #FUN-860094
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
#   LET tm.b ='N'       #FUN-A10098
#   LET tm.p1=g_plant  #FUN-A10098
   CALL r310_set_entry_1()               
   CALL r310_set_no_entry_1()
   CALL r310_set_comb()           
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma02,oma00,oma01,oma11,oma15,oma14,
	        	      oma03,oma10,oma23
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
#FUN-A10098---begin
#   INPUT BY NAME   tm.b,tm.p1,tm.p2,tm.p3,                                  #FUN-8B0024
#                   tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                           #FUN-8B0024
#                   tm2.s1,tm2.s2,tm2.s3,
    INPUT BY NAME  tm2.s1,tm2.s2,tm2.s3,   
#FUN-A10098---end
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,tm.k,tm.j,tm.i,tm.l,tm.a,           #FUN-860094
                   tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
#FUN-A10098---begin         
#      AFTER FIELD b
#         IF NOT cl_null(tm.b)  THEN
#            IF tm.b NOT MATCHES "[YN]" THEN
#               NEXT FIELD b       
#            END IF
#         END IF
#                   
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#         CALL r310_set_entry_1()      
#         CALL r310_set_no_entry_1()
#         CALL r310_set_comb()       
#      
#     AFTER FIELD p1
#        IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#        SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#        IF STATUS THEN 
#           CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#           NEXT FIELD p1 
#        END IF
#        IF NOT cl_null(tm.p1) THEN 
#           IF NOT s_chk_demo(g_user,tm.p1) THEN              
#              NEXT FIELD p1          
#           END IF  
#        END IF              
#
#     AFTER FIELD p2
#        IF NOT cl_null(tm.p2) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p2 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p2) THEN
#              NEXT FIELD p2
#           END IF            
#        END IF
#
#     AFTER FIELD p3
#        IF NOT cl_null(tm.p3) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p3 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p3) THEN
#              NEXT FIELD p3
#           END IF            
#        END IF
#
#     AFTER FIELD p4
#        IF NOT cl_null(tm.p4) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p4 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p4) THEN
#              NEXT FIELD p4
#           END IF            
#        END IF
#
#     AFTER FIELD p5
#        IF NOT cl_null(tm.p5) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#              NEXT FIELD p5 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p5) THEN
#              NEXT FIELD p5
#           END IF            
#        END IF
#
#     AFTER FIELD p6
#        IF NOT cl_null(tm.p6) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#              NEXT FIELD p6 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p6) THEN
#              NEXT FIELD p6
#           END IF            
#        END IF
#
#     AFTER FIELD p7
#        IF NOT cl_null(tm.p7) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#              NEXT FIELD p7 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p7) THEN
#              NEXT FIELD p7
#           END IF            
#        END IF
#
#     AFTER FIELD p8
#        IF NOT cl_null(tm.p8) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#           IF STATUS THEN 
#              CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#              NEXT FIELD p8 
#           END IF
#           IF NOT s_chk_demo(g_user,tm.p8) THEN
#              NEXT FIELD p8
#           END IF            
#        END IF       
#FUN-A10098---end 
      AFTER FIELD i
         IF cl_null(tm.i) OR tm.i NOT MATCHES '[12]' THEN
            NEXT FIELD i
         END IF
      AFTER FIELD j
         IF cl_null(tm.j) OR tm.j NOT MATCHES '[123]' THEN
            NEXT FIELD j
         END IF
      AFTER FIELD k
         IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]' THEN
            NEXT FIELD k
         END IF
      AFTER FIELD l
         IF cl_null(tm.l) OR tm.l NOT MATCHES '[YN]' THEN
            NEXT FIELD l
         END IF
                                                                                                                                    
      AFTER FIELD a                                                                                                                 
         IF tm.a NOT MATCHES '[123]' THEN                                                                                           
            NEXT FIELD a                                                                                                            
         END IF                                                                                                                     
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
#FUN-A10098---begin         
#     ON ACTION CONTROLP
#        CASE                                                    
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE
#FUN-A10098---end 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr310','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,   #TQC-610059
                         " '",tm.t CLIPPED,"'" ,   #TQC-610059
                         " '",tm.u CLIPPED,"'" ,   #TQC-610059
                         " '",tm.i CLIPPED,"'" ,
                         " '",tm.j CLIPPED,"'" ,
                         " '",tm.k CLIPPED,"'" ,
                         " '",tm.l CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,                #No.FUN-860094
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"           #No.FUN-7C0078
                     #FUN-A10098---begin
                        # " '",tm.b CLIPPED,"'" ,    #FUN-8B0024
                        # " '",tm.p1 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p2 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p3 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p4 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p5 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p6 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p7 CLIPPED,"'" ,   #FUN-8B0024
                        # " '",tm.p8 CLIPPED,"'"     #FUN-8B0024 
                     #FUN-A10098---end
         CALL cl_cmdat('axrr310',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr310()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr310_w
END FUNCTION
 
FUNCTION axrr310()
   DEFINE 
          l_name    LIKE type_file.chr20,                 # External(Disk) file name #No.FUN-680123 VARCHAR(20)
         #l_sql     LIKE type_file.chr1000,               #No.FUN-680123 VARCHAR(1000) #MOD-C80083 mark
          l_sql     STRING,                               #MOD-C80083 add
          l_za05    LIKE type_file.chr1000,               #No.FUN-680123 VARCHAR(40)
          l_omavoid LIKE oma_file.omavoid,
          l_omaconf LIKE oma_file.omaconf,
          l_order   ARRAY[5] OF LIKE oma_file.oma01,       #NO.FUN-560011  #No.FUN-680123 VARCHAR(16)
          sr        RECORD
                    order1      LIKE type_file.chr1000,    #FUN-560011 #No.FUN-680123 VARCHAR(40)
                    order2      LIKE type_file.chr1000,    #FUN-560011 #No.FUN-680123 VARCHAR(40)
                    order3      LIKE type_file.chr1000,    #FUN-560011 #No.FUN-680123 VARCHAR(40)
                    oma02       LIKE oma_file.oma02,       #帳款日期
                    oma08       LIKE oma_file.oma08,       #內銷/外銷
                    oma00       LIKE oma_file.oma00,       #類別
                    oma00_desc  LIKE oma_file.oma00,       #類別說明 #No.FUN-680123 VARCHAR(4)
                    oma01       LIKE oma_file.oma01,       #帳款編號
                    oma11       LIKE oma_file.oma11,       #應收款日
                    oma15       LIKE oma_file.oma15,       #部门编号     #TQC-A50082
                    gem02       LIKE gem_file.gem02,       #部門
                    gen02       LIKE gen_file.gen02,       #業務員
                    oma03       LIKE oma_file.oma03,       #客戶
                    oma032      LIKE oma_file.oma032,      #簡稱
                    oma10       LIKE oma_file.oma10,       #參考單號
                    oma67       LIKE oma_file.oma67,       #INVOICE NO.  #FUN-5C0014
                    oma23       LIKE oma_file.oma23,       #幣別
                    oma54       LIKE oma_file.oma54,       #未稅額
                    oma54x      LIKE oma_file.oma54x,      #稅額
                    oma54t      LIKE oma_file.oma54t,      #應收金額
                    balance     LIKE oma_file.oma54,       #未沖金額
                    oma56       LIKE oma_file.oma56,       #本幣未稅額
                    oma56x      LIKE oma_file.oma56x,      #本幣稅額
                    oma56t      LIKE oma_file.oma56t,      #本幣應收金額
                    balance2    LIKE oma_file.oma56,       #本幣未沖金額
                    azi03       LIKE azi_file.azi03,       #
                    azi04       LIKE azi_file.azi04,       #
                    azi05       LIKE azi_file.azi05,       #
                    azi07       LIKE azi_file.azi07        #
                    END RECORD,
          sr2       RECORD
                    omb03       LIKE omb_file.omb03,
                    omb31       LIKE omb_file.omb31,
                    omb04       LIKE omb_file.omb04,
                    omb06       LIKE omb_file.omb06,
                    omb05       LIKE omb_file.omb05,
                    omb12       LIKE omb_file.omb12,
                    omb13       LIKE omb_file.omb13,
                    omb14t      LIKE omb_file.omb14t,
                    omb15       LIKE omb_file.omb15,  #FUN-C50105
                    omb16t      LIKE omb_file.omb16t  #FUN-C50105
                    END RECORD,
                    l_oox10      LIKE oox_file.oox10,  
                    l_omb03      LIKE omb_file.omb03,     
                    l1_omb03     LIKE omb_file.omb03                                 
DEFINE        l_ima021     LIKE ima_file.ima021   #MOD-7C0041
DEFINE     l_i          LIKE type_file.num5                 #No.FUN-8B0024 SMALLINT
DEFINE     l_dbs        LIKE azp_file.azp03                 #No.FUN-8B0024
DEFINE     l_azp01      LIKE azp_file.azp01                 #No.FUN-8B0024
DEFINE     l_azp03      LIKE azp_file.azp03                 #No.FUN-8B0024
DEFINE     i            LIKE type_file.num5                 #No.FUN-8B0024
DEFINE     l_oma14      LIKE oma_file.oma14                 #No.FUN-8B0024
DEFINE     l_oma15      LIKE oma_file.oma15                 #No.FUN-8B0024
 
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "          #FUN-860094 Add "?,?,?,?,?" #FUN-8B0024 add ?  #No.TQC-A50082
      PREPARE insert_prep FROM g_sql                                               
      IF STATUS THEN                                                               
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
         EXIT PROGRAM                         
      END IF  
  IF tm.l='Y' THEN
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "         #MOD-7C0041  #FUN-C50105 2?
      PREPARE insert_prep1 FROM g_sql                                               
      IF STATUS THEN                                                               
         CALL cl_err('insert_prep1:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
         EXIT PROGRAM                         
      END IF  
      CALL cl_del_data(l_table)     
      CALL cl_del_data(l_table1)
  ELSE
      CALL cl_del_data(l_table)
  END IF
         
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
#FUN-A10098---begin
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
 
#   FOR l_i = 1 to 8                                                          
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       
#       SELECT azp01,azp03 INTO l_azp01,l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          
#       LET l_azp03= l_dbs CLIPPED                                           
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         
#FUN-A10098---end
     IF g_ooz.ooz07 = 'N' THEN
        LET l_sql="SELECT '','','',oma02,oma08,oma00,'',oma01,oma11,oma15,gem02, ",  #No.TQC-A50082
      	          "   	      gen02,oma03,oma032,oma10,oma67,oma23,oma54,oma54x, ", #FUN-5C
                  "	   oma54t,oma54t-oma55,oma56,oma56x,oma56t, ",
   	              "   	      oma56t-oma57,azi03,azi04,azi05,azi07 ",
               #   " FROM ",l_dbs CLIPPED," oma_file,OUTER ",l_dbs CLIPPED," gem_file,OUTER ",l_dbs CLIPPED," gen_file,OUTER ",l_dbs CLIPPED," azi_file ", #FUN-8B0024   #FUN-A10098
                  " FROM  oma_file,OUTER  gem_file,OUTER  gen_file,OUTER  azi_file ", #FUN-8B0024   #FUN-A10098
                   " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ",
	                "   AND oma_file.oma23=azi_file.azi01 AND ",tm.wc CLIPPED
     ELSE                                                                                                                           
        LET l_sql="SELECT '','','',oma02,oma08,oma00,'',oma01,oma11,oma15,gem02, ",  #No.TQC-A50082
                  "           gen02,oma03,oma032,oma10,oma67,oma23,oma54,oma54x, ", 
                  "        oma54t,oma54t-oma55,oma56,oma56x,oma56t, ", 
                  "           oma61 ,azi03,azi04,azi05,azi07 ",     
                #  " FROM ",l_dbs CLIPPED," oma_file,OUTER ",l_dbs CLIPPED," gem_file,OUTER ",l_dbs CLIPPED," gen_file,OUTER ",l_dbs CLIPPED," azi_file ",  #FUN-8B0024 #FUN-A10098
                  " FROM  oma_file,OUTER  gem_file,OUTER gen_file,OUTER  azi_file ",  #FUN-8B0024 #FUN-A10098
                  " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ",                                                         
                  "   AND oma_file.oma23=azi_file.azi01 AND ",tm.wc CLIPPED                                                                     
     END IF                                                                                                                         
	 LET l_sql= l_sql CLIPPED
     CASE tm.j
      WHEN '1' LET l_sql = l_sql clipped," AND omaconf = 'Y' "
      WHEN '2' LET l_sql = l_sql clipped," AND omaconf = 'N' "
	 END CASE
	 CASE tm.k
      WHEN '1' LET l_sql = l_sql clipped," AND omavoid = 'Y' "
      WHEN '2' LET l_sql = l_sql clipped," AND omavoid = 'N' "
	 END CASE
     LET l_sql = l_sql clipped," ORDER BY oma03 "
			
     PREPARE axrr310_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr310_curs1 CURSOR FOR axrr310_prepare1
 
#     IF cl_null(tm.b) THEN LET tm.b = 'N' END IF    #FUN-A10098
#       IF tm.b = 'N' THEN     #單一營運中心     #FUN-A10098
         CASE tm.a
           WHEN '1'    #印原幣
             LET l_name = 'axrr310_1'
           WHEN '2'    #印本幣
             LET l_name = 'axrr310'
           WHEN '3'    #印原幣/本幣全部
             LET l_name = 'axrr310_2'
         END CASE
#FUN-A10098---begin
#       ELSE                   #多營運中心
#         CASE tm.a
#           WHEN '1'    #印原幣
#             LET l_name = 'axrr310_4'
#           WHEN '2'    #印本幣
#             LET l_name = 'axrr310_3'
#           WHEN '3'    #印原幣/本幣全部
#             LET l_name = 'axrr310_5'
#         END CASE
#       END IF  
#FUN-A10098---end 
     FOREACH axrr310_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
	   IF tm.i = '1' AND sr.balance=0 THEN CONTINUE FOREACH END IF
       IF tm.a='2' THEN                          #FUN-860094
          LET sr.oma23=g_aza.aza17   #MOD-5B0209
          LET sr.oma54=sr.oma56
          LET sr.oma54x=sr.oma56x
          LET sr.oma54t=sr.oma56t
          LET sr.balance=sr.balance2
       END IF
       IF sr.oma00 matches '2*' THEN
          LET sr.oma54 = -sr.oma54
          LET sr.oma54x = -sr.oma54x
          LET sr.oma54t = -sr.oma54t
          LET sr.balance = -sr.balance
          LET sr.oma56 = -sr.oma56
          LET sr.oma56x = -sr.oma56x
          LET sr.oma56t = -sr.oma56t
          LET sr.balance2= -sr.balance2
       END IF
      LET l_sql = "SELECT azi03,azi04,azi05,azi07 ",                                                                              
           #      "  FROM ",l_dbs CLIPPED,"azi_file",         #FUN-A10098                                                                   
                 "  FROM azi_file",         #FUN-A10098                                                                   
                  " WHERE azi01='",sr.oma23,"'"                                                                                                                                                                               
      PREPARE azi_prepare3 FROM l_sql                                                                                          
      DECLARE azi_c3  CURSOR FOR azi_prepare3                                                                                 
      OPEN azi_c3                                                                                    
      FETCH azi_c3 INTO sr.azi03,sr.azi04,sr.azi05    
     
      LET l_sql = "SELECT SUM(oox10) ",                                                                              
              #    "  FROM ",l_dbs CLIPPED,"oox_file",      #FUN-A10098                                                                     
                  "  FROM oox_file",      #FUN-A10098                                                                     
                  " WHERE oox00='AR'",
                  "   AND oox03 = '",sr.oma01,"'"
                                                                                                                                                                                   
      PREPARE oox_prepare FROM l_sql                                                                                          
      DECLARE oox_c CURSOR FOR oox_prepare                                                                                 
      OPEN oox_c                                                                                    
      FETCH oox_c INTO l_oox10
      
      IF cl_null(l_oox10) THEN LET l_oox10=0 END IF
      
      LET l_omb03 = 0     
      LET l1_omb03 = 0    
      IF tm.l='Y'  THEN
               IF tm.a='2' THEN                                                          #FUN-860094
                  LET l_sql=" SELECT omb03,omb31,omb04,omb06,omb05,omb12,omb15,omb16t,'','' "  #FUN-C50105
               ELSE
                  LET l_sql=" SELECT omb03,omb31,omb04,omb06,omb05,omb12,omb13,omb14t,omb15,omb16t "  #FUN-C50105
               END IF
               LET  l_sql=l_sql CLIPPED,
                     #    " FROM ",l_dbs CLIPPED," omb_file ",  #FUN-8B0024 #FUN-A10098
                         " FROM  omb_file ",  #FUN-8B0024 #FUN-A10098
                         " WHERE omb01= '",sr.oma01,"'"
               
               IF g_aza.aza26 = '2' THEN
                  IF tm.a='2' THEN                                                       #FUN-860094
                     LET l_sql = l_sql CLIPPED,
                                 " UNION ",
                                 "SELECT omb03,omb31,omb04,omb06,omb05,-omb12,omb15,-omb16t,'','' ",  #No.TQC-980003 mod  #FUN-C50105
                               #  "  FROM ",l_dbs CLIPPED," omb_file ",   #No.TQC-980003 add  #FUN-A10098
                                 "  FROM  omb_file ",   #No.TQC-980003 add  #FUN-A10098
                                 " WHERE omb01 IN (SELECT DISTINCT oot01 ", #FUN-8B0024
                                 "  FROM oot_file ",
                                 " WHERE oot03 = '",sr.oma01,"')"
                  ELSE
                     LET l_sql = l_sql CLIPPED,
                                 " UNION ",
                                 "SELECT omb03,omb31,omb04,omb06,omb05,-omb12,omb13,-omb14t,omb15,-omb16t ",  #No.TQC-980003 mod #FUN-C50105
                              #  "  FROM ",l_dbs CLIPPED," omb_file ",  #FUN-8B0024  #FUN-A10098
                                "  FROM  omb_file ",  #FUN-8B0024  #FUN-A10098
                                 " WHERE omb01 IN (SELECT DISTINCT oot01 ",
                                 "  FROM oot_file ",
                                 " WHERE oot03 = '",sr.oma01,"') "
                  END IF
               END IF
              
               PREPARE r310_prepare_omb FROM l_sql
               IF SQLCA.sqlcode THEN
                   CALL cl_err('r310_prepare_omb:',SQLCA.sqlcode,1) RETURN
               END IF
               DECLARE axrr310_cur2 CURSOR FOR r310_prepare_omb
              
              
               FOREACH axrr310_cur2 INTO sr2.*
         
                 LET l1_omb03 = l_omb03
                 LET l_omb03 = sr2.omb03
                 IF sr2.omb03 = g_aza.aza34 THEN
                    LET sr2.omb03 = l1_omb03 + 1
                    LET l_omb03 = sr2.omb03
                 END IF
                 LET l_ima021 = ''
                 LET l_sql = "SELECT ima021 ",
                            # " FROM ",l_dbs CLIPPED," ima_file",  #FUN-A10098
                             " FROM  ima_file",  #FUN-A10098
                             " WHERE ima01= '",sr2.omb04,"'"
                 PREPARE ima_prepare FROM l_sql                                                                                          
                 DECLARE ima_c CURSOR FOR ima_prepare                                                                                 
                 OPEN ima_c                                                                                    
                 FETCH ima_c INTO l_ima021
                 
                 EXECUTE insert_prep1 USING   sr.oma01,sr2.omb03,sr2.omb04,sr2.omb05,sr2.omb06,l_ima021,sr2.omb12,   #MOD-7C0041
                                              sr2.omb13,sr2.omb14t,sr2.omb31,sr.azi03,sr.azi04,sr2.omb15,sr2.omb16t  #FUN-C50105
 
               END FOREACH
      END IF
      
      EXECUTE insert_prep  USING  sr.oma00,sr.oma00_desc,sr.oma01,sr.oma02,sr.oma03,sr.oma032,sr.oma08,
                                  sr.oma10,sr.oma11,sr.oma15,sr.oma23,sr.oma54,sr.oma54x,sr.oma54t,sr.oma67,  #No.TQC-A50082
                                  l_oox10,sr.gem02,sr.gen02,sr.balance,sr.azi04,sr.azi05,sr.azi07,
               #                   g_aza.aza17,sr.oma56,sr.oma56x,sr.oma56t,sr.balance2,m_dbs[l_i]      #FUN-A10098  #FUN-860094 #FUN-8B0024 add m_dbs[l_i]
                                  g_aza.aza17,sr.oma56,sr.oma56x,sr.oma56t,sr.balance2,' '      #FUN-A10098  
                                   
     END FOREACH
#   END FOR    #FUN-8B0024   #FUN-A10098
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'oma02,oma00,oma01,oma11,oma15,oma14')                                                                       
              RETURNING tm.wc    
      END IF
      
      IF cl_null(tm.l) THEN LET tm.l = 'N' END IF  #FUN-8B0024
      
      LET g_str=tm.wc ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                           tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
                           tm.u[3,3],";",tm.i,";",tm.j,";",tm.k,";",tm.l                 #FUN-8B0024 add tm.l                               
                                 
                                                                  
   IF tm.l='N' THEN
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
   ELSE
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED    
   END IF                                                    
   CALL cl_prt_cs3('axrr310',l_name,l_sql,g_str)   
 
END FUNCTION
 
FUNCTION r310_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
 
FUNCTION r310_set_no_entry_1()
#    IF tm.b = 'N' THEN  #FUN-A10098
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)  #FUN-A10098
       IF tm2.s1 = 'A' THEN                                                                                                         
          LET tm2.s1 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s2 = 'A' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s3 = 'A' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF
#    END IF  #FUN-A10098
END FUNCTION 
 
FUNCTION r310_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
 #   IF tm.b ='N' THEN                           #FUN-A10098                                                                               
       LET comb_value = '1,2,3,4,5,6,7,8,9'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axr-990' AND ze02=g_lang                                                                                      
 #   ELSE                                        #FUN-A10098                                                                                    
 #      LET comb_value = '1,2,3,4,5,6,7,8,9,A'   #FUN-A10098                                                                                                
 #      SELECT ze03 INTO comb_item FROM ze_file  #FUN-A10098                                                                                    
 #        WHERE ze01='axr-991' AND ze02=g_lang   #FUN-A10098                                                                                    
 #   END IF                                      #FUN-A10098                                                                                                                    
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION
#No.FUN-9C0072 精簡程式碼
