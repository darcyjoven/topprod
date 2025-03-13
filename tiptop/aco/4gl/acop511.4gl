# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acop511.4gl
# Descriptions...: 材料/成品進出口每日異動統計量計算作業
# Date & Author..: 05/03/29 BY ice 
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# MOdify.........: No.TQC-660045 06/06/14 By hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE dd1              LIKE cnf_file.cnf03,
       dd2              LIKE type_file.dat,          #No.FUN-680069 DATE
       g_sql            STRING,  #No.FUN-580092 HCN  #No.FUN-680069
       g_wc             STRING,  #No.FUN-580092 HCN  #No.FUN-680069
       g_cnf RECORD     
             type       LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)  #1.成品 2.材料
             cnf01      LIKE cnf_file.cnf01,          #手冊編號
             cnf02      LIKE cnf_file.cnf02,          #商品編號(材料/成品)
             cnf05      LIKE cnf_file.cnf05,          #本日直接進口數量
             cnf06      LIKE cnf_file.cnf06,          #本日直接耗用數量
             cnf07      LIKE cnf_file.cnf07,          #本日國外退貨數量
             cnf08      LIKE cnf_file.cnf08,          #本日轉廠進口數量
             cnf09      LIKE cnf_file.cnf09,          #本日轉廠耗用數量
             cnf10      LIKE cnf_file.cnf10,          #本日轉廠退貨數量
             cnf11      LIKE cnf_file.cnf11,          #本日國內采購數量
             cnf12      LIKE cnf_file.cnf12,          #本日內購退貨數量
             cnf13      LIKE cnf_file.cnf13,          #本日內銷耗用數量
             cnf14      LIKE cnf_file.cnf14,          #本日手冊轉出數量
             cnf15      LIKE cnf_file.cnf15,          #本日手冊轉入數量
             cnf16      LIKE cnf_file.cnf16,          #本日報廢數量
             cnf17      LIKE cnf_file.cnf17           #本日結余數量
             END RECORD,
       g_cnx RECORD
             cnx01      LIKE cnf_file.cnf02,       #No.FUN-680069 VARCHAR(15)
             cnx02      LIKE cnf_file.cnf01        #No.FUN-680069 VARCHAR(15)
             END RECORD,
       g_cnq RECORD LIKE cnq_file.*,
       u_flag           LIKE aba_file.aba18,       #No.FUN-680069 VARCHAR(02)
#       p_row,p_col	LIKE type_file.num5        #NO.FUN-570116 MARK        #No.FUN-680069 SMALLINT
       g_change_lang    LIKE type_file.chr1        #No.FUN-680069 HAR(1)
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0063
   DEFINE   l_flag   LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
   DEFINE   ls_date  STRING                        #No.FUN-570116
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
  #No.FUN-570116--start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET g_wc     = ARG_VAL(1)
  LET ls_date  = ARG_VAL(2)
  LET dd1      = cl_batch_bg_date_convert(ls_date)
  LET ls_date  = ARG_VAL(3)
  LET dd2      = cl_batch_bg_date_convert(ls_date)
  LET g_bgjob  = ARG_VAL(4)
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
 
 
#NO.FUN-570116 start---
#   LET p_row = 4 LET p_col = 10
#   OPEN WINDOW p511_w AT p_row,p_col
#        WITH FORM "aco/42f/acop511"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN EXIT WHILE END IF
      IF g_bgjob="N" THEN
          CALL p511_cs()
#          IF g_action_choice = "locale" THEN
#             LET g_action_choice = ""
#             CALL cl_dynamic_locale()
#             CALL cl_show_fld_cont()   #FUN-550037(smin)
#             CONTINUE WHILE
#          END IF
#          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
          IF cl_sure(20,20) THEN
             CALL p511()
             IF g_success='Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING l_flag        
             ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
             END IF 
        
             IF l_flag THEN
                 CONTINUE WHILE
             ELSE
                 CLOSE WINDOW p511_w  #NO.FUN-570116 ADD
                 EXIT WHILE
             END IF
          ELSE
             CONTINUE WHILE  #NO.FUN-570116 
             #EXIT WHILE
          END IF
      ELSE
          LET g_success='Y'
          CALL p511()
          IF g_success="Y" THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
      END IF
 END WHILE
 # No.FUN-570116--end--
 
#   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#   CLOSE WINDOW p511_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p511_cs()
   DEFINE c             LIKE qcs_file.qcs03         #No.FUN-680069 VARCHAR(10)
   DEFINE lc_cmd        LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500) #No.FUN-570116
   DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-570116 #No.FUN-680069 SMALLINT
 
   #No.FUN-570116--start--
   LET p_row = 4  LET p_col = 10
   OPEN WINDOW p511_w AT p_row,p_col WITH FORM "aco/42f/acop511"
        ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   CLEAR FORM
   #No.FUN-570116--end--
 
   WHILE TRUE   #No.FUN-570116
   CONSTRUCT BY NAME g_wc ON coc03,coe03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
  
      ON ACTION locale
         #LET g_action_choice = "locale"   #NO.FUN-570116
         LET g_change_lang=TRUE            #No.FUN-570116
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
           CLOSE WINDOW p511_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
           EXIT PROGRAM
     END IF
 
#   IF g_action_choice = "locale" THEN RETURN  END IF
#   IF INT_FLAG THEN RETURN END IF
#No.FUN-570116--end--
 
   LET dd1 = g_today
   LET dd2 = g_today
   LET g_bgjob = "N"         #No.FUN-570116
   #INPUT BY NAME dd1,dd2 WITHOUT DEFAULTS 
   INPUT BY NAME dd1,dd2,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570116
      AFTER FIELD dd2
         IF dd2 <  dd1  THEN
            NEXT FIELD dd2
         END IF
      AFTER INPUT 
         IF cl_null(dd1) THEN NEXT FIELD dd1 END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION locale
         LET g_change_lang = TRUE       #No.FUN-570116
#         LET g_action_choice = "locale" #NO.FUN-570116 
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
            CLOSE WINDOW p511_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
            EXIT PROGRAM
      END IF
 
  #IF g_action_choice = "locale" THEN RETURN END IF
  #IF INT_FLAG THEN RETURN END IF
  #No.FUN-570116--end--
 
  #No.FUN-570116--start--
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acop511"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acop511','9031',1)
        ELSE
         LET g_wc = cl_replace_str(g_wc,"'","\"")
         LET lc_cmd = lc_cmd    CLIPPED,
                   " '",g_wc    CLIPPED,"'",
                   " '",dd1     CLIPPED,"'",
                   " '",dd2     CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop511',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p511_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
   EXIT WHILE
 END WHILE
 #No.FUN-570116--end---
 
END FUNCTION
 
FUNCTION p511()
   DEFINE l_sql       LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(1200)
   DEFINE l_dd1       LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE yy,mm,l_yy,l_mm LIKE type_file.num10    #No.FUN-680069 INTEGER
   DEFINE l_name      LIKE type_file.chr20        #No.FUN-680069 VARCHAR(20)
   DEFINE l_chr       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
   DEFINE l_i,l_j     LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_wc        LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(300)
   DEFINE l_cnf01     LIKE cnf_file.cnf01         #No.FUN-680069 VARCHAR(15)
   DEFINE l_cnf02     LIKE cnf_file.cnf02         #No.FUN-680069 VARCHAR(15)
   DEFINE l_cnf05,l_cnf06,l_cnf07,l_cnf08 LIKE cnf_file.cnf05                      
   DEFINE l_cnf09,l_cnf10,l_cnf11,l_cnf12 LIKE cnf_file.cnf05                      
   DEFINE l_cnf13,l_cnf14,l_cnf15,l_cnf16 LIKE cnf_file.cnf05  
   DEFINE last_cnf17  LIKE cnf_file.cnf17 
   DEFINE l_cnf17     LIKE cnf_file.cnf17 
   DEFINE l_cnx_count LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_cnw_count LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_mindate   LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_maxdate   LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_bdate     LIKE type_file.dat          #No.FUN-680069 DATE                   
   DEFINE l_edate     LIKE type_file.dat          #No.FUN-680069 DATE                                                 
   DEFINE l_correct   LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
   DEFINE l_cnt       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
   LET l_mindate = dd1
   LET l_maxdate = dd2
   LET l_cnt = 0
   WHILE (l_mindate <= l_maxdate)
      LET g_success = 'Y'
      LET l_dd1 = dd1-1
      LET yy = YEAR(dd1)
      LET mm = MONTH(dd1) 
  
      LET l_i = 0
      FOR l_i = 1 TO 2
         DROP TABLE p511_cnf 
#No.FUN-680069-begin                                                         
         CREATE TEMP TABLE p511_cnf(                                                   
                type       LIKE type_file.chr1,  
                cnf01      LIKE cnf_file.cnf01,
                cnf02      LIKE cnf_file.cnf02,
                cnf05      LIKE cnf_file.cnf05,
                cnf06      LIKE cnf_file.cnf06,
                cnf07      LIKE cnf_file.cnf07,
                cnf08      LIKE cnf_file.cnf08,
                cnf09      LIKE cnf_file.cnf09,
                cnf10      LIKE cnf_file.cnf10,
                cnf11      LIKE cnf_file.cnf11,
                cnf12      LIKE cnf_file.cnf12,
                cnf13      LIKE cnf_file.cnf13,
                cnf14      LIKE cnf_file.cnf14,
                cnf15      LIKE cnf_file.cnf15,
                cnf16      LIKE cnf_file.cnf16,
                cnf17      LIKE cnf_file.cnf17,
                cnq13      LIKE cnq_file.cnq13,
                chr        LIKE type_file.chr1,  
                u_flag     LIKE aba_file.aba18)
#No.FUN-680069-end
        IF l_i = 1 THEN  
           LET l_wc = g_wc
           FOR l_j = 1 TO 296
              IF l_wc[l_j,l_j+4] = 'coe03' THEN 
                 LET l_wc[l_j,l_j+4] = 'cod03'
              END IF
            END FOR
            LET g_sql = "SELECT DISTINCT cod03,coc03 FROM cod_file,coc_file  ",
                        " WHERE coc01 = cod01    ",
                        "   AND ",l_wc CLIPPED 
            PREPARE p511_cod FROM g_sql 
            IF SQLCA.SQLCODE THEN                                          
               CALL cl_err('Prepare p511_cod error !',SQLCA.SQLCODE,1)  
               LET g_success = 'N' RETURN                                   
            END IF                                                          
            DECLARE p511_pod CURSOR WITH HOLD FOR p511_cod
            FOREACH p511_pod INTO g_cnx.*  
               IF STATUS THEN                                                  
                  CALL cl_err('Foreach cnd_file error !',SQLCA.SQLCODE,1) 
                  LET g_success = 'N' RETURN              
               END IF
               SELECT cne12 INTO g_cnf.cnf17 FROM cne_file
                WHERE cne02 = g_cnx.cnx01 AND cne01 = g_cnx.cnx02
                  AND cne03 = l_dd1
               IF cl_null(g_cnf.cnf05)  THEN LET g_cnf.cnf05 =  0 END IF   
               IF cl_null(g_cnf.cnf06)  THEN LET g_cnf.cnf06 =  0 END IF 
               IF cl_null(g_cnf.cnf07)  THEN LET g_cnf.cnf07 =  0 END IF     
               IF cl_null(g_cnf.cnf08)  THEN LET g_cnf.cnf08 =  0 END IF    
               IF cl_null(g_cnf.cnf09)  THEN LET g_cnf.cnf09 =  0 END IF     
               IF cl_null(g_cnf.cnf10)  THEN LET g_cnf.cnf10 =  0 END IF   
               IF cl_null(g_cnf.cnf11)  THEN LET g_cnf.cnf11 =  0 END IF    
               IF cl_null(g_cnf.cnf12)  THEN LET g_cnf.cnf12 =  0 END IF    
               IF cl_null(g_cnf.cnf13)  THEN LET g_cnf.cnf13 =  0 END IF    
               IF cl_null(g_cnf.cnf14)  THEN LET g_cnf.cnf14 =  0 END IF     
               IF cl_null(g_cnf.cnf15)  THEN LET g_cnf.cnf15 =  0 END IF      
               IF cl_null(g_cnf.cnf16)  THEN LET g_cnf.cnf16 =  0 END IF       
               IF cl_null(g_cnf.cnf17)  THEN LET g_cnf.cnf17 =  0 END IF      
               INSERT INTO p511_cnf VALUES('1',g_cnx.cnx02,g_cnx.cnx01,  
                                            g_cnf.cnf05,g_cnf.cnf06,g_cnf.cnf07,
                                            g_cnf.cnf08,g_cnf.cnf09,g_cnf.cnf10,
                                            g_cnf.cnf11,g_cnf.cnf12,g_cnf.cnf13,
                                            g_cnf.cnf14,g_cnf.cnf15,g_cnf.cnf16,
                                            g_cnf.cnf17,0,'I',0)   
               IF SQLCA.SQLCODE THEN                                                 
#                 CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                  CALL cl_err3("ins","p511_cnf","","",SQLCA.sqlcode,"","Insert cnk_file error !",1) #TQC-660045
                  LET g_success = 'N'                                                
               END IF
               END FOREACH
               LET g_sql = "SELECT cnq_file.* ",                                   
                           "  FROM coc_file,cod_file,cnq_file",                    
                           " WHERE coc01 = cod01 AND coc03 = cnq01",               
                           "   AND cod03 = cnq02 ",                                
                           "   AND cnq05 = '1'",                                   
                           "   AND cnq04 = '",dd1,"'",                              
                           "   AND ",l_wc CLIPPED  
               PREPARE p511_p2 FROM g_sql                                             
               IF SQLCA.SQLCODE THEN                                                  
                  CALL cl_err('Prepare p511_p2 error !',SQLCA.SQLCODE,1)              
                  LET g_success = 'N'  RETURN                                         
               END IF                                                                 
               DECLARE p511_c2 CURSOR WITH HOLD FOR p511_p2                           
               FOREACH p511_c2 INTO g_cnq.*                                           
               LET l_cnf05 = 0                                                    
               LET l_cnf06 = 0                                                    
               LET l_cnf07 = 0                                                    
               LET l_cnf08 = 0                                                    
               LET l_cnf09 = 0                                                    
               LET l_cnf10 = 0                                                    
               LET l_cnf11 = 0                                                    
               LET l_cnf12 = 0                                                    
               LET l_cnf13 = 0                                                    
               LET l_cnf14 = 0                                                    
               LET l_cnf15 = 0                                                    
               LET l_cnf16 = 0                                                    
               LET l_cnf17 = 0 
               LET last_cnf17  = 0                                                
               IF STATUS THEN                                                     
                  CALL cl_err('Foreach cnq_file error !',SQLCA.SQLCODE,1)         
                  LET g_success = 'N' RETURN                                      
               END IF                                                             
               IF cl_null(g_cnq.cnq13) THEN LET g_cnq.cnq13 = 0 END IF 
               CASE g_cnq.cnq06                                                
                  WHEN '1'  #出口                                               
                     LET l_chr = 'I'                                          
                     CASE g_cnq.cnq07                                         
                        WHEN '1'  LET l_cnf05 = g_cnq.cnq13         #直接出口  
                        WHEN '2'  LET l_cnf08 = g_cnq.cnq13         #轉廠出口  
                        WHEN '4'  LET l_cnf11 = g_cnq.cnq13         #內銷出貨  
                     END CASE                                                 
                  WHEN '2'  #進口                                               
                     LET l_chr = 'O'                                          
                     CASE g_cnq.cnq07                                         
                        WHEN '1'  LET l_cnf07 = g_cnq.cnq13         #國外退貨  
                        WHEN '2'  LET l_cnf10 = g_cnq.cnq13         #轉廠退貨  
                        WHEN '4'  LET l_cnf12 = g_cnq.cnq13         #內銷退貨  
                     END CASE                                                 
               END CASE
               INSERT INTO p511_cnf VALUES(g_cnq.cnq05,g_cnq.cnq01,g_cnq.cnq02,l_cnf05,l_cnf06,
                      l_cnf07,l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,l_cnf13, 
                      l_cnf14,l_cnf15,l_cnf16,l_cnf17,g_cnq.cnq13,l_chr,u_flag)
               END FOREACH                                                            
               LET g_sql = "SELECT cnf01,cnf02,type,SUM(cnf05),SUM(cnf06),SUM(cnf07), ",
                           "       SUM(cnf08),SUM(cnf09),SUM(cnf10),SUM(cnf11),  ",   
                           "       SUM(cnf12),SUM(cnf13),SUM(cnf14),SUM(cnf15),  ",   
                           "       SUM(cnf16),SUM(cnf17)                      ",      
                           "  FROM p511_cnf    ",                                     
                           " GROUP BY cnf01,cnf02,type "                              
               PREPARE p511_p3 FROM g_sql                                             
               IF SQLCA.SQLCODE THEN                                                  
                  CALL cl_err('Prepare p511_p3 error !',SQLCA.SQLCODE,1)              
                  LET g_success = 'N'  RETURN                                        
               END IF
               DECLARE p511_c3 CURSOR FOR p511_p3                                     
               FOREACH p511_c3 INTO l_cnf01,l_cnf02,l_i,l_cnf05,l_cnf06,l_cnf07,      
                                    l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,l_cnf13,  
                                    l_cnf14,l_cnf15,l_cnf16,l_cnf17 
                  IF SQLCA.sqlcode THEN                                               
                     CALL cl_err('p511_c3',SQLCA.sqlcode,0)                           
                     EXIT FOREACH                                                     
                  END IF                                                              
                  LET last_cnf17  = l_cnf17 + l_cnf05 - l_cnf06 - l_cnf07 +                     
                                    l_cnf08 - l_cnf09 - l_cnf10 + l_cnf11 -           
                                    l_cnf12 - l_cnf13 - l_cnf14 + l_cnf15 - l_cnf16 
                  DELETE FROM cne_file WHERE cne01 = l_cnf01 AND cne02 = l_cnf02   
                                      AND cne03 = dd1                               
                  IF SQLCA.SQLCODE THEN                                            
#                    CALL cl_err('Delete cne_file error !',SQLCA.SQLCODE,1)         #No.TQC-660045
                     CALL cl_err3("del","cne_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Delete cne_file error !",1) #TQC-660045       
                     LET g_success = 'N'                                           
                  END IF                                                           
                  INSERT INTO cne_file(cne01,cne02,cne03,cne05,cne06,              
	                    		cne07,cne08,cne09,cne10,cne12,cneplant,cnelegal)  #FUN-980002 add cneplant,cnelegal              
				 VALUES(l_cnf01,l_cnf02,dd1,l_cnf05,l_cnf07,         
					l_cnf08,l_cnf10,l_cnf11,l_cnf12,last_cnf17,g_plant,g_legal)  #FUN-980002 add g_plant,g_legal
	          IF SQLCA.SQLCODE THEN                                
#                    CALL cl_err('Insert cne_file error !',SQLCA.SQLCODE,1)         #No.TQC-660045
       	             CALL cl_err3("ins","cne_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cne_file error !",1) #TQC-660045
       	             LET g_success = 'N'                                           
	          END IF
                  SELECT count(*) INTO l_cnt FROM cnx_file
		   WHERE cnx01 = l_cnf02 AND cnx02 = l_cnf01
                     AND cnx03 = yy AND cnx04 = mm
                     AND cnxconf = 'Y' 
                  CALL s_azm(yy,mm)      #得出期間的起始日與截止日 
                       RETURNING l_correct, l_bdate, l_edate
                  IF  dd1 = l_edate THEN
                     DELETE FROM cnk_file WHERE cnk01 = l_cnf01 AND cnk02 = l_cnf02   
                                                AND cnk03 = yy AND cnk04 = mm
                     IF SQLCA.SQLCODE THEN                                            
#                       CALL cl_err('Delete cnk_file error !',SQLCA.SQLCODE,1)         #No.TQC-660045
                        CALL cl_err3("del","cnk_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Delete cnk_file error !",1) #TQC-660045
                        LET g_success = 'N'                                           
                     END IF 
                     IF l_cnt THEN
                        SELECT cnx06,cnx07,cnx08,(cnx06+cnx07+cnx08) 
                          INTO l_cnf05,l_cnf08,l_cnf11,last_cnf17
                          FROM cnx_file 
                         WHERE cnx01 = l_cnf02 AND cnx02 = l_cnf01 
                           AND cnx03 = yy AND cnx04 = mm
                           AND cnxconf = 'Y'
                        UPDATE cne_file SET cne05 = l_cnf05,
                                            cne06 = 0,              
   		                 	    cne07 = l_cnf08,
			                    cne08 = 0,
                   	                    cne09 = l_cnf11,
				            cne10 = 0,
				            cne12 = last_cnf17
   		          WHERE cne01 = l_cnf01 AND cne02 = l_cnf02 
   		            AND cne03 = dd1 
   	   	         IF SQLCA.SQLCODE THEN                                                 
#                           CALL cl_err('Update cnf_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                            CALL cl_err3("upd","cne_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Update cne_file error !",1) #TQC-660045  
                            LET g_success = 'N'  
                         END IF
                         INSERT INTO cnk_file(cnk01,cnk02,cnk03,cnk04,cnk05,cnk06,              
                                              cnk07,cnk08,cnk09,cnk10,cnk12,cnkplant,cnklegal) #FUN-980002 add cnkplant,cnklegal
   				 VALUES(l_cnf01,l_cnf02,yy,mm,l_cnf05,0,         
   					l_cnf08,0,l_cnf11,0,last_cnf17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
   	   	         IF SQLCA.SQLCODE THEN                                                 
#                           CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                            CALL cl_err3("ins","cnk_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cnk_file error !",1) #TQC-660045
                            LET g_success = 'N'  
                         END IF
                      ELSE
                         SELECT SUM(cne05),SUM(cne06),SUM(cne07),SUM(cne08),SUM(cne09),SUM(cne10)
                           INTO l_cnf05,l_cnf07,l_cnf08,l_cnf10,l_cnf11,l_cnf12
                           FROM cne_file
                          WHERE cne01 = l_cnf01 AND cne02 = l_cnf02
                            AND cne03 BETWEEN l_bdate AND dd1
                         SELECT cne12 INTO last_cnf17     
                           FROM cne_file
                          WHERE cne01 = l_cnf01 AND cne02 = l_cnf02
                            AND cne03 = dd1                                                             
                         INSERT INTO cnk_file(cnk01,cnk02,cnk03,cnk04,cnk05,cnk06,              
                                              cnk07,cnk08,cnk09,cnk10,cnk12,cnkplant,cnklegal) #FUN-980002 add cnkplant,cnklegal
   				 VALUES(l_cnf01,l_cnf02,yy,mm,l_cnf05,l_cnf07,         
   					l_cnf08,l_cnf10,l_cnf11,l_cnf12,last_cnf17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal 
      	                 IF SQLCA.SQLCODE THEN                                            
#  	                    CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1)         #No.TQC-660045
                            CALL cl_err3("ins","cnk_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cnk_file error !",1) #TQC-660045
          	            LET g_success = 'N'                                           
                         END IF
		      END IF 
		   END IF
                   LET l_cnt = 0
		END FOREACH
	     ELSE                  #材料
		LET g_sql = "SELECT DISTINCT coe03,coc03 FROM coe_file,coc_file  ",         
			    " WHERE coc01 = coe01    ",                            
			    "   AND ",g_wc CLIPPED                                 
	     PREPARE p511_coe FROM g_sql                                       
	     IF SQLCA.SQLCODE THEN                                              
		CALL cl_err('Prepare p511coe error !',SQLCA.SQLCODE,1)         
		LET g_success = 'N' RETURN                                      
	     END IF                                                             
	     DECLARE p511_poe CURSOR WITH HOLD FOR p511_coe                     
	     FOREACH p511_poe INTO g_cnx.*
		IF STATUS THEN                                                  
		   CALL cl_err('Foreach cnd_file error !',SQLCA.SQLCODE,1)      
		   LET g_success = 'N' RETURN                                   
		END IF                                                          
	        SELECT cnf17 INTO g_cnf.cnf17 FROM cnf_file                  
	         WHERE cnf02 = g_cnx.cnx01 AND cnf01 = g_cnx.cnx02           
	       	   AND cnf03 = l_dd1                                          
                IF cl_null(g_cnf.cnf05)  THEN LET g_cnf.cnf05 =  0 END IF          
	        IF cl_null(g_cnf.cnf06)  THEN LET g_cnf.cnf06 =  0 END IF          
	        IF cl_null(g_cnf.cnf07)  THEN LET g_cnf.cnf07 =  0 END IF          
	        IF cl_null(g_cnf.cnf08)  THEN LET g_cnf.cnf08 =  0 END IF          
	        IF cl_null(g_cnf.cnf09)  THEN LET g_cnf.cnf09 =  0 END IF          
	        IF cl_null(g_cnf.cnf10)  THEN LET g_cnf.cnf10 =  0 END IF          
                IF cl_null(g_cnf.cnf11)  THEN LET g_cnf.cnf11 =  0 END IF          
 	        IF cl_null(g_cnf.cnf12)  THEN LET g_cnf.cnf12 =  0 END IF 
 	        IF cl_null(g_cnf.cnf13)  THEN LET g_cnf.cnf13 =  0 END IF          
 	        IF cl_null(g_cnf.cnf14)  THEN LET g_cnf.cnf14 =  0 END IF          
 	        IF cl_null(g_cnf.cnf15)  THEN LET g_cnf.cnf15 =  0 END IF          
	        IF cl_null(g_cnf.cnf16)  THEN LET g_cnf.cnf16 =  0 END IF          
	        IF cl_null(g_cnf.cnf17)  THEN LET g_cnf.cnf17 =  0 END IF          
	 
	        INSERT INTO p511_cnf VALUES('2',g_cnx.cnx02,g_cnx.cnx01,  
	               			    g_cnf.cnf05,g_cnf.cnf06,g_cnf.cnf07,
			          	    g_cnf.cnf08,g_cnf.cnf09,g_cnf.cnf10,
				            g_cnf.cnf11,g_cnf.cnf12,g_cnf.cnf13,
	           			    g_cnf.cnf14,g_cnf.cnf15,g_cnf.cnf16,
			          	    g_cnf.cnf17,0,'I',0)
                IF SQLCA.SQLCODE THEN                                                 
#                  CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                   CALL cl_err3("ins","p511_cnf","","",SQLCA.sqlcode,"","Insert cnk_file error !",1) #TQC-660045
                   LET g_success = 'N'                                                
                END IF
	     END FOREACH
	     LET g_sql = "SELECT cnq_file.* ",   
			"  FROM coc_file,coe_file,cnq_file",
			" WHERE coc01 = coe01 AND coc03 = cnq01",
			"   AND coe03 = cnq02 ",
			"   AND cnq05 = '2'",
			"   AND cnq04 = '",dd1,"'",
			"   AND ",g_wc CLIPPED 
	     PREPARE p511_p4 FROM g_sql
	     IF SQLCA.SQLCODE THEN 
	        CALL cl_err('Prepare p511_p4 error !',SQLCA.SQLCODE,1)
	        LET g_success = 'N'  RETURN  
             END IF
	     DECLARE p511_c4 CURSOR WITH HOLD FOR p511_p4
       	     FOREACH p511_c4 INTO g_cnq.*
 	        LET l_cnf05 = 0                                                           
	        LET l_cnf06 = 0                                                           
	        LET l_cnf07 = 0                                                           
 	        LET l_cnf08 = 0                                                           
	        LET l_cnf09 = 0                                                           
	        LET l_cnf10 = 0                                                           
	        LET l_cnf11 = 0                                                           
	        LET l_cnf12 = 0                                                           
	        LET l_cnf13 = 0                                                           
	        LET l_cnf14 = 0                                                           
  	        LET l_cnf15 = 0                                                           
  	        LET l_cnf16 = 0                                                           
 	        LET l_cnf17 = 0                                                           
 	        LET last_cnf17  = 0
	        IF STATUS THEN
		   CALL cl_err('Foreach cnq_file error !',SQLCA.SQLCODE,1)
		   LET g_success = 'N' RETURN
       	        END IF
	        IF cl_null(g_cnq.cnq13) THEN LET g_cnq.cnq13 = 0 END IF
 
                CASE g_cnq.cnq06 
	       	   WHEN '1'  #出口
	 	      LET l_chr = 'O' 
		      CASE g_cnq.cnq07
	        	 WHEN '2'  LET l_cnf10 = g_cnq.cnq13          #轉廠退貨
       	                 WHEN '3'  LET l_cnf07 = g_cnq.cnq13          #國外退貨
	                 WHEN '5'  LET l_cnf14 = g_cnq.cnq13          #手冊轉出
	 	         WHEN '6'  LET l_cnf12 = g_cnq.cnq13          #內購退貨
	              END CASE
	 	   WHEN '2'  #進口
	 	      LET l_chr = 'I' 
	 	      CASE g_cnq.cnq07
	 	   	WHEN '1'  LET l_cnf05 = g_cnq.cnq13           #直接進口
	 	  	WHEN '2'  LET l_cnf08 = g_cnq.cnq13           #轉廠進口
	 	  	WHEN '5'  LET l_cnf15 = g_cnq.cnq13           #手冊轉入
	  	 		WHEN '6'  LET l_cnf11 = g_cnq.cnq13           #國內採購
		      END CASE
		   WHEN '3'  #報廢
		      LET l_chr = 'O' 
		     IF g_cnq.cnq07 = '0' THEN LET l_cnf16 = g_cnq.cnq13 END IF  #報廢
		  WHEN '4'  #耗用
		     LET l_chr = 'O' 
		     CASE g_cnq.cnq07
			WHEN '1'  LET l_cnf06 = g_cnq.cnq13                 #直接耗用
			WHEN '2'  LET l_cnf09 = g_cnq.cnq13                 #轉廠耗用
			WHEN '4'  LET l_cnf13 = g_cnq.cnq13                 #內銷耗用
		     END CASE
		      END CASE
	
	       INSERT INTO p511_cnf VALUES(g_cnq.cnq05,g_cnq.cnq01,g_cnq.cnq02,l_cnf05,l_cnf06,
		      l_cnf07,l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,l_cnf13,
		      l_cnf14,l_cnf15,l_cnf16,l_cnf17,g_cnq.cnq13,l_chr,u_flag)
	    END FOREACH
	    LET g_sql = "SELECT cnf01,cnf02,type,SUM(cnf05),SUM(cnf06),SUM(cnf07), ",
			"       SUM(cnf08),SUM(cnf09),SUM(cnf10),SUM(cnf11),  ",
			"       SUM(cnf12),SUM(cnf13),SUM(cnf14),SUM(cnf15),  ",
			"       SUM(cnf16),SUM(cnf17)                      ",
			"  FROM p511_cnf    ",
			" GROUP BY cnf01,cnf02,type  "
           PREPARE p511_p5 FROM g_sql
           IF SQLCA.SQLCODE THEN                                                    
              CALL cl_err('Prepare p511_p5 error !',SQLCA.SQLCODE,1)                
              LET g_success = 'N'  RETURN                                           
           END IF                                                                   
           DECLARE p511_c5 CURSOR FOR p511_p5
           FOREACH p511_c5 INTO l_cnf01,l_cnf02,l_i,l_cnf05,l_cnf06,l_cnf07,
                                l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,l_cnf13,
                                l_cnf14,l_cnf15,l_cnf16,l_cnf17
              IF SQLCA.sqlcode THEN                                                      
                 CALL cl_err('p511_c5',SQLCA.sqlcode,0)                             
                 EXIT FOREACH
              END IF 
              LET last_cnf17  = l_cnf17 + l_cnf05 - l_cnf06 - l_cnf07 +                
                                l_cnf08 - l_cnf09 - l_cnf10 + l_cnf11 -                
                                l_cnf12 - l_cnf13 - l_cnf14 + l_cnf15 - l_cnf16
              DELETE FROM cnf_file WHERE cnf01 = l_cnf01 AND cnf02 = l_cnf02      
                                    AND cnf03 = dd1                                 
              IF SQLCA.SQLCODE THEN                                                 
#                CALL cl_err('Delete cnf_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                 CALL cl_err3("del","cnf_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Delete cnf_file error !",1) #TQC-660045
                 LET g_success = 'N'                                                
              END IF
              INSERT INTO cnf_file(cnf01,cnf02,cnf03,cnf05,cnf06,cnf07,
                                   cnf08,cnf09,cnf10,cnf11,cnf12,cnf13,
                                   cnf14,cnf15,cnf16,cnf17,cnfplant,cnflegal) #FUN-980002 add cnfplant,cnflegal
                            VALUES(l_cnf01,l_cnf02,dd1,l_cnf05,l_cnf06,l_cnf07,
                                   l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,
                                   l_cnf13,l_cnf14,l_cnf15,l_cnf16,last_cnf17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
              IF SQLCA.SQLCODE THEN                                                 
#                CALL cl_err('Insert cnk_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                 CALL cl_err3("ins","cnf_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cnk_file error !",1) #TQC-660045
                 LET g_success = 'N'                                                
              END IF
              SELECT count(*) INTO l_cnt FROM cnw_file
	       WHERE cnw01 = l_cnf02 AND cnw02 = l_cnf01
                 AND cnw03 = yy AND cnw04 = mm
                 AND cnwconf = 'Y' 
              CALL s_azm(yy,mm)  
                   RETURNING l_correct, l_bdate, l_edate
              IF dd1 = l_edate THEN
                 DELETE FROM cnl_file WHERE cnl01 = l_cnf01 AND cnl02 = l_cnf02
                                           AND cnl03 = yy AND cnl04 = mm      
                 IF SQLCA.SQLCODE THEN                                      
#                   CALL cl_err('Delete cnl_file error !',SQLCA.SQLCODE,1)   #No.TQC-660045
                    CALL cl_err3("del","cnl_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Delete cnl_file error !",1) #TQC-660045
                    LET g_success = 'N'                                     
                 END IF
                 IF l_cnt THEN
                    SELECT cnw07,cnw08,cnw09,cnw10,cnw11,cnw12,
                           cnw06,cnw13,(cnw07-cnw08+cnw09-cnw10+cnw11-cnw12+cnw06-cnw13) 
                      INTO l_cnf05,l_cnf06,l_cnf08,l_cnf09,l_cnf11,l_cnf12,
                           l_cnf15,l_cnf16,last_cnf17
	              FROM cnw_file                                              
	             WHERE cnw01 = l_cnf02 AND cnw02 = l_cnf01           
        	       AND cnw03 = yy AND cnw04 = mm                         
       	               AND cnwconf = 'Y'
                   UPDATE cnf_file SET cnf05 = l_cnf05,
                                       cnf06 = l_cnf06,              
  		              	       cnf07 = 0,
     				       cnf08 = l_cnf08,
  				       cnf09 = l_cnf09,
     				       cnf10 = 0,
    				       cnf11 = l_cnf11,
    				       cnf12 = l_cnf12,
  				       cnf13 = 0,
				       cnf14 = 0,
				       cnf15 = l_cnf15,
				       cnf16 = l_cnf16,
				       cnf17 = last_cnf17
                    WHERE cnf01 = l_cnf01 AND cnf02 = l_cnf02 
		      AND cnf03 = dd1  
	           IF SQLCA.SQLCODE THEN                                                 
#                     CALL cl_err('Update cnf_file error !',SQLCA.SQLCODE,1)              #No.TQC-660045
                      CALL cl_err3("upd","cnf_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Update cnf_file error !",1) #TQC-660045
                      LET g_success = 'N'  
                   END IF 
                   INSERT INTO cnl_file(cnl01,cnl02,cnl03,cnl04,cnl05,cnl06,  
                                         cnl07,cnl08,cnl09,cnl10,cnl11,cnl12,
                                         cnl13,cnl14,cnl15,cnl16,cnl17,cnlplant,cnllegal) #FUN-980002 add cnlplant,cnllegal          
                                  VALUES(l_cnf01,l_cnf02,yy,mm,l_cnf05,l_cnf06,  
                                         0,l_cnf08,l_cnf09,0,l_cnf11,l_cnf12,
                                         0,0,l_cnf15,l_cnf16,last_cnf17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
                    IF SQLCA.SQLCODE THEN                                      
#                      CALL cl_err('Insert cnl_file error !',SQLCA.SQLCODE,1)   #No.TQC-660045
                       CALL cl_err3("ins","cnl_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cnl_file error !",1) #TQC-660045
                       LET g_success = 'N'                                     
                    END IF                                             
                 ELSE
                    SELECT SUM(cnf05),SUM(cnf06),SUM(cnf07),SUM(cnf08),SUM(cnf09),SUM(cnf10),SUM(cnf11),
                           SUM(cnf12),SUM(cnf13),SUM(cnf14),SUM(cnf15),SUM(cnf16)        
                      INTO l_cnf05,l_cnf06,l_cnf07,l_cnf08,l_cnf09,l_cnf10,l_cnf11,
                           l_cnf12,l_cnf13,l_cnf14,l_cnf15,l_cnf16
                      FROM cnf_file
                     WHERE cnf01 = l_cnf01 AND cnf02 = l_cnf02                
                       AND cnf03 BETWEEN l_bdate AND dd1  
                    SELECT cnf17 INTO last_cnf17
                      FROM cnf_file
                     WHERE cnf01 = l_cnf01 AND cnf02 = l_cnf02                
                       AND cnf03 = dd1                                                                                             
                    INSERT INTO cnl_file(cnl01,cnl02,cnl03,cnl04,cnl05,cnl06,  
                                         cnl07,cnl08,cnl09,cnl10,cnl11,cnl12,
                                         cnl13,cnl14,cnl15,cnl16,cnl17,cnlplant,cnllegal) #FUN-980002 add cnlplant,cnllegal          
                                  VALUES(l_cnf01,l_cnf02,yy,mm,l_cnf05,l_cnf06,  
                                         l_cnf07,l_cnf08,l_cnf09,l_cnf10,l_cnf11,l_cnf12,
                                         l_cnf13,l_cnf14,l_cnf15,l_cnf16,last_cnf17,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
                    IF SQLCA.SQLCODE THEN                                      
#                      CALL cl_err('Insert cnl_file error !',SQLCA.SQLCODE,1)   #No.TQC-660045
                       CALL cl_err3("ins","cnl_file",l_cnf01,l_cnf02,SQLCA.sqlcode,"","Insert cnl_file error !",1) #TQC-660045
                       LET g_success = 'N'                                     
                    END IF  
                 END IF       
              END IF
              LET l_cnt = 0                               
           END FOREACH
        END IF
     END FOR
     LET dd1 = dd1+1
     LET l_mindate  = dd1
   END WHILE
 
END FUNCTION
