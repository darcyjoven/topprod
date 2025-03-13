# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_axm_memo.4gl
# Descriptions...: 
# Date & Author..: 
# Modify ........: 03/04/23 By Kammy no.7154
#                  架構改寫，並增q_oae 可查詢常用說明
# Modify ........: No:9498 04/04/29 By Melody 增加oao03不可空白判斷
# Modify ........: No.FUN-560171 05/06/21 單號DEFINE LIKE apm_file.apm08,要改成LIKE oao01 	#No.FUN-680147
# Modify ........: No.TQC-590004 05/09/19 By pengu單身select出資料後，增加oao05排序
# Modify.........; NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-740200 07/04/22 By claire 輸入項次需存在於訂單單身,但0指為訂單單頭
# Modify.........: No.TQC-740280 07/04/24 By claire 暫不修改 TQC-740200,因有太多程式共用此段,如 asfi301,axmt500...
# Modify.........: No.MOD-790109 07/09/20 By Pengu 一般訂單維護作業,新增備註(右邊選單),要刪時,按確認會無法存
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-990006 09/09/02 By lilingyu 出貨單單身只有一筆資料(項次1),但是在輸入備注資料時,卻可以輸入項次2的資料
# Modify.........: No:MOD-990252 09/09/28 By mike 将TQC-990006还原.       
# Modify.........: No:MOD-9B0152 09/11/24 By Sarah 調整程式寫法
# Modify.........: No:MOD-B60009 11/06/01 By sabrina 當資料被lock住時應用exit input離開迴圈
# Modify.........: No:TQC-B60140 11/06/17 By wuxj  當更新失敗后應顯示舊值

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE p_row,p_col      LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE i,g_rec_b,g_cnt  LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE g_forupd_sql     STRING                  #MOD-9B0152 add
DEFINE l_oao            DYNAMIC ARRAY OF RECORD
                         oao03	 LIKE oao_file.oao03,
                         oao05	 LIKE oao_file.oao05,
                         oao04	 LIKE oao_file.oao04,
	                 oao06	 LIKE oao_file.oao06
                        END RECORD
DEFINE b_oao            RECORD                  #MOD-9B0152 add
                         oao03   LIKE oao_file.oao03,
                         oao05   LIKE oao_file.oao05,
                         oao04   LIKE oao_file.oao04,
	                 oao06   LIKE oao_file.oao06
                        END RECORD
 
FUNCTION s_axm_memo(p_no,p_line,p_cmd)
   DEFINE ls_tmp        STRING
  #DEFINE p_no		LIKE apm_file.apm08 	#No.FUN-680147 VARCHAR(10)
   DEFINE p_no		LIKE oao_file.oao01     #FUN-560171
   DEFINE p_line        LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_cmd		LIKE type_file.chr1  	# u:update d:display only 	#No.FUN-680147 VARCHAR(1)
   DEFINE j,s		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5     #MOD-9B0152 add
   DEFINE l_oao_t       RECORD
                         oao03   LIKE oao_file.oao03,
                         oao05	 LIKE oao_file.oao05,
                         oao04   LIKE oao_file.oao04,
		         oao06   LIKE oao_file.oao06
                        END RECORD,
          l_oao03_t     LIKE oao_file.oao03,
          l_lock_sw     LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          l_exit_sw     LIKE type_file.chr1     #No.FUN-680147 VARCHAR(1)
 
   WHENEVER ERROR CONTINUE
 
   IF p_no IS NULL THEN RETURN END IF
 
  #str MOD-9B0152 add
   LET g_forupd_sql = "SELECT oao03,oao05,oao04,oao06 FROM oao_file ",
                      " WHERE oao01 = ? AND oao03 = ? ",
                      "   AND oao04 = ? AND oao05 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_axm_memo_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
  #end MOD-9B0152 add

   LET p_row = 3 LET p_col = 5 
   OPEN WINDOW s_axm_memo_w AT p_row,p_col WITH FORM "sub/42f/s_axm_memo"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale('s_axm_memo')
       
 LET g_success='Y'
 WHILE TRUE
   CALL s_axm_memo_fetch_b(p_no,p_line,p_cmd)
   
   IF p_cmd = 'd' THEN
      DISPLAY ARRAY l_oao TO s_oao.* 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
      
      END DISPLAY
      CLOSE WINDOW s_axm_memo_w
      RETURN
   END IF
 
   LET l_exit_sw = 'y'
   INPUT ARRAY l_oao WITHOUT DEFAULTS FROM s_oao.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
     BEFORE INPUT
        #CKP
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(i)
        END IF
 
     BEFORE ROW
        #CKP
        LET p_cmd = ''
        LET i=ARR_CURR()
        BEGIN WORK   #MOD-9B0152 add
        IF g_rec_b >= i THEN
           LET l_oao_t.* = l_oao[i].*  #BACK UP
          #BEGIN WORK   #MOD-9B0152 mark
          #str MOD-9B0152 add
           LET p_cmd='u'
           OPEN s_axm_memo_bcl USING p_no,l_oao_t.oao03,
                                     l_oao_t.oao04,l_oao_t.oao05
           IF STATUS THEN
              CALL cl_err("OPEN s_axm_memo_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
              CLOSE s_axm_memo_bcl
              ROLLBACK WORK
             #RETURN            #MOD-B60009 mark 
              EXIT INPUT        #MOD-B60009 add
           ELSE
              FETCH s_axm_memo_bcl INTO b_oao.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('lock oao',SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
          #end MOD-9B0152 add
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT 
        #CKP
        LET p_cmd = 'a'
        INITIALIZE l_oao_t.* TO NULL
        CALL cl_show_fld_cont()     #FUN-550037(smin)

#MOD-990252   ---start    
##TQC-990006 --undo mark begin--              
#     #No:9498
#    #---------No.MOD-790109 mark
#    AFTER FIELD oao03
#       IF cl_null(l_oao[i].oao03) THEN
#          CALL cl_err(l_oao[i].oao03,'mfg0037',0)
#          NEXT FIELD oao03
#       END IF
#    #---------No.MOD-790109 end
#       #TQC-740280-begin-mark
#        ##TQC-740200-begin-add
#         IF l_oao[i].oao03 <> 0 THEN
#            LET g_cnt = 0
#            SELECT COUNT(*) INTO g_cnt 
#            FROM ogb_file 
#            WHERE ogb01 = p_no 
#              AND ogb03 = l_oao[i].oao03
#            IF g_cnt = 0 THEN
#              CALL cl_err(l_oao[i].oao03,'axm-141',0)
#              NEXT FIELD oao03
#            END IF
#         END IF
#        ##TQC-740200-end-add
#       #TQC-740280-end-mark
#     #No:9498
##TQC-990006 --undo mark end--
#MOD-990252    ---end       

     AFTER FIELD oao05
        IF NOT cl_null(l_oao[i].oao05) THEN
           IF l_oao[i].oao05 NOT MATCHES '[012]' THEN
              NEXT FIELD oao05
           END IF
        END IF
 
     BEFORE FIELD oao04
        IF cl_null(l_oao[i].oao04) THEN
           SELECT MAX(oao04)+1 INTO l_oao[i].oao04 FROM oao_file
            WHERE oao01 = p_no AND oao03 = l_oao[i].oao03
              AND oao05 = l_oao[i].oao05
           IF cl_null(l_oao[i].oao04) THEN LET l_oao[i].oao04 = 1 END IF
        END IF
 
    #str MOD-9B0152 add
     AFTER FIELD oao04
        IF NOT cl_null(l_oao[i].oao04) THEN
           IF l_oao[i].oao04 != l_oao_t.oao04 OR l_oao_t.oao04 IS NULL THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM oao_file
               WHERE oao01=p_no           AND oao03=l_oao[i].oao03
                 AND oao04=l_oao[i].oao04 AND oao05=l_oao[i].oao05
              IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
              IF l_cnt > 0 THEN
                 LET l_oao[i].oao04 = l_oao_t.oao04
                 CALL cl_err('',-239,0)
                 NEXT FIELD oao04
              END IF
           END IF
        END IF
    #end MOD-9B0152 add

     BEFORE DELETE
       #str MOD-9B0152 add
        IF NOT cl_delb(0,0) THEN
           LET g_success = 'N'
           CANCEL DELETE
        END IF
       #end MOD-9B0152 add
#       IF l_lock_sw = "Y" THEN 
#          CALL cl_err("", -263, 1) 
#          CANCEL DELETE 
#       END IF 
        DELETE FROM oao_file WHERE oao01 = p_no 
                               AND oao03 = l_oao_t.oao03
                               AND oao04 = l_oao_t.oao04
                               AND oao05 = l_oao_t.oao05
        IF STATUS THEN
           LET g_success = 'N' 
          #CALL cl_err('del oao:',STATUS,1) #FUN-670091
           CALL cl_err3("del","oao_file",p_no,"",STATUS,"","",1) #FUN-670091
           CANCEL DELETE   #MOD-9B0152 add
        END IF
       #str MOD-9B0152 add
        IF g_success = 'Y' THEN
           MESSAGE 'DELETE O.K'
           LET g_rec_b=g_rec_b-1
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
       #end MOD-9B0152 add
 
     ON ROW CHANGE
       #str MOD-9B0152 add
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET l_oao[i].* = l_oao_t.*
           CLOSE s_axm_memo_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw = 'Y' THEN
           CALL cl_err(l_oao[i].oao03,-263,1)
           LET l_oao[i].* = l_oao_t.*
        ELSE
       #end MOD-9B0152 add
           UPDATE oao_file SET oao01 = p_no,
                               oao03 = l_oao[i].oao03,
                               oao04 = l_oao[i].oao04,
                               oao05 = l_oao[i].oao05,
                               oao06 = l_oao[i].oao06
                         WHERE oao01 = p_no 
                           AND oao03 = l_oao_t.oao03
                           AND oao04 = l_oao_t.oao04
                           AND oao05 = l_oao_t.oao05
           IF STATUS THEN
              LET g_success='N'  
              #CALL cl_err('upd oao:',STATUS,1) #FUN-670091
               CALL cl_err3("upd","oao_file",p_no,"",STATUS,"","",1) #FUN-670091
               LET l_oao[i].oao03 = l_oao_t.oao03      #TQC-B60140 add
               LET l_oao[i].oao04 = l_oao_t.oao04      #TQC-B60140 add
               LET l_oao[i].oao05 = l_oao_t.oao05      #TQC-B60140 add 
               LET l_oao[i].oao06 = l_oao_t.oao06      #TQC-B60140 add 
          #str MOD-9B0152 add
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
          #end MOD-9B0152 add
           END IF
        END IF   #MOD-9B0152 add
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
          #str MOD-9B0152 add
           INITIALIZE l_oao[i].* TO NULL  #重要欄位空白,無效
           DISPLAY l_oao[i].* TO s_oao.*
           CALL l_oao.deleteElement(i)
           ROLLBACK WORK
           EXIT INPUT
          #end MOD-9B0152 add
           #CKP
           CANCEL INSERT
        END IF
        IF NOT cl_null(l_oao[i].oao03) AND NOT cl_null(l_oao[i].oao04) 
           AND NOT cl_null(l_oao[i].oao05) THEN
           INSERT INTO oao_file (oao01,oao03,oao04,oao05,oao06)
                          VALUES(p_no,l_oao[i].oao03,
                                 l_oao[i].oao04,
                                 l_oao[i].oao05,
                                 l_oao[i].oao06)
           IF STATUS THEN
              LET g_success='N' 
              #CALL cl_err('ins oao:',STATUS,1) #FUN-670091
               CALL cl_err3("ins","oao_file",p_no,"",STATUS,"","",1) #FUN-670091
              #CKP
              ROLLBACK WORK
              CANCEL INSERT
          #str MOD-9B0152 add
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
          #end MOD-9B0152 add
           END IF
         END IF
         
     AFTER ROW
         LET i = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
               LET l_oao[i].* = l_oao_t.*   
            END IF
            ROLLBACK WORK
            CLOSE s_axm_memo_bcl   #MOD-9B0152 add
            EXIT INPUT
         END IF
        #IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF  #MOD-9B0152 mark
         CLOSE s_axm_memo_bcl   #MOD-9B0152 add
         COMMIT WORK            #MOD-9B0152 add
                                   
     ON ACTION CONTROLP
       IF INFIELD(oao06) THEN
          CALL q_oae(p_no,l_oao[i].oao03,
                     l_oao[i].oao05,l_oao[i].oao04)
          LET l_exit_sw='n'
          EXIT INPUT
       END IF
 
     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
   
   END INPUT
 
   IF l_exit_sw='y' THEN EXIT WHILE ELSE CONTINUE WHILE END IF
  END WHILE
 
   CLOSE WINDOW s_axm_memo_w
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      RETURN
   END IF
 
END FUNCTION 
 
FUNCTION s_axm_memo_fetch_b(l_no,l_line,l_cmd)
#DEFINE l_no    LIKE apm_file.apm08 	#No.FUN-680147CHAR(10)
 DEFINE l_no    LIKE oao_file.oao01     #FUN-560171
 DEFINE l_line  LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 DEFINE l_cmd   LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 DEFINE l_sql   LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(200)
 
   LET l_sql = "SELECT oao03,oao05,oao04,oao06 ",
               "  FROM oao_file ",
               " WHERE oao01 = '",l_no,"'"
 
   IF l_cmd = 'd' AND l_line != 0 THEN
      LET l_sql = l_sql CLIPPED," AND (oao03=0 OR oao03 = ",l_line,")"
   END IF
 
   LET l_sql = l_sql CLIPPED," ORDER BY oao03,oao05,oao04 "   #TQC-590004 add oao05
   PREPARE s_axm_memo_pre FROM l_sql
   DECLARE s_axm_memo_c CURSOR FOR s_axm_memo_pre
   CALL l_oao.clear()
 
   LET g_cnt = 1
   FOREACH s_axm_memo_c INTO l_oao[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach oao',STATUS,0) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   #CKP
   CALL l_oao.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
   LET i = 1
END FUNCTION
