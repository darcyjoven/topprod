# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_aqc_memo.4gl
# Descriptions...: 
# Date & Author..: 03/04/29 By Nicola        
# Input Parameter: 
# Return code....: 
# Modify.........: No.TQC-670050 06/08/01 BY rainy cl_err=>cl_err3 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify ........: No.MOD-680016 06/08/04 By Mandy Array l_ac 值給0 產生STATUS -1326
# Modify ........: No.MOD-680016 06/08/04 By Mandy UPDATE 備註內不成功
# Modify.........: No.MOD-770026 07/07/09 By pengu fetch_b應該加判斷qao02 = l_no1
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-890050 08/09/05 By claire 加入條件批次
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE p_row,p_col      LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE l_qao     DYNAMIC ARRAY OF RECORD
                    qao03		LIKE qao_file.qao03,
                    qao05		LIKE qao_file.qao05,
                    qao04		LIKE qao_file.qao04,
	            qao06		LIKE qao_file.qao06
                    END RECORD
 
DEFINE   g_rec_b         LIKE type_file.num10  	#No.FUN-680147 INTEGER
DEFINE   l_ac            LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE   l_ac_t          LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE   l_n             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
FUNCTION s_aqc_memo(p_no,p_no1,p_no2,p_line,p_cmd)
   DEFINE ls_tmp    STRING
   DEFINE p_no      LIKE qao_file.qao01 	#No.FUN-680147 VARCHAR(10)  #No.TQC-6A0079
   DEFINE p_no1     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_no2     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_cnt     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_line    LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_cmd     LIKE type_file.chr1         # u:update d:display only 	#No.FUN-680147 VARCHAR(1)
   DEFINE j,s       LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_qao_t   RECORD
                    qao03               LIKE qao_file.qao03,
                    qao05		LIKE qao_file.qao05,
                    qao04               LIKE qao_file.qao04,
		    qao06               LIKE qao_file.qao06
                    END RECORD,
          l_qao03_t LIKE qao_file.qao03,
          l_rec_b          LIKE type_file.num5,         #可新增否 	#No.FUN-680147 SMALLINT
          l_exit_sw        LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          l_allow_insert   LIKE type_file.num5,         #可新增否 	#No.FUN-680147 SMALLINT
          l_allow_delete   LIKE type_file.num5          #可刪除否 	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF p_no IS NULL THEN RETURN END IF
 
   LET p_row = 3 LET p_col = 5 
   OPEN WINDOW s_aqc_memo_w AT p_row,p_col WITH FORM "sub/42f/s_aqc_memo"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("s_aqc_memo")
   LET g_success='Y'
   WHILE TRUE    
    #-----------No.MOD-770026 modify
    #CALL fetch_b(p_no,p_line,p_cmd)
     CALL fetch_b(p_no,p_no1,p_no2,p_line,p_cmd)   #MOD-890050 add p_no2
    #-----------No.MOD-770026 end
    
     IF p_cmd = 'd' THEN
        CALL cl_set_act_visible("accept,cancel", FALSE)
        DISPLAY ARRAY l_qao TO s_qao.* ATTRIBUTE(COUNT=g_rec_b)
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
        
        END DISPLAY
        CLOSE WINDOW s_aqc_memo_w 
        RETURN 
     END IF
    
     LET l_allow_insert = cl_detail_input_auth("insert")
     LET l_allow_delete = cl_detail_input_auth("delete")
 
     LET l_exit_sw = 'y'     
     INPUT ARRAY l_qao WITHOUT DEFAULTS FROM s_qao.* 
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       BEFORE ROW
           LET p_cmd=''
          #BEGIN WORK #MOD-680016 mark
           LET l_ac=ARR_CURR()
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET l_qao_t.* = l_qao[l_ac].*  #BACK UP
              BEGIN WORK
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF    
           
       BEFORE INSERT 
          LET p_cmd='a'
          #LET l_n = ARR_COUNT()
          INITIALIZE l_qao_t.* TO NULL
          CALL cl_show_fld_cont()     #FUN-550037(smin)
    
    
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO qao_file (qao01,qao02,qao021,qao03,qao04,qao05,qao06,qaoplant,qaolegal) #FUN-980012 add qaoplant,qaolegal
                         VALUES(p_no,p_no1,p_no2,l_qao[l_ac].qao03,
                                l_qao[l_ac].qao04,l_qao[l_ac].qao05,l_qao[l_ac].qao06,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
          IF STATUS THEN
             #LET g_success='N' CALL cl_err('ins qao:',STATUS,1) #FUN-670090
             CALL cl_err3("ins","qao_file","","",STATUS,"","",1) #FUN-670091
             ROLLBACK WORK
             CANCEL INSERT
          ELSE
             COMMIT WORK
             LET l_rec_b = l_rec_b + 1
          END IF
    
       AFTER FIELD qao05
          IF NOT cl_null(l_qao[l_ac].qao05) THEN 
             IF l_qao[l_ac].qao05 NOT MATCHES '[012]' THEN
                NEXT FIELD qao05
             END IF
          END IF
    
       BEFORE FIELD qao04
          IF cl_null(l_qao[l_ac].qao04) THEN
             SELECT MAX(qao04)+1 INTO l_qao[l_ac].qao04 FROM qao_file
              WHERE qao01 = p_no AND qao03 = l_qao[l_ac].qao03
                AND qao05 = l_qao[l_ac].qao05
                AND qao02 = p_no1              #MOD-770026 add
             IF cl_null(l_qao[l_ac].qao04) THEN LET l_qao[l_ac].qao04 = 1 END IF
          END IF
    
       AFTER FIELD qao04
          IF NOT cl_null(l_qao[l_ac].qao04) THEN
             IF l_qao[l_ac].qao03 <> l_qao_t.qao03
                OR l_qao[l_ac].qao04 <> l_qao_t.qao04
                OR l_qao[l_ac].qao05 <> l_qao_t.qao05 THEN
                SELECT COUNT(*) INTO l_cnt FROM qao_file
                 WHERE qao01=p_no AND qao03=l_qao[l_ac].qao03
                   AND qao04=l_qao[l_ac].qao04 AND qao05=l_qao[l_ac].qao05
                IF l_cnt>0 THEN
                   CALL cl_err('','-239',0)
                   LET l_qao[l_ac].qao03=l_qao_t.qao03
                   LET l_qao[l_ac].qao04=l_qao_t.qao04
                   LET l_qao[l_ac].qao05=l_qao_t.qao05
                   LET l_qao[l_ac].qao06=l_qao_t.qao06
                   NEXT FIELD qao04
                END IF
             END IF
          END IF
    
       BEFORE DELETE
    
          DELETE FROM qao_file 
           WHERE qao01 = p_no 
             AND qao02 = p_no1         
             AND qao021= p_no2         
             AND qao03 = l_qao_t.qao03
             AND qao04 = l_qao_t.qao04
             AND qao05 = l_qao_t.qao05
    
           IF STATUS THEN
              #CALL cl_err('delete qao:',STATUS,1) #FUN-670091
              CALL cl_err3("del","qao_file","","",STATUS,"","",1) #FUN-670091
              LET g_success = 'N'
           ELSE 
              LET l_rec_b = l_rec_b - 1
              COMMIT WORK
           END IF
    
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_qao[l_ac].* = l_qao_t.*
              ROLLBACK WORK
              EXIT INPUT
           END IF
    
           UPDATE qao_file SET qao01 = p_no,
                               qao02 = p_no1,         
                               qao021= p_no2,         
                               qao03 = l_qao[l_ac].qao03,
                               qao04 = l_qao[l_ac].qao04,
                               qao05 = l_qao[l_ac].qao05,
                               qao06 = l_qao[l_ac].qao06
                     WHERE qao01 = p_no 
                       AND qao02 = p_no1          
                       AND qao021= p_no2          
                       AND qao03 = l_qao_t.qao03
                       AND qao04 = l_qao_t.qao04
                       AND qao05 = l_qao_t.qao05
          #IF STATUS THEN                         #MOD-680016 mark
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN #MOD-680016 mod
              #CALL cl_err('upd qao:',STATUS,1) #FUN-670091
              CALL cl_err3("upd","qao_file",p_no,p_no1,STATUS,"","",1) #FUN-670091
              LET g_success='N' CALL cl_err('upd qao:',STATUS,1)
           ELSE
              COMMIT WORK
           END IF
    
       AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET l_qao[l_ac].* = l_qao_t.*
              END IF
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
 
     END INPUT
   IF l_exit_sw='y' THEN EXIT WHILE ELSE CONTINUE WHILE END IF
   END WHILE
 
   CLOSE WINDOW s_aqc_memo_w
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN 
   END IF
 
END FUNCTION 
 
#----------No.MOD-770026 modify
#FUNCTION fetch_b(l_no,l_line,l_cmd)
FUNCTION fetch_b(l_no,l_no1,l_no2,l_line,l_cmd)   #MOD-890050 add l_no2
#----------No.MOD-770026 end
 DEFINE l_no    LIKE qao_file.qao01 	#No.FUN-680147 VARCHAR(10)  #No.TQC-6A0079
 DEFINE l_no1   LIKE qao_file.qao02     #No.MOD-770026 add
 DEFINE l_no2   LIKE qao_file.qao021    #No.MOD-890050 add
 DEFINE l_line  LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 DEFINE l_cmd   LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 DEFINE l_sql   LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(800)
 
   LET l_sql = "SELECT qao03,qao05,qao04,qao06 ",
               "  FROM qao_file ",
               " WHERE qao01 = '",l_no,"'",
               "   AND qao02 = '",l_no1,"'"      #No.MOD-770026 add
              ,"   AND qao021 = '",l_no2,"'"    #No.MOD-890050 add
   IF l_cmd = 'd' AND l_line != 0 THEN
      LET l_sql = l_sql CLIPPED," AND (qao03=0 OR qao03 = ",l_line,")"
   END IF
   LET l_sql = l_sql CLIPPED," ORDER BY qao03,qao04 "
 
   PREPARE s_aqc_memo_pre FROM l_sql
   DECLARE s_aqc_memo_c CURSOR FOR s_aqc_memo_pre
 
   CALL l_qao.clear()
   LET l_ac = 1
   FOREACH s_aqc_memo_c INTO l_qao[l_ac].qao03,l_qao[l_ac].qao05,
                         l_qao[l_ac].qao04,l_qao[l_ac].qao06
 
      IF STATUS THEN 
         CALL cl_err('foreach qao',STATUS,0) 
         EXIT FOREACH 
      END IF
 
      LET l_ac=l_ac+ 1
 
      IF l_ac> g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL l_qao.deleteElement(l_ac)
   LET g_rec_b =l_ac - 1
  #LET l_ac = 0 #MOD-680016
   LET l_ac = 1
 
END FUNCTION
