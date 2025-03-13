# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_abh.4gl
# Descriptions...: 
# Date & Author..: 
# Usage..........: 
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470599 04/07/30 By Nicola 沖帳傳票資料功能有異
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.FUN-5C0015 060109 BY GILL 處理abb31~abb36 
# Modify.........: NO.FUN-5C0112 06/01/24 BY yiting 確認後仍可查詢立沖資料(增加 action)鈕,單頭DISPLAY ONLY
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.TQC-670044 06/07/12 By Smapmin 單身不可APPEND,立帳傳票不開窗
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能					
# Modify.........: No.MOD-6B0165 06/12/04 By Smapmin 修改WHERE條件
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: NO.MOD-A30048 10/03/17 BY sabrina 當沖帳金額不平時，第二次進入沖帳視窗應呈現全部資料
#                                                    當與傳票金額相同時，則僅顯示設定的沖帳資料 
# Modify.........: NO.MOD-A30250 10/04/06 BY sabrina 判斷是否與傳票金額相同時少判斷項次這個條件
# Modify.........: NO.MOD-AA0047 10/10/11 BY Dido 增加帳別條件
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No:MOD-B60037 11/06/08 By Dido 排除無沖帳金額與未沖資料
# Modify.........: No:FUN-B40026 11/06/20 By zhangweib 取消abg31~abg36 ,abh31~abh36相關處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_abh(p_bookno,p_abb01,p_date,p_abb02)
   DEFINE p_bookno      LIKE abb_file.abb00
   DEFINE p_date        LIKE aba_file.aba02
   DEFINE p_abb01       LIKE abb_file.abb01
   DEFINE p_abb02       LIKE abb_file.abb02
   DEFINE cnt1,cnt2	LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_abg01       LIKE abg_file.abg01
   DEFINE l_abg02       LIKE abg_file.abg02
   DEFINE g_rec_bb,l_ac_b,l_sl_b,l_i,l_k,l_m  LIKE type_file.num5    	#No.FUN-680147 SMALLINT
   DEFINE l_sql 	STRING	                #No.FUN-680147 CHAR(600) #MOD-B60037 mod STRING
   DEFINE p_cmd     LIKE type_file.chr1    	#No.FUN-680147 VARCHAR(1)
   DEFINE g_chr     LIKE type_file.chr1    	#No.FUN-680147 VARCHAR(1)
   DEFINE g_abb     RECORD LIKE abb_file.*
   DEFINE g_abb_t   RECORD LIKE abb_file.*
   DEFINE l_aaa     RECORD LIKE aaa_file.*
   DEFINE g_abh     DYNAMIC ARRAY OF RECORD
                    abh06	LIKE abh_file.abh06,
                    abh07	LIKE abh_file.abh07,
                    abh08	LIKE abh_file.abh08,
                    abg06	LIKE abg_file.abg06,
                    abg071	LIKE abg_file.abg071,
                    abg073	LIKE abg_file.abg072,
                    abg072	LIKE abg_file.abg073,
                    amt1        LIKE abg_file.abg071,
                    abh09	LIKE abh_file.abh09,
                    abg04	LIKE abg_file.abg04 
                    END RECORD
   DEFINE g_abh_t   RECORD
                    abh06	LIKE abh_file.abh06,
                    abh07	LIKE abh_file.abh07,
                    abh08	LIKE abh_file.abh08,
                    abg06	LIKE abg_file.abg06,
                    abg071	LIKE abg_file.abg071,
                    abg073	LIKE abg_file.abg072,
                    abg072	LIKE abg_file.abg073,
                    amt1        LIKE abg_file.abg071,
                    abh09	LIKE abh_file.abh09,
                    abg04	LIKE abg_file.abg04 
                    END RECORD
 
   DEFINE l_sum     LIKE apa_file.apa34
   DEFINE l_amt,l_rem LIKE abg_file.abg071
   DEFINE l_total   LIKE apa_file.apa34
   DEFINE l_aag15   LIKE aag_file.aag15
   DEFINE l_aag222  LIKE aag_file.aag222
   DEFINE l_abh09   LIKE abh_file.abh09  
   DEFINE l_azi04   LIKE azi_file.azi04  
   DEFINE l_cnt           LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_lock_sw       LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE l_data          LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE l_msg           LIKE ze_file.ze03             #No.FUN-680147 VARCHAR(60)
   DEFINE l_modify_flag   LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
   DEFINE l_abb07   LIKE abb_file.abb07        #MOD-A30048 add
 
   WHENEVER ERROR CONTINUE
   #---->取沖帳傳票資料
   SELECT * INTO g_abb.* FROM abb_file WHERE abb00 = p_bookno  
                                          AND abb01 = p_abb01   
                                          AND abb02 = p_abb02   
   SELECT aag15,aag222 INTO l_aag15,l_aag222 FROM aag_file 
                       WHERE aag01 = g_abb.abb03
                         AND aag00 = p_bookno  #No.FUN-730020
   IF SQLCA.sqlcode THEN
      #CALL cl_err('sel aag_file',SQLCA.sqlcode,0)                        #FUN-670091
      CALL cl_err3("sel","aag_file",p_bookno,g_abb.abb03,SQLCA.sqlcode,"","",0) #FUN-670091  #No.FUN-730020
      RETURN 
   END IF 
   IF cl_null(l_aag222) THEN LET l_aag222 = ' ' END IF
   IF l_aag222 not matches '[12]' THEN RETURN END IF
   IF (l_aag222='1' AND g_abb.abb06='1')  OR
      (l_aag222='2' AND g_abb.abb06='2') 
   THEN RETURN 
   END IF
 # IF cl_null(l_aag15) THEN RETURN END IF
   IF cl_null(g_abb.abb11) THEN LET g_abb.abb11 = ' ' END IF
   IF cl_null(g_abb.abb12) THEN LET g_abb.abb12 = ' ' END IF
   IF cl_null(g_abb.abb13) THEN LET g_abb.abb13 = ' ' END IF
   IF cl_null(g_abb.abb14) THEN LET g_abb.abb14 = ' ' END IF
 
   #FUN-5C0015 BY GILL --START
   IF cl_null(g_abb.abb31) THEN LET g_abb.abb31 = ' ' END IF
   IF cl_null(g_abb.abb32) THEN LET g_abb.abb32 = ' ' END IF
   IF cl_null(g_abb.abb33) THEN LET g_abb.abb33 = ' ' END IF
   IF cl_null(g_abb.abb34) THEN LET g_abb.abb34 = ' ' END IF
   IF cl_null(g_abb.abb35) THEN LET g_abb.abb35 = ' ' END IF
   IF cl_null(g_abb.abb36) THEN LET g_abb.abb36 = ' ' END IF
   #FUN-5C0015 BY GILL --END
 
   LET l_data = 'N'
   LET g_abb_t.* = g_abb.*
#--NO.FUN-5C0112 START--------------
   IF g_action_choice = "contra_detail" THEN
          CALL cl_set_act_visible("cancel", FALSE)
   END IF
#--NO.FUN-5C0112 END----------------
 
   OPEN WINDOW t110_abh_w AT 4,2 WITH FORM "sub/42f/s_abh"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("s_abh")
 
   CALL s_abh_show_field()  #FUN-5C0015 BY GILL
 
   #-->display 
   DISPLAY g_abb.abb01 TO FORMONLY.abb01 
   DISPLAY g_abb.abb02 TO FORMONLY.abb02 
   DISPLAY g_abb.abb07 TO FORMONLY.abb07 
   DISPLAY g_abb.abb11 TO FORMONLY.abb11 
   DISPLAY g_abb.abb12 TO FORMONLY.abb12 
   DISPLAY g_abb.abb13 TO FORMONLY.abb13 
   DISPLAY g_abb.abb14 TO FORMONLY.abb14 
 
   #FUN-5C0015 BY GILL --START
   DISPLAY g_abb.abb31 TO FORMONLY.abb31 
   DISPLAY g_abb.abb32 TO FORMONLY.abb32 
   DISPLAY g_abb.abb33 TO FORMONLY.abb33 
   DISPLAY g_abb.abb34 TO FORMONLY.abb34 
   DISPLAY g_abb.abb35 TO FORMONLY.abb35 
   DISPLAY g_abb.abb36 TO FORMONLY.abb36 
   #FUN-5C0015 BY GILL --END
 
   DISPLAY g_abb.abb04 TO FORMONLY.abb04 
 
  #MOD-A30048---modify---start---
  #SELECT COUNT(*) INTO cnt1 FROM abh_file WHERE abh00 = p_bookno  
  #                                          AND abh01 = p_abb01   
  #                                          AND abh02 = p_abb02   
   LET l_abb07 = 0
   LET l_abh09 = 0
   SELECT abb07 INTO l_abb07 FROM abb_file where abb00= p_bookno
                                             AND abb01 = p_abb01
                                             AND abb02 = p_abb02
   SELECT sum(abh09) INTO l_abh09 FROM abh_file where abh00 = p_bookno
                                                  AND abh01 = p_abb01 
                                                  AND abh02 = p_abb02         #MOD-A30250 add
  #MOD-A30048---modify---end---
    LET g_rec_bb=0      #No.MOD-470599
  #IF cnt1 = 0 THEN                       #MOD-A30048 mark      
   IF l_abb07 != l_abh09 OR cl_null(l_abh09) THEN             #MOD-A30048 add  
      DECLARE t110_abh_c0 CURSOR FOR
        SELECT abg01,abg02,abg06,abg04,abg071,abg072,abg073,
               (abg071-abg072-abg073)
           FROM abg_file
           WHERE abg00 = p_bookno AND abg03 = g_abb.abb03
            #AND (abg071-abg072-abg073) > 0                 #MOD-A30048 mark    #只要未平衡，單據都要抓出來
             AND abg06 <= p_date   
             AND (abg05 = g_abb.abb05 OR abg05 IS NULL OR abg05=' ')
             #-----MOD-6B0165---------
             AND (abg11 = g_abb.abb11 OR abg11 IS NULL OR abg11=' ')
             AND (abg12 = g_abb.abb12 OR abg12 IS NULL OR abg12=' ')
             AND (abg13 = g_abb.abb13 OR abg13 IS NULL OR abg13=' ')
             AND (abg14 = g_abb.abb14 OR abg14 IS NULL OR abg14=' ')
            #AND (abg31 = g_abb.abb31 OR abg31 IS NULL OR abg31=' ')    #FUN-B40026   Mark
            #AND (abg32 = g_abb.abb32 OR abg32 IS NULL OR abg32=' ')    #FUN-B40026   Mark
            #AND (abg33 = g_abb.abb33 OR abg33 IS NULL OR abg33=' ')    #FUN-B40026   Mark
            #AND (abg34 = g_abb.abb34 OR abg34 IS NULL OR abg34=' ')    #FUN-B40026   Mark
            #AND (abg35 = g_abb.abb35 OR abg35 IS NULL OR abg35=' ')    #FUN-B40026   Mark
            #AND (abg36 = g_abb.abb36 OR abg36 IS NULL OR abg36=' ')    #FUN-B40026   Mark
             #AND abg11 = g_abb.abb11 AND abg12 = g_abb.abb12  
             #AND abg13 = g_abb.abb13 AND abg14 = g_abb.abb14
             ##FUN-5C0015 BY GILL --START
             #AND abg31 = g_abb.abb31 AND abg32 = g_abb.abb32
             #AND abg33 = g_abb.abb33 AND abg34 = g_abb.abb34
             #AND abg35 = g_abb.abb35 AND abg36 = g_abb.abb36
             ##FUN-5C0015 BY GILL --END
             #-----END MOD-6B0165-----
 
             ORDER BY abg06,abg01,abg02 DESC
 
      #FOR l_k = 1 TO 100 INITIALIZE g_abh[l_k].* TO NULL END FOR   #TQC-670044
      LET l_i = 1
      FOREACH t110_abh_c0 INTO g_abh[l_i].abh07,  g_abh[l_i].abh08,
                               g_abh[l_i].abg06,  g_abh[l_i].abg04,  
                               g_abh[l_i].abg071, g_abh[l_i].abg072, 
                               g_abh[l_i].abg073, g_abh[l_i].amt1 
         IF SQLCA.sqlcode THEN 
            CALL cl_err('t110_abh_c0',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_data = 'Y'
         LET g_abh[l_i].abh06 = l_i  
         LET g_abh[l_i].abh09 = 0
        #MOD-A30048---add---start---
         SELECT COUNT(*) INTO cnt1 FROM abh_file WHERE abh00 = p_bookno  
                                                   AND abh01 = p_abb01 
                                                   AND abh02 = p_abb02   
                                                   AND abh07 = g_abh[l_i].abh07 
                                                   AND abh08 = g_abh[l_i].abh08 
         IF cnt1=0 THEN
        #MOD-A30048---add---end---
            INSERT INTO abh_file(abh00,abh01,abh02,abh021,abh03,abh04,abh05,  #No.MOD-470041
                                 abh06,abh07,abh08,abh09,abh11,abh12,abh13,
                                 abh14,
                                #abh31,abh32,abh33,abh34,abh35,abh36,#FUN-5C0015     #FUN-B40026   Mark
                                 abh15,abh16,abh17,abhconf,abhlegal)  #No.MOD-470574 #FUN-980012 add abhlegal
                VALUES (p_bookno,       #帳別
                        p_abb01,        #傳票編號(沖帳)
                        p_abb02,        #項次    (沖帳)
                        p_date,         #傳票日期 
                        g_abb.abb03,    #科目
                        g_abb.abb04,    #摘要
                        g_abb.abb05,    #部門
                        g_abh[l_i].abh06, #行序
                        g_abh[l_i].abh07, #立帳傳票編號 
                        g_abh[l_i].abh08, #立帳傳票項次 
                        0,              #沖帳金額 
                        g_abb.abb11,g_abb.abb12,
                        g_abb.abb13,g_abb.abb14,
 
                        #FUN-5C0015 BY GILL --START
                       #g_abb.abb31,g_abb.abb32,g_abb.abb33,g_abb.abb34,    #FUN-B40026   Mark
                       #g_abb.abb35,g_abb.abb36,                            #FUN-B40026   Mark
                        #FUN-5C0015 BY GILL --END
                      
                        ' ',' ',' ','N',g_legal)  #FUN-980012 add g_legal
            IF SQLCA.sqlcode THEN 
               #CALL cl_err('ins abh_file',SQLCA.sqlcode,0)                         #FUN-670091
               CALL cl_err3("ins","abh_file",p_abb01,p_abb02,SQLCA.sqlcode,"","",0) #FUN-670091
               LET g_success = 'N'
            END IF
        #MOD-A30048---add---start---
         ELSE
            LET l_abh09 = 0
            LET l_sql = "SELECT abh09 FROM abh_file WHERE abh00 = '",p_bookno,"'",  
                                                  " AND abh01 = '",p_abb01,"'", 
                                                  " AND abh02 = '",p_abb02 CLIPPED,"'",   
                                                  " AND abh07 = '",g_abh[l_i].abh07,"'",
                                                  " AND abh08 = '",g_abh[l_i].abh08,"'"
            PREPARE abh09_pre FROM l_sql
            EXECUTE abh09_pre INTO l_abh09 
            LET g_abh[l_i].abh09 = l_abh09
         END IF
        #MOD-A30048---add---end---
         IF g_abh[l_i].amt1 = 0 AND g_abh[l_i].abh09 = 0 THEN #MOD-B60037
            CONTINUE FOREACH                                  #MOD-B60037
         END IF                                               #MOD-B60037
         LET l_i = l_i + 1
         #-----TQC-670044---------
         #IF l_i > 100 THEN
         #   CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         #   EXIT FOREACH
         #END IF
         #-----END TQC-670044-----
      END FOREACH
      CALL g_abh.deleteElement(l_i)   #TQC-670044
      CALL SET_COUNT(l_i-1)
       LET g_rec_bb=l_i-1         #No.MOD-470599
  #END IF                   #MOD-A30048 mark 
  #IF cnt1 > 0 THEN         #MOD-A30048 mark
   ELSE                     #MOD-A30048 add
      DECLARE t110_abh_c CURSOR FOR
        SELECT abh06,abh07,abh08,abg06,abg04,abg071,abg072,abg073,
               (abg071-abg072-abg073),abh09
           FROM abh_file,abg_file
           WHERE abh07 = abg01 AND abh08 = abg02 AND abh00 = abg00
             AND abh01 = p_abb01 AND abh02 = p_abb02
             AND abh00 = p_bookno                       #MOD-AA0047
             ORDER BY abh06 
 
      #FOR l_k = 1 TO 100 INITIALIZE g_abh[l_k].* TO NULL END FOR   #TQC-670044
      LET l_k = 1   LET l_sum = 0 
      FOREACH t110_abh_c INTO g_abh[l_k].abh06,
                              g_abh[l_k].abh07,
                              g_abh[l_k].abh08,
                              g_abh[l_k].abg06,  g_abh[l_k].abg04,
                              g_abh[l_k].abg071, g_abh[l_k].abg072,
                              g_abh[l_k].abg073, g_abh[l_k].amt1, 
                              g_abh[l_k].abh09
         IF SQLCA.sqlcode THEN 
            CALL cl_err('t110_abh_c',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_data = 'Y'
         LET l_sum = l_sum + g_abh[l_k].abh09
         LET l_k = l_k + 1
         #-----TQC-670044---------
         #IF l_k > 100 THEN
         #   CALL cl_err( '', 9035, 0 )    #No.TQC-630109
         #   EXIT FOREACH
         #END IF
         #-----END TQC-670044-----
      END FOREACH
      CALL g_abh.deleteElement(l_k)   #TQC-670044
      DISPLAY l_sum TO FORMONLY.tot 
      CALL SET_COUNT(l_k-1)
       LET g_rec_bb=l_k-1         #No.MOD-470599
   END IF
   IF l_data = 'N' THEN  
       CALL cl_getmsg('agl-903',g_lang) RETURNING l_msg
            LET INT_FLAG = 0  ######add for prompt bug
       PROMPT l_msg clipped FOR g_chr 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
       END PROMPT
       CLOSE WINDOW t110_abh_w
       RETURN 
   END IF
 
IF g_action_choice = "contra_detail" THEN
    DISPLAY ARRAY g_abh TO s_abh.* ATTRIBUTE(COUNT=g_rec_bb,UNBUFFERED)
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
    END DISPLAY
#--NO.MOD-860078 end------- 
    CLOSE WINDOW t110_abh_w
ELSE
#--NO.FUN-5C0112 END ---------------
   WHILE TRUE 
   INPUT ARRAY g_abh WITHOUT DEFAULTS FROM s_abh.*
           ATTRIBUTE (COUNT=g_rec_bb,MAXCOUNT=g_max_rec,UNBUFFERED,      #No.MOD-470599
              INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW = FALSE)   #TQC-670044
 
      BEFORE INSERT
         LET l_ac_b = ARR_CURR()
 #       LET l_sl_b = SCR_LINE()
         LET p_cmd='a'
         INITIALIZE g_abh[l_ac_b].* TO NULL    
         LET g_abh_t.* = g_abh[l_ac_b].*      
         NEXT FIELD abh06
        
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac_b = ARR_CURR()
 #       LET l_sl_b = SCR_LINE()
         LET l_lock_sw = 'N'    
          IF g_rec_bb >= l_ac_b  THEN      #No.MOD-470599
#        IF g_abh_t.abh07 IS NOT NULL  THEN
            LET p_cmd='u'
            LET g_abh_t.* = g_abh[l_ac_b].*
            LET g_success = 'Y'
            #-->鎖住立帳資料
              LET g_forupd_sql= " SELECT abg01,abg02 FROM abg_file ",
                                "  WHERE abg00 = ?  ",
                                "   AND abg01 =  ? ",
                                "   AND abg02 =  ? FOR UPDATE "
              LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
              DECLARE t110_loc_cr CURSOR FROM g_forupd_sql
 
               OPEN t110_loc_cr USING p_bookno,g_abh_t.abh07,g_abh_t.abh08
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_abh_t.abh06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
                  CLOSE t110_loc_cr
                  RETURN
              END IF
               FETCH t110_loc_cr INTO l_abg01,l_abg02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_abh_t.abh06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
         ELSE
              LET g_success = 'Y'
              LET p_cmd='a' 
              INITIALIZE g_abh[l_ac_b].* TO NULL  
         END IF
 
      BEFORE FIELD abh06
         IF cl_null(g_abh[l_ac_b].abh06) OR g_abh[l_ac_b].abh06 = 0 THEN
            SELECT MAX(abh06)+1 INTO g_abh[l_ac_b].abh06 FROM abh_file
                   WHERE abh00 = p_bookno  AND abh01 = p_abb01   
                     AND abh02 = p_abb02   
            IF cl_null(g_abh[l_ac_b].abh06) THEN LET g_abh[l_ac_b].abh06 = 1 END IF
         END IF
 
      AFTER FIELD abh06
         IF g_abh_t.abh06 IS NULL OR 
            g_abh_t.abh06 != g_abh[l_ac_b].abh06 THEN
            SELECT COUNT(*) INTO l_k FROM abh_file
                   WHERE abh00 = p_bookno  AND abh01 = p_abb01   
                     AND abh02 = p_abb02   AND abh06 = g_abh[l_ac_b].abh06 
            IF l_k > 0 THEN CALL cl_err('',-239,0) NEXT FIELD abh06 END IF
         END IF
 
      BEFORE FIELD abh07
            IF (l_lock_sw = 'Y') THEN            #已鎖住
                LET l_modify_flag = 'N'
            END IF
            IF (l_modify_flag = 'N') THEN
                LET g_abh[l_ac_b].abh06 = g_abh_t.abh06
#               DISPLAY g_abh[l_ac_b].abh06 TO s_abh[l_sl_b].abh06
                NEXT FIELD abh06
            END IF
            IF p_cmd = 'u' THEN NEXT FIELD abh09 END IF
 
      AFTER FIELD abh07  #立帳傳票
         IF not cl_null(g_abh[l_ac_b].abh07)  THEN
            SELECT count(*) INTO l_cnt FROM abg_file
                            WHERE abg01 = g_abh[l_ac_b].abh07
            IF l_cnt = 0 THEN  
               CALL cl_err(g_abh[l_ac_b].abh07,'agl-087',0)
               LET g_abh[l_ac_b].abh07 = g_abh_t.abh07
#              DISPLAY g_abh[l_ac_b].abh07 TO s_abh[l_sl_b].abh07
               NEXT FIELD abh07
            END IF
         END IF
 
      BEFORE FIELD abh08 
         IF cl_null(g_abh[l_ac_b].abh07)  THEN NEXT FIELD abh07 END IF
 
      AFTER FIELD abh08  #項次    
            IF g_abh[l_ac_b].abh07 != g_abh_t.abh07 OR
               g_abh[l_ac_b].abh08 != g_abh_t.abh08 OR
               g_abh_t.abh07 IS NULL OR g_abh_t.abh08 IS NULL
            THEN
                SELECT count(*) INTO l_cnt FROM abh_file
                 WHERE abh01 = p_abb01 AND abh02 = p_abb02
                   AND abh00 = p_bookno 
                   AND abh07 = g_abh[l_ac_b].abh07
                   AND abh08 = g_abh[l_ac_b].abh08
                   IF l_cnt > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_abh[l_ac_b].abh07 = g_abh_t.abh07
                      LET g_abh[l_ac_b].abh08 = g_abh_t.abh08
#                     DISPLAY g_abh[l_ac_b].abh07 TO s_abh[l_sl_b].abh07
#                     DISPLAY g_abh[l_ac_b].abh08 TO s_abh[l_sl_b].abh08
                      NEXT FIELD abh06
                   END IF
            END IF
            SELECT abg04,abg06,abg071,abg072,abg073,(abg071-abg072)
              INTO g_abh[l_ac_b].abg04,  g_abh[l_ac_b].abg06,
                   g_abh[l_ac_b].abg071, g_abh[l_ac_b].abg072, 
                   g_abh[l_ac_b].abg073, g_abh[l_ac_b].amt1
              FROM abg_file
              WHERE abg01 = g_abh[l_ac_b].abh07 AND abg02 = g_abh[l_ac_b].abh08
                AND abg00 = p_bookno
                AND abg06 <= p_date     
                AND (abg05 = g_abb.abb05 OR abg05 IS NULL OR abg05=' ')
                #-----MOD-6B0165---------
                AND (abg11 = g_abb.abb11 OR abg11 IS NULL OR abg11=' ')
                AND (abg12 = g_abb.abb12 OR abg12 IS NULL OR abg12=' ')
                AND (abg13 = g_abb.abb13 OR abg13 IS NULL OR abg13=' ')
                AND (abg14 = g_abb.abb14 OR abg14 IS NULL OR abg14=' ')
               #AND (abg31 = g_abb.abb31 OR abg31 IS NULL OR abg31=' ')    #FUN-B40026   Mark
               #AND (abg32 = g_abb.abb32 OR abg32 IS NULL OR abg32=' ')    #FUN-B40026   Mark
               #AND (abg33 = g_abb.abb33 OR abg33 IS NULL OR abg33=' ')    #FUN-B40026   Mark
               #AND (abg34 = g_abb.abb34 OR abg34 IS NULL OR abg34=' ')    #FUN-B40026   Mark
               #AND (abg35 = g_abb.abb35 OR abg35 IS NULL OR abg35=' ')    #FUN-B40026   Mark
               #AND (abg36 = g_abb.abb36 OR abg36 IS NULL OR abg36=' ')    #FUN-B40026   Mark
                #AND abg11 = g_abb.abb11 AND abg12 = g_abb.abb12  
                #AND abg13 = g_abb.abb13 AND abg14 = g_abb.abb14
                ##FUN-5C0015 BY GILL --START
                #AND abg31 = g_abb.abb31 AND abg32 = g_abb.abb32
                #AND abg33 = g_abb.abb33 AND abg34 = g_abb.abb34
                #AND abg35 = g_abb.abb35 AND abg36 = g_abb.abb36
                ##FUN-5C0015 BY GILL --END
                #-----END MOD-6B0165-----
 
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_abh[l_ac_b].abh07,'agl-907',0)
               LET g_abh[l_ac_b].abh07 = g_abh_t.abh07
               LET g_abh[l_ac_b].abh08 = g_abh_t.abh08
#              DISPLAY g_abh[l_ac_b].abh07 TO s_abh[l_sl_b].abh07
#              DISPLAY g_abh[l_ac_b].abh08 TO s_abh[l_sl_b].abh08
               NEXT FIELD abh06
            ELSE 
             LET g_abh[l_ac_b].abg071=cl_numfor(g_abh[l_ac_b].abg071,15,g_azi04)
             LET g_abh[l_ac_b].abg072=cl_numfor(g_abh[l_ac_b].abg072,15,g_azi04)
             LET g_abh[l_ac_b].abg073=cl_numfor(g_abh[l_ac_b].abg073,15,g_azi04)
             LET g_abh[l_ac_b].abh09=cl_numfor(g_abh[l_ac_b].abh09,15,g_azi04)
             LET g_abh[l_ac_b].amt1=cl_numfor(g_abh[l_ac_b].amt1,15,g_azi04)
#            DISPLAY g_abh[l_ac_b].abg04  TO s_abh[l_sl_b].abg04
#            DISPLAY g_abh[l_ac_b].abg06  TO s_abh[l_sl_b].abg06
#            DISPLAY g_abh[l_ac_b].abg071 TO s_abh[l_sl_b].abg071
#            DISPLAY g_abh[l_ac_b].abg072 TO s_abh[l_sl_b].abg072
#            DISPLAY g_abh[l_ac_b].abg073 TO s_abh[l_sl_b].abg073
#            DISPLAY g_abh[l_ac_b].amt1   TO s_abh[l_sl_b].amt1   
            END IF
 
      AFTER FIELD abh09  #沖帳金額
            LET g_abh[l_ac_b].abh09=cl_numfor(g_abh[l_ac_b].abh09,15,g_azi04)
            SELECT sum(abh09) INTO l_amt FROM abh_file 
               WHERE abh07 = g_abh[l_ac_b].abh07
                 AND abh08 = g_abh[l_ac_b].abh08
                 AND abhconf != 'X'
                 AND (abh01 != p_abb01 OR abh02 != p_abb02)
                 AND abh00 = p_bookno                       #MOD-AA0047
            IF cl_null(l_amt) THEN LET l_amt = 0 END IF
            LET l_rem = g_abh[l_ac_b].abg071 - l_amt
            IF g_abh[l_ac_b].abh09 > l_rem  THEN 
               CALL cl_err(p_abb01,'agl-908',0)
               NEXT FIELD abh09 
            END IF
            #-->check 沖帳金額是否超過
            LET l_sum = 0   
            #FOR l_m =1 TO 100   #TQC-670044
            FOR l_m =1 TO g_rec_bb   #TQC-670044
               IF cl_null(g_abh[l_m].abh07) THEN EXIT FOR END IF 
               LET l_sum = l_sum + g_abh[l_m].abh09
            END FOR
            IF l_sum > g_abb.abb07  THEN
               CALL cl_err(p_abb01,'agl-900',0)
            END IF
#           DISPLAY g_abh[l_ac_b].abh09 TO s_abh[l_sl_b].abh09
            DISPLAY l_sum TO FORMONLY.tot 
 
        #-----TQC-670044---------
        #ON ACTION CONTROLP
        #    CASE
        #        WHEN INFIELD(abh07)
        #        CALL cl_init_qry_var()
        #        LET g_qryparam.form ="q_abg" 
        #        LET g_qryparam.default1 = g_abh[l_ac_b].abh07
        #        CALL cl_create_qry() RETURNING g_abh[l_ac_b].abh07
        #        #CALL FGL_DIALOG_SETBUFFER( g_abh[l_ac_b].abh07 )
        #        DISPLAY g_abh[l_ac_b].abh07 TO abh07              #No.MOD-490344
        #        DISPLAY g_abh[l_ac_b].abh08 TO abh08              #No.MOD-490344
        #        NEXT FIELD abh06
        #        OTHERWISE EXIT CASE
        #    END CASE
        #-----END TQC-670044-----
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
         IF g_abh[l_ac_b].abh06 > 0 AND g_abh[l_ac_b].abh06 IS NOT NULL
            AND g_abh[l_ac_b].abh07 IS NOT NULL AND g_abh[l_ac_b].abh07 != ' '
            AND g_abh[l_ac_b].abh06 IS NOT NULL AND g_abh[l_ac_b].abh06 != ' ' THEN
            IF g_abh_t.abh06 IS NULL THEN      # 單身新增
                INSERT INTO abh_file(abh00,abh01,abh02,abh021,abh03,abh04,abh05,  #No.MOD-470041
                                     abh06,abh07,abh08,abh09,abh11,abh12,abh13,
                                     abh14,
                                    #abh31,abh32,abh33,abh34,abh35,abh36,#FUN-5C0015 BY GILL    #FUN-B40026   Mark
                                     abh15,abh16,abh17,abhconf,abhlegal) #No.MOD-470574 #FUN-980012 add abhlegal
                    VALUES (p_bookno,       #帳別
                            p_abb01,        #傳票編號(沖帳)
                            p_abb02,        #項次    (沖帳)
                            p_date,         #傳票日期 
                            g_abb.abb03,    #科目
                            g_abb.abb04,    #摘要
                            g_abb.abb05,    #部門
                            g_abh[l_ac_b].abh06, #行序
                            g_abh[l_ac_b].abh07, #立帳傳票編號 
                            g_abh[l_ac_b].abh08, #立帳傳票項次 
                            g_abh[l_ac_b].abh09, #沖帳金額 
                            g_abb.abb11,g_abb.abb12,
                            g_abb.abb13,g_abb.abb14,
 
#FUN-B40026   ---start   Mark
#                           #FUN-5C0015 BY GILL --START
#                           g_abb.abb31,g_abb.abb32,g_abb.abb33,g_abb.abb34,
#                           g_abb.abb35,g_abb.abb36,
#                           #FUN-5C0015 BY GILL --END
#FUN-B40026   ---end     Mark
                    
                            ' ',' ',' ','N',g_legal)  #FUN-980012 add g_legal
               IF SQLCA.sqlcode THEN
                  #CALL cl_err('ins abh:',STATUS,1) LET g_success = 'N' #FUN-670091 remark
                  CALL cl_err3("ins","abh_file",p_abb01,p_abb02,SQLCA.sqlcode,"","",0)  LET g_success = 'N' #FUN-670091
                  LET g_abh[l_ac_b].* = g_abh_t.*
#                 DISPLAY g_abh[l_ac_b].* TO s_abh[l_sl_b].*
                  ELSE MESSAGE "insert ok"
               END IF
            END IF
            IF g_abh_t.abh06 IS NOT NULL THEN  # 單身修改
                UPDATE abh_file SET  abh07 = g_abh[l_ac_b].abh07,
                                     abh08 = g_abh[l_ac_b].abh08,
                                     abh09 = g_abh[l_ac_b].abh09 
                  WHERE abh00 = p_bookno  AND abh01 = g_abb.abb01
                    AND abh02 = g_abb.abb02
                    AND abh06 = g_abh_t.abh06
                    AND abh07 = g_abh_t.abh07
                    AND abh08 = g_abh_t.abh08
               IF STATUS THEN
                  #CALL cl_err('upd abh:',STATUS,1) LET g_success = 'N'  #FUN-670091
                  CALL cl_err3("upd","abh_file",g_abb.abb01,g_abb.abb02,STATUS,"","",1) LET g_success = 'N'  #FUN-670091
                  LET g_abh[l_ac_b].* = g_abh_t.*
#                 DISPLAY g_abh[l_ac_b].* TO s_abh[l_sl_b].*
               ELSE MESSAGE "update ok"
               END IF
            END IF
            IF g_success = 'Y' THEN
               SELECT sum(abh09) INTO l_abh09 FROM abh_file 
                    WHERE abh00=p_bookno       AND abh07 = g_abh[l_ac_b].abh07
                      AND abh08=g_abh[l_ac_b].abh08 AND abhconf = 'N'
               IF cl_null(l_abh09) THEN LET l_abh09 = 0 END IF
              #010919
               LET l_abh09=cl_numfor(l_abh09,15,g_azi04)
               UPDATE abg_file SET abg073 = l_abh09 
                WHERE abg00 = p_bookno AND abg01 = g_abh[l_ac_b].abh07
                  AND abg02 = g_abh[l_ac_b].abh08
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                     #CALL cl_err('upd abg_file',SQLCA.sqlcode,0) #FUN-670091
                     CALL cl_err3("upd","abg_file",g_abh[l_ac_b].abh07,g_abh[l_ac_b].abh08,STATUS,"","",0) #FUN-670091
                     LET g_success = 'N'
                 END IF
            END IF
         END IF
       IF p_cmd = 'u' THEN CLOSE t110_loc_cr  END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                                    #No.FUN-6B0033                                                                       					
         CALL cl_set_head_visible("grid01,grid02","AUTO")   #No.FUN-6B0033					
 
   END INPUT
   IF INT_FLAG THEN EXIT WHILE  END IF
   #---------檢查金額要沖銷完全-----------------------
    SELECT SUM(abh09) INTO l_abh09 FROM abh_file 
               WHERE abh00=g_abb.abb00 AND abh01 = g_abb.abb01
                 AND abh02=g_abb.abb02
    IF cl_null(l_abh09) THEN LET l_abh09 = 0 END IF
    IF g_abb.abb07 != l_abh09 THEN 
       CALL cl_err(l_abh09,'agl-900',0)
       CONTINUE WHILE
    ELSE EXIT WHILE
    END IF
 END WHILE
 
#  IF INT_FLAG THEN LET g_success='N' LET INT_FLAG = 0 END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   CLOSE WINDOW t110_abh_w
   DELETE FROM abh_file WHERE abh00 = p_bookno    AND abh01 = g_abb.abb01  
                          AND abh02 = g_abb.abb02 AND abh09 = 0 
   IF l_lock_sw = 'Y' THEN RETURN END IF
END IF  #NO.FUN-5C0112 
END FUNCTION
 
#FUN-5C0015 BY GILL --START
FUNCTION s_abh_show_field()
#依參數決定異動碼的多寡  
 
  DEFINE l_field     STRING  
 
#FUN-B50105   ---start   Mark
# IF g_aaz.aaz88 = 10 THEN     
#    RETURN  
# END IF
#
# IF g_aaz.aaz88 = 0 THEN     
#    LET l_field  = "abb11,abb12,abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 1 THEN     
#    LET l_field  = "abb12,abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 2 THEN     
#    LET l_field  = "abb13,abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 3 THEN     
#    LET l_field  = "abb14,abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 4 THEN     
#    LET l_field  = "abb31,abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 5 THEN     
#    LET l_field  = "abb32,abb33,abb34,",
#                   "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 6 THEN     
#    LET l_field  = "abb33,abb34,abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 7 THEN     
#    LET l_field  = "abb34,abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 8 THEN     
#    LET l_field  = "abb35,abb36"
# END IF  
#
# IF g_aaz.aaz88 = 9 THEN     
#    LET l_field  = "abb36"
# END IF  
#FUN-B50105   ---start   Mark
 
#FUN-B50105   ---start   Add
  IF g_aaz.aaz88 = 0 THEN
     LET l_field  = "abb11,abb12,abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 1 THEN
     LET l_field  = "abb12,abb13,abb14"
  END IF 
  IF g_aaz.aaz88 = 2 THEN
     LET l_field  = "abb12,abb13,abb14"
  END IF
  IF g_aaz.aaz88 = 3 THEN
     LET l_field  = "abb13,abb14"
  END IF            
  IF g_aaz.aaz88 = 4 THEN
     LET l_field  = "abb14"
  END IF
  IF NOT cl_null(l_field) THEN LET l_field = l_field,"," END IF
  IF g_aaz.aaz125 = 5 THEN
     LET l_field = l_field,"abb32,abb33,abb34,abb35,abb36"
  END IF
  IF g_aaz.aaz125 = 6 THEN
     LET l_field = l_field,"abb33,abb34,abb35,abb36"
  END IF
  IF g_aaz.aaz125 = 7 THEN
     LET l_field = l_field,"abb34,abb35,abb36"
  END IF 
  IF g_aaz.aaz125 = 8 THEN
     LET l_field = l_field,"abb35,abb36"
  END IF
#FUN-B50105   ---end     Add

  CALL cl_set_comp_visible(l_field,FALSE)
END FUNCTION 
#FUN-5C0015 BY GILL --END
