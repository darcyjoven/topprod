# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: acop510.4gl
# Descriptions...: 材料/成品進出口各期異動統計量計算作業
# Date & Author..: No.MOD-490398 05/01/19 By Danny
# Modify.........: NO.MOD-490398 05/02/28 By Carrier
#                  1.更正選取資料的來源 2.取消成品報廢 3.cnk/cnl各量的調整 4.修改u_flag長度
# Modify.........: NO.MOD-590331 05/12/08 By Carrier                            
#                  1.報表用ORDER EXTERNAL BY                                    
#                  2.應用EXTERNAL BY,調整丟至REPORT的OUTPUT內容 
# Modify.........: No.TQC-5C0047 05/12/13 By Nicola 列印加入COLUMN
# Modify.........: No.FUN-570116 06/02/28 By yiting 批次背景執行
# MOdify.........: No.TQC-660045 06/06/13 By hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy               LIKE cnl_file.cnl03,
       mm               LIKE cnl_file.cnl04,
        g_sql           STRING,  #No.FUN-580092 HCN        #No.FUN-680069
        g_wc            STRING,  #No.FUN-580092 HCN        #No.FUN-680069
       g_cnl RECORD     
             type       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) #1.成品 2.材料
             cnl01      LIKE cnl_file.cnl01,          #手冊編號
             cnl02      LIKE cnl_file.cnl02,          #商品編號(材料/成品)
             cnl05      LIKE cnl_file.cnl05,          #直接進口/直接出口
             cnl06      LIKE cnl_file.cnl06,          #直接耗用/No use
             cnl07      LIKE cnl_file.cnl07,          #國外退貨
             cnl08      LIKE cnl_file.cnl08,          #轉廠進口/轉廠出口
             cnl09      LIKE cnl_file.cnl09,          #轉廠耗用/No use
             cnl10      LIKE cnl_file.cnl10,          #轉廠退貨/轉廠退貨
             cnl11      LIKE cnl_file.cnl11,          #國內採購/內銷出貨
             cnl12      LIKE cnl_file.cnl12,          #內購退貨/內銷退貨
             cnl13      LIKE cnl_file.cnl13,          #內銷耗用/No use
             cnl14      LIKE cnl_file.cnl14,          #手冊轉出/No use
             cnl15      LIKE cnl_file.cnl15,          #手冊轉入/No use
             cnl16      LIKE cnl_file.cnl16,          #報廢數量
             cnl17      LIKE cnl_file.cnl17           #期末數量
             END RECORD,
       g_cnq RECORD     LIKE cnq_file.*,
       g_bdate          LIKE type_file.dat,          #No.FUN-680069 DATE
       g_edate          LIKE type_file.dat,          #No.FUN-680069 DATE
        u_flag          LIKE aba_file.aba18,         # Prog. Version..: '5.30.06-13.03.12(02)  #No.MOD-490398
#       p_row,p_col	LIKE type_file.num5          #NO.FUN-570116 MARK        #No.FUN-680069 SMALLINT
       g_change_lang    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)  #No.FUN-570116
MAIN
#     DEFINE   l_time   LIKE type_file.chr8          #No.FUN-6A0063
   DEFINE   l_flag      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   DEFINE   ls_date     STRING                       #No.FUN-570116
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
    #No.FUN-570116--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc   = ARG_VAL(1)
   LET yy     = ARG_VAL(2)
   LET mm     = ARG_VAL(3)
   LET g_bgjob= ARG_VAL(4)
   IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
   END IF
    #No.FUN-570116--end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
#NO.FUN-570116 START---
#   LET p_row = 4 LET p_col = 10
#   OPEN WINDOW p510_w AT p_row,p_col
#        WITH FORM "aco/42f/acop510"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN EXIT WHILE END IF
      IF g_bgjob="N" THEN
          CALL p510_ask()
#          IF g_action_choice = "locale" THEN
#             LET g_action_choice = ""
#             CALL cl_dynamic_locale()
#             CALL cl_show_fld_cont()   #FUN-550037(smin)
#             CONTINUE WHILE
#          END IF
#          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
          IF cl_sure(20,20) THEN
             #BEGIN WORK   #No.MOD-590331  #NO.FUN-570116 MARK
             CALL p510()
             IF g_success='Y' THEN
                COMMIT WORK
                CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
             ELSE
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
             END IF
        
             IF l_flag THEN
                CONTINUE WHILE
             ELSE
                CLOSE WINDOW p510_w  #NO.FUN-570116
                EXIT WHILE
             END IF
          ELSE
             #EXIT WHILE
             CONTINUE WHILE
          END IF
      ELSE
        LET g_success='Y'
        CALL p510()
        IF g_success="Y" THEN
           COMMIT WORK
        ELSE
          ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
      END IF
END WHILE
#       CLOSE WINDOW p510_w
# No.FUN-570116--end--
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p510_ask()
   DEFINE c             LIKE qcs_file.qcs03         #No.FUN-680069 VARCHAR(10)
   DEFINE lc_cmd        LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500) #No.FUN-570116
   DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-570116 #No.FUN-680069 SMALLINT
 
  #No.FUN-570116--start--
      LET p_row = 4  LET p_col = 10
      OPEN WINDOW p510_w AT p_row,p_col WITH FORM "aco/42f/acop510"
        ATTRIBUTE(STYLE=g_win_style)
      CALL cl_ui_init()
      CLEAR FORM
  #No.FUN-570116--end--
 
WHILE TRUE #No.FUN-570116
   CONSTRUCT BY NAME g_wc ON coc03,coe03
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
     ON ACTION locale
       #LET g_action_choice = "locale" #No.FUN-570116
        LET g_change_lang = TRUE       #No.FUN-570116
        EXIT CONSTRUCT
 
     ON ACTION exit                 
        LET g_action_choice='exit'
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup') #FUN-980030
    #No.FUN-570611--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p510_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF
  
   #IF g_action_choice = "locale" THEN RETURN  END IF
   #IF INT_FLAG THEN RETURN END IF
   #No.FUN-570116--end--
 
   LET yy = YEAR(g_today)
   LET mm = MONTH(g_today)
   LET g_bgjob = "N"         #No.FUN-570116
 
   #INPUT BY NAME yy,mm WITHOUT DEFAULTS 
   INPUT BY NAME yy,mm,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570116
      AFTER FIELD yy
         IF cl_null(yy) OR yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF mm > 12 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF mm > 13 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(mm) OR mm = 0 THEN NEXT FIELD mm END IF
 
      AFTER INPUT 
         IF cl_null(mm) THEN NEXT FIELD yy END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
        #LET g_action_choice = "locale" #No.FUN-570116
         LET g_change_lang   = TRUE
         EXIT INPUT
 
      ON ACTION exit           
         LET g_action_choice='exit'
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
    #No.FUN-570611--start--
      IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p510_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF
   #No.FUN-570116--end--
 
#No.FUN-570116--start--
 IF g_bgjob = "Y" THEN
 SELECT zz08 INTO lc_cmd FROM zz_file
 WHERE zz01 = "acop510"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acop510','9031',1)
        ELSE
         LET g_wc  = cl_replace_str(g_wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",g_wc CLIPPED,"'",
                   " '",yy CLIPPED,"'",
                   " '",mm CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop510',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p510_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
   EXIT WHILE
END WHILE
   #IF g_action_choice = "locale" THEN RETURN END IF
   #IF INT_FLAG THEN RETURN END IF
#No.FUN-570116--end---
 
END FUNCTION
 
FUNCTION p510()
   DEFINE l_yy,l_mm   LIKE type_file.num10        #No.FUN-680069 INTEGER
   DEFINE l_bdate     LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_edate     LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_correct   LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
   DEFINE l_cmd       LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(80)
   DEFINE l_name      LIKE type_file.chr20        #No.FUN-680069 VARCHAR(20)
   DEFINE l_chr       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
   DEFINE l_i,l_j     LIKE type_file.num5         #No.FUN-680069 SMALLINT
    DEFINE l_wc       LIKE type_file.chr1000      #No.MOD-490398 #No.FUN-680069 VARCHAR(300)
   #No.MOD-590331  --begin                                                      
   DEFINE sr    RECORD                                                          
                type       LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01) #1.成品 2.材料         
                cnl01      LIKE cnl_file.cnl01,   #手冊編號              
                cnl02      LIKE cnl_file.cnl02,   #商品編號(材料/成品)   
                cnl05      LIKE cnl_file.cnl05,   #直接進口/直接出口     
                cnl06      LIKE cnl_file.cnl06,   #直接耗用/No use       
                cnl07      LIKE cnl_file.cnl07,   #國外退貨              
                cnl08      LIKE cnl_file.cnl08,   #轉廠進口/轉廠出口     
                cnl09      LIKE cnl_file.cnl09,   #轉廠耗用/No use       
                cnl10      LIKE cnl_file.cnl10,   #轉廠退貨/轉廠退貨     
                cnl11      LIKE cnl_file.cnl11,   #國內采購/內銷出貨     
                cnl12      LIKE cnl_file.cnl12,   #內購退貨/內銷退貨     
                cnl13      LIKE cnl_file.cnl13,   #內銷耗用/No use       
                cnl14      LIKE cnl_file.cnl14,   #手冊轉出/No use       
                cnl15      LIKE cnl_file.cnl15,   #手冊轉入/No use       
                cnl16      LIKE cnl_file.cnl16,   #報廢數量              
                cnl17      LIKE cnl_file.cnl17,   #期末數量              
                cnq13      LIKE cnq_file.cnq13,   #異動數量              
                chr        LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)   #I:加項 O:減項         
                u_flag     LIKE aba_file.aba18    # Prog. Version..: '5.30.06-13.03.12(02)   #No.MOD-490398                           
                END  RECORD                                                     
   #No.MOD-590331  --end 
 
   LET g_success = 'Y'
   CALL cl_outnam('acop510') RETURNING l_name
   START REPORT p510_rep TO l_name
   CALL s_azm(yy,mm)                     #得出期間的起始日與截止日
        RETURNING l_correct, g_bdate, g_edate
   IF l_correct THEN LET g_success = 'N' RETURN END IF
   CALL s_lsperiod(yy,mm) RETURNING l_yy,l_mm
 
   #No.MOD-590331  --begin                                                      
   DROP TABLE p510_tmp_file;
#No.FUN-680069-begin
   CREATE TEMP TABLE p510_tmp_file(                                             
          type       LIKE type_file.chr1,  
          cnl01      LIKE cnl_file.cnl01,
          cnl02      LIKE cnl_file.cnl02,
          cnl05      LIKE cnl_file.cnl05,
          cnl06      LIKE cnl_file.cnl06,
          cnl07      LIKE cnl_file.cnl07,
          cnl08      LIKE cnl_file.cnl08,
          cnl09      LIKE cnl_file.cnl09,
          cnl10      LIKE cnl_file.cnl10,
          cnl11      LIKE cnl_file.cnl11,
          cnl12      LIKE cnl_file.cnl12,
          cnl13      LIKE cnl_file.cnl13,
          cnl14      LIKE cnl_file.cnl14,
          cnl15      LIKE cnl_file.cnl15,
          cnl16      LIKE cnl_file.cnl16,
          cnl17      LIKE cnl_file.cnl17,
          cnq13      LIKE cnq_file.cnq13,
          chr        LIKE type_file.chr1,  
          u_flag     LIKE aba_file.aba18)
#No.FUN-680069-end
   IF STATUS THEN 
      CALL cl_err('create tmp',STATUS,0)                                        
      LET g_success = 'N'                                                       
      RETURN                                                                    
   END IF                                                                       
   #No.MOD-590331  --end 
   LET l_i = 0
   FOR l_i = 1 TO 2
       IF l_i = 1 THEN       #成品
           #No.MOD-490398  --begin
          LET l_wc = g_wc
          FOR l_j = 1 TO 296
              IF l_wc[l_j,l_j+4] = 'coe03' THEN 
                 LET l_wc[l_j,l_j+4] = 'cod03'
              END IF
          END FOR
          LET g_sql = "SELECT '1',coc03,cod03,cnk05,0,cnk06,cnk07,0,",
                      "       cnk08,cnk09,cnk10,0,0,0,0,cnk12",
                      "  FROM cod_file,coc_file LEFT OUTER JOIN cnk_file ON coc_file.coc03=cnk_file.cnk01",
                      " WHERE coc01 = cod01 ",
                      "   AND cod03 = cnk02 ",
                      "   AND cnk03 =",l_yy,
                      "   AND cnk04 =",l_mm,
                      "   AND ",l_wc CLIPPED 
           #No.MOD-490398  --end   
       ELSE                  #材料
          LET g_sql = "SELECT '2',coc03,coe03,cnl05,cnl06,cnl07,cnl08,cnl09,",
                      "       cnl10,cnl11,cnl12,cnl13,cnl14,cnl15,cnl16,cnl17",
                      "  FROM coe_file,coc_file LEFT OUTER JOIN cnl_file ON coc_file.coc03 = cnl_file.cnl01",
                      " WHERE coc01 = coe01 ",
                      "   AND coe03 = cnl02 ",
                      "   AND cnl03 =",l_yy,
                      "   AND cnl04 =",l_mm,
                      "   AND ",g_wc CLIPPED 
       END IF
       PREPARE p510_p1 FROM g_sql
       IF SQLCA.SQLCODE THEN 
          CALL cl_err('Prepare p510_p1 error !',SQLCA.SQLCODE,1) 
          LET g_success = 'N' RETURN
       END IF
       DECLARE p510_c1 CURSOR WITH HOLD FOR p510_p1
 
       FOREACH p510_c1 INTO g_cnl.*
           IF STATUS THEN
              CALL cl_err('Foreach cnq_file error !',SQLCA.SQLCODE,1)
              LET g_success = 'N' RETURN
           END IF
#          DISPLAY g_cnl.cnl01 TO cnl01 #wonder?
#          DISPLAY g_cnl.cnl02 TO cnl02 #wonder?
           IF cl_null(g_cnl.cnl05)  THEN LET g_cnl.cnl05 =  0 END IF
           IF cl_null(g_cnl.cnl06)  THEN LET g_cnl.cnl06 =  0 END IF
           IF cl_null(g_cnl.cnl07)  THEN LET g_cnl.cnl07 =  0 END IF
           IF cl_null(g_cnl.cnl08)  THEN LET g_cnl.cnl08 =  0 END IF
           IF cl_null(g_cnl.cnl09)  THEN LET g_cnl.cnl09 =  0 END IF
           IF cl_null(g_cnl.cnl10)  THEN LET g_cnl.cnl10 =  0 END IF
           IF cl_null(g_cnl.cnl11)  THEN LET g_cnl.cnl11 =  0 END IF
           IF cl_null(g_cnl.cnl12)  THEN LET g_cnl.cnl12 =  0 END IF
           IF cl_null(g_cnl.cnl13)  THEN LET g_cnl.cnl13 =  0 END IF
           IF cl_null(g_cnl.cnl14)  THEN LET g_cnl.cnl14 =  0 END IF
           IF cl_null(g_cnl.cnl15)  THEN LET g_cnl.cnl15 =  0 END IF
           IF cl_null(g_cnl.cnl16)  THEN LET g_cnl.cnl16 =  0 END IF
           IF cl_null(g_cnl.cnl17)  THEN LET g_cnl.cnl17 =  0 END IF
           #No.MOD-590331  --begin                                              
           #OUTPUT TO REPORT p510_rep(g_cnl.*,0,'','0')  #No.MOD-490398         
           INSERT INTO p510_tmp_file VALUES(g_cnl.*,0,'','0')                   
           IF STATUS THEN                                                       
#             CALL cl_err('Insert tmp file error !',SQLCA.SQLCODE,1)             #No.TQC-660045
              CALL cl_err3("ins","p510_tmp_file",g_cnl.cnl01,g_cnl.cnl02,SQLCA.sqlcode,"","Insert tmp file error !",1) #TQC-660045
              LET g_success = 'N' RETURN                                        
           END IF                                                               
           #No.MOD-590331  --end
       END FOREACH
 
        #No.MOD-490398  --begin
       IF l_i = 1 THEN          #成品
          LET g_sql = "SELECT cnq_file.* ",   
                      "  FROM coc_file,cod_file,cnq_file",
                      " WHERE coc01 = cod01 AND coc03 = cnq01",
                      "   AND cod03 = cnq02 ",
                      "   AND cnq05 = '1'",
                      "   AND cnq04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                      "   AND ",l_wc CLIPPED 
       ELSE                              #材料
          LET g_sql = "SELECT cnq_file.* ",   
                      "  FROM coc_file,coe_file,cnq_file",
                      " WHERE coc01 = coe01 AND coc03 = cnq01",
                      "   AND coe03 = cnq02 ",
                      "   AND cnq05 = '2'",
                      "   AND cnq04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                      "   AND ",g_wc CLIPPED 
       END IF
        #No.MOD-490398  --end   
 
       PREPARE p510_p2 FROM g_sql
       IF SQLCA.SQLCODE THEN 
          CALL cl_err('Prepare p510_p2 error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'  RETURN  
       END IF
       DECLARE p510_c2 CURSOR WITH HOLD FOR p510_p2
       FOREACH p510_c2 INTO g_cnq.*
           IF STATUS THEN
              CALL cl_err('Foreach cnq_file error !',SQLCA.SQLCODE,1)
              LET g_success = 'N' RETURN
           END IF
           IF cl_null(g_cnq.cnq13) THEN LET g_cnq.cnq13 = 0 END IF
 
            IF l_i = '1' THEN       #成品  #No.MOD-490398
              CASE g_cnq.cnq06 
                WHEN '1'  #出口
                     LET l_chr = 'I' 
                     CASE g_cnq.cnq07
                       WHEN '1'  LET u_flag = 1                 #直接出口
                       WHEN '2'  LET u_flag = 4                 #轉廠出口
                       WHEN '4'  LET u_flag = 7                 #內銷出貨
                     END CASE
                WHEN '2'  #進口
                     LET l_chr = 'O' 
                     CASE g_cnq.cnq07
                       WHEN '1'  LET u_flag = 3                 #國外退貨
                       WHEN '2'  LET u_flag = 6                 #轉廠退貨
                       WHEN '4'  LET u_flag = 8                 #內銷退貨
                     END CASE
                 #No.MOD-490398  --begin
                #成品沒有報廢
                #WHEN '3'  #報廢
                #     LET l_chr = 'O' 
                #     IF g_cnq.cnq07 = '0' THEN LET u_flag = 12 END IF  #報廢
                 #No.MOD-490398  --end   
              END CASE
           ELSE                       #材料
              CASE g_cnq.cnq06 
                WHEN '1'  #出口
                     LET l_chr = 'O' 
                     CASE g_cnq.cnq07
                       WHEN '2'  LET u_flag = 6                 #轉廠退貨
                       WHEN '3'  LET u_flag = 3                 #國外退貨
                       WHEN '5'  LET u_flag = 10                #手冊轉出
                       WHEN '6'  LET u_flag = 8                 #內購退貨
                     END CASE
                WHEN '2'  #進口
                     LET l_chr = 'I' 
                     CASE g_cnq.cnq07
                       WHEN '1'  LET u_flag = 1                 #直接進口
                       WHEN '2'  LET u_flag = 4                 #轉廠進口
                       WHEN '5'  LET u_flag = 11                #手冊轉入
                       WHEN '6'  LET u_flag = 7                 #國內採購
                     END CASE
                WHEN '3'  #報廢
                     LET l_chr = 'O' 
                     IF g_cnq.cnq07 = '0' THEN LET u_flag = 12 END IF  #報廢
                WHEN '4'  #耗用
                     LET l_chr = 'O' 
                     CASE g_cnq.cnq07
                       WHEN '1'  LET u_flag = 2                 #直接耗用
                       WHEN '2'  LET u_flag = 5                 #轉廠耗用
                       WHEN '4'  LET u_flag = 9                 #內銷耗用
                     END CASE
              END CASE
           END IF
 
           #No.MOD-590331  --begin
           #OUTPUT TO REPORT p510_rep
           #          (l_i,g_cnq.cnq01,g_cnq.cnq02,0,0,0,0,0,0,0,0,0, #No.MOD-490398
           #          0,0,0,0,g_cnq.cnq13,l_chr,u_flag)
           INSERT INTO p510_tmp_file                                            
           VALUES(l_i,g_cnq.cnq01,g_cnq.cnq02,0,0,0,0,0,0,0,0,0,                
                  0,0,0,0,g_cnq.cnq13,l_chr,u_flag)                             
           IF STATUS THEN                                                       
#             CALL cl_err('Insert tmp file error !',SQLCA.SQLCODE,1)             #No.TQC-660045
              CALL cl_err3("ins","p510_tmp_file","","",SQLCA.sqlcode,"","Insert tmp file error !",1) #TQC-660045
              LET g_success = 'N' RETURN                                        
           END IF                                                               
           #No.MOD-590331  --end
       END FOREACH
   END FOR
 
   #No.MOD-590331  --begin                                                      
   DECLARE p510_tmp_cur CURSOR FOR                                              
    SELECT * FROM p510_tmp_file                                                 
     ORDER BY type,cnl01,cnl02                                                  
   FOREACH p510_tmp_cur INTO sr.*                                               
       IF STATUS THEN                                                           
          CALL cl_err('Foreach cnq_file error !',SQLCA.SQLCODE,1)               
          LET g_success = 'N' RETURN                                            
       END IF                                                                   
       OUTPUT TO REPORT p510_rep(sr.*)                                          
   END FOREACH                                                                  
   #No.MOD-590331  --end
   FINISH REPORT p510_rep
   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
REPORT p510_rep(sr)
DEFINE sr    RECORD
             type       LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)     #1.成品 2.材料
             cnl01      LIKE cnl_file.cnl01,          #手冊編號
             cnl02      LIKE cnl_file.cnl02,          #商品編號(材料/成品)
             cnl05      LIKE cnl_file.cnl05,          #直接進口/直接出口
             cnl06      LIKE cnl_file.cnl06,          #直接耗用/No use
             cnl07      LIKE cnl_file.cnl07,          #國外退貨
             cnl08      LIKE cnl_file.cnl08,          #轉廠進口/轉廠出口
             cnl09      LIKE cnl_file.cnl09,          #轉廠耗用/No use
             cnl10      LIKE cnl_file.cnl10,          #轉廠退貨/轉廠退貨
             cnl11      LIKE cnl_file.cnl11,          #國內採購/內銷出貨
             cnl12      LIKE cnl_file.cnl12,          #內購退貨/內銷退貨
             cnl13      LIKE cnl_file.cnl13,          #內銷耗用/No use
             cnl14      LIKE cnl_file.cnl14,          #手冊轉出/No use
             cnl15      LIKE cnl_file.cnl15,          #手冊轉入/No use
             cnl16      LIKE cnl_file.cnl16,          #報廢數量
             cnl17      LIKE cnl_file.cnl17,          #期末數量
             cnq13      LIKE cnq_file.cnq13,          #異動數量
             chr        LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)   #I:加項 O:減項
             u_flag     LIKE aba_file.aba18           # Prog. Version..: '5.30.06-13.03.12(02)   #No.MOD-490398
             END  RECORD
DEFINE last_cnl17     LIKE cnl_file.cnl17 
DEFINE l_cnl17        LIKE cnl_file.cnl17 
DEFINE l_year         LIKE cnl_file.cnl03 
DEFINE l_month        LIKE cnl_file.cnl04 
DEFINE l_cob02        LIKE cob_file.cob02
DEFINE l_cob021       LIKE cob_file.cob021
DEFINE l_cnl05,l_cnl06,l_cnl07,l_cnl08 LIKE cnl_file.cnl05
DEFINE l_cnl09,l_cnl10,l_cnl11,l_cnl12 LIKE cnl_file.cnl05
DEFINE l_cnl13,l_cnl14,l_cnl15,l_cnl16 LIKE cnl_file.cnl05
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.type, sr.cnl01, sr.cnl02 #No.MOD-590331
  FORMAT
   PAGE HEADER
      PRINT g_x[31],g_x[32],g_x[33],g_x[34]
      PRINT g_dash1
    BEFORE GROUP OF sr.cnl02
       #No.MOD-590331  --begin                                                  
       #BEGIN WORK                                                              
       #LET g_success = 'Y'                                                     
       #No.MOD-590331  --end
       LET l_cnl05 = 0 LET l_cnl06 = 0 LET l_cnl07 = 0 LET l_cnl08 = 0
       LET l_cnl09 = 0 LET l_cnl10 = 0 LET l_cnl11 = 0 LET l_cnl12 = 0
       LET l_cnl13 = 0 LET l_cnl14 = 0 LET l_cnl15 = 0 LET l_cnl16 = 0
       LET l_cnl17 = 0
       LET last_cnl17  = 0
 
    ON EVERY ROW 
        #No.MOD-490398  --begin
       #IF sr.chr = 'O' THEN LET sr.cnq13 = sr.cnq13 * -1 END IF
        #No.MOD-490398  --end    
       CASE WHEN sr.u_flag=1  LET l_cnl05 =l_cnl05 + sr.cnq13
            WHEN sr.u_flag=2  LET l_cnl06 =l_cnl06 + sr.cnq13
            WHEN sr.u_flag=3  LET l_cnl07 =l_cnl07 + sr.cnq13
            WHEN sr.u_flag=4  LET l_cnl08 =l_cnl08 + sr.cnq13
            WHEN sr.u_flag=5  LET l_cnl09 =l_cnl09 + sr.cnq13
            WHEN sr.u_flag=6  LET l_cnl10 =l_cnl10 + sr.cnq13
            WHEN sr.u_flag=7  LET l_cnl11 =l_cnl11 + sr.cnq13
            WHEN sr.u_flag=8  LET l_cnl12 =l_cnl12 + sr.cnq13
            WHEN sr.u_flag=9  LET l_cnl13 =l_cnl13 + sr.cnq13
            WHEN sr.u_flag=10 LET l_cnl14 =l_cnl14 + sr.cnq13
            WHEN sr.u_flag=11 LET l_cnl15 =l_cnl15 + sr.cnq13
            WHEN sr.u_flag=12 LET l_cnl16 =l_cnl16 + sr.cnq13
            OTHERWISE EXIT CASE
       END CASE
       LET l_cnl17 = l_cnl17 + sr.cnl17
       SELECT cob02,cob021 INTO l_cob02,l_cob021 FROM cob_file
       WHERE cob01=sr.cnl02
       IF SQLCA.sqlcode THEN 
          LET l_cob02 = ' ' 
          LET l_cob021 = ' ' 
       END IF
       PRINT COLUMN g_c[31],sr.cnl01,   #No.TQC-5C0047 
             COLUMN g_c[32],sr.cnl02    #No.TQC-5C0047
 
    AFTER GROUP OF sr.cnl02 
        #No.MOD-490398  --begin
       LET last_cnl17  = l_cnl17 + l_cnl05 - l_cnl06 - l_cnl07 +
                         l_cnl08 - l_cnl09 - l_cnl10 + l_cnl11 - 
                         l_cnl12 - l_cnl13 - l_cnl14 + l_cnl15 - l_cnl16
        #No.MOD-490398  --end   
       IF sr.type = '1' THEN       #成品
          DELETE FROM cnk_file WHERE cnk01 = sr.cnl01 AND cnk02 = sr.cnl02 
                                 AND cnk03 = yy       AND cnk04 = mm
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('Delete cnk_file error !',SQLCA.SQLCODE,1) #No.TQC-660045
             CALL cl_err3("del","cnk_file",sr.cnl01,sr.cnl02,SQLCA.sqlcode,"","Delete cnk_file error !",1) #TQC-660045
             LET g_success = 'N'
          END IF
          INSERT INTO cnk_file(cnk01,cnk02,cnk03,cnk04,cnk05,cnk06,
                               cnk07,cnk08,cnk09,cnk10,cnk11,cnk12,cnkplant,cnklegal)  #FUN-980002 add cnkplant,cnklegal
                        VALUES(sr.cnl01,sr.cnl02,yy,mm,l_cnl05,l_cnl07,
                                l_cnl08,l_cnl10,l_cnl11,l_cnl12,0, #No.MOD-490398
                               last_cnl17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal 
          IF SQLCA.SQLCODE THEN     
#            CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1) #No.TQC-660045
             CALL cl_err3("ins","cnk_file",sr.cnl01,sr.cnl02,SQLCA.sqlcode,"","Inset cnk_file error !",1) #TQC-660045
             LET g_success = 'N'
          END IF                 
       ELSE                        #材料
          DELETE FROM cnl_file WHERE cnl01 = sr.cnl01 AND cnl02 = sr.cnl02 
                                 AND cnl03 = yy       AND cnl04 = mm
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('Delete cnl_file error !',SQLCA.SQLCODE,1) #No.TQC-660045
             CALL cl_err3("del","cnl_file",sr.cnl01,sr.cnl02,SQLCA.sqlcode,"","Delete cnl_file error !",1) #TQC-660045
             LET g_success = 'N'
          END IF
          INSERT INTO cnl_file(cnl01,cnl02,cnl03,cnl04,cnl05,cnl06,
                               cnl07,cnl08,cnl09,cnl10,cnl11,cnl12,
                               cnl13,cnl14,cnl15,cnl16,cnl17,cnlplant,cnllegal)  #FUN-980002 add cnlplant,cnllegal
                        VALUES(sr.cnl01,sr.cnl02,yy,mm,l_cnl05,l_cnl06,
                               l_cnl07,l_cnl08,l_cnl09,l_cnl10,l_cnl11,
                               l_cnl12,l_cnl13,l_cnl14,l_cnl15,l_cnl16,
                               last_cnl17,g_plant,g_legal)  #FUN-980002 add g_plant,g_legal 
          IF SQLCA.SQLCODE THEN     
#            CALL cl_err('Insert cnl_file error !',SQLCA.SQLCODE,1) #No.TQC-660045
             CALL cl_err3("ins","cnl_file",sr.cnl01,sr.cnl02,SQLCA.sqlcode,"","Insert cnl_file error !",1) #TQC-660045
             LET g_success = 'N'
          END IF                 
       END IF
       #No.MOD-590331  --begin                                                  
       #IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF           
       #No.MOD-590331  --end
END REPORT 
