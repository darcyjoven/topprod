# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: abmi600_2.4gl
# Descriptions...: 預覽BOM結果 
# Input parameter: 
# Return code....: 
# Date & Author..: 2005/12/07 jackie
# Modify ........: 2006/04/11 FUN-640139 By Lifeng Fix Bug , Save BOM時如果料件已經存在則保存失敗，
#                             另外增加判別是否允許更新(現有BOM是否已經發放并在有效期內，如果是則
#                             不允許更新，否則可以更新),此外，對于多筆單身料件重復的情況，因為在
#                             原先的BOM處理邏輯中是允許的，所以在這里也不作處理
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-660059 06/06/14 By Rayven imandx_file改imx_file有些欄位修改有誤，重新修正
# Modify.........: No.TQC-660046 06/06/20 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-7B0018 08/02/28 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/28 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-830116 08/04/18 By jan 增加bmb33的賦值
# Modify.........: No.MOD-8C0242 08/12/24 By chenyu save_bom之后沒有COMMIT WORK的地方
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_bma01          LIKE bma_file.bma01,   # 類別代號 (假單頭)
         g_bma01_t        LIKE bma_file.bma01,   # 類別代號 (假單頭)
         g_bmb    DYNAMIC ARRAY of RECORD        # 程式變數
            bmb02          LIKE bmb_file.bmb02,  # 組合項次
            bmb03          LIKE bmb_file.bmb03,  # 元件編號
            ima02_b        LIKE ima_file.ima02,  # 名稱
            bmb06          LIKE bmb_file.bmb06,  # 用量
            bmb08          LIKE bmb_file.bmb08   # 損耗
                      END RECORD,
         g_bmb_t           RECORD                 # 變數舊值
            bmb02          LIKE bmb_file.bmb02,  # 組合項次
            bmb03          LIKE bmb_file.bmb03,
            ima02_b        LIKE ima_file.ima02,
            bmb06          LIKE bmb_file.bmb06,
            bmb08          LIKE bmb_file.bmb08
                      END RECORD,
         g_cnt2                LIKE type_file.num5,     #No.FUN-680096 SMALLINT
         g_wc                  STRING,
         g_sql                 string,                  #No.FUN-580092 HCN
         g_rec_b               LIKE type_file.num5,     # 單身筆數        #No.FUN-680096 SMALLINT
         l_ac                  LIKE type_file.num5      # 目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
DEFINE   g_ima02a              LIKE ima_file.ima02
DEFINE   g_bmb02               LIKE bmb_file.bmb02
DEFINE   g_bma01_no            LIKE bma_file.bma01
DEFINE   g_bma01_name          STRING
DEFINE   g_bma01_param         STRING
DEFINE   g_bomstring           STRING
DEFINE   g_cnt                 LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_i                   LIKE type_file.chr1         #No.FUN-680096 VARCHAR(1) 
DEFINE   g_forupd_sql          STRING
DEFINE   g_curs_index          LIKE type_file.num10        #No.FUN-680096 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5         #No.FUN-680096 SMALLINT
 
FUNCTION abmi600_2(p_bma01,p_result,p_result1,p_result2)
 
   DEFINE p_bma01     LIKE bma_file.bma01
   DEFINE l_bmb30     LIKE bmb_file.bmb30
   DEFINE l_ima02     LIKE ima_file.ima02
   DEFINE p_result    STRING
   DEFINE p_result1   STRING
   DEFINE p_result2   STRING
   DEFINE l_sql       LIKE type_file.chr1000       #No.FUN-680096
   #DEFINE l_c         SMALLINT     FUN-640139 Marked By Lifeng
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_bma01 = p_bma01
   LET g_bma01_t = NULL
   LET g_bomstring = p_result
   
   OPEN WINDOW p_bma_w WITH FORM "abm/42f/abmi600_2"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("abmi600_2")
 
   LET g_bma01_param = p_result
#單頭填充
#   LET g_bma01 = p_bma01
   LET g_bma01_no = g_bma01,p_result1
   DISPLAY g_bma01_no TO bma01
 
   SELECT ima02 INTO l_ima02
     FROM ima_file
    WHERE ima01 = g_bma01
   LET g_bma01_name = l_ima02,p_result2
   DISPLAY g_bma01_name TO ima02
   
   #FUN-640139 Marked Start ---
   #下面的判斷放在Save BOM的時候來做了,同時abm-994也改了內容
   #SELECT count(*) INTO l_c
   # FROM ima_file
   # WHERE ima01=g_bma01_no
   #IF l_c >0 THEN
   #  CALL cl_err(g_bma01_no,'abm-994',1)
   #END IF
   #FUN-640139 Marked End ---
 
   CALL p_bmb_b_fill() 
   CALL p_bma_menu() 
 
   DROP TABLE tmp_file
   CLOSE WINDOW p_bma_w                       # 結束畫面
   
END FUNCTION
 
 
FUNCTION p_bma_menu()
 
   WHILE TRUE
      CALL p_bma_bp("G")
 
      CASE g_action_choice
         WHEN "save_bom"
            CALL save_bom()
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_bma_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_bma_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
            l_n             LIKE type_file.num5,     # 檢查重復用   #No.FUN-680096 SMALLINT
            l_gau01         LIKE gau_file.gau01,     # 檢查重復用
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否   #No.FUN-680096 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態     #No.FUN-680096 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680096 SMALLINT
   DEFINE   l_ima02d        LIKE ima_file.ima02
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_bma01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT bmb02,bmb03,ima02,bmb06,bmb08 ",
                     "  FROM bmb_file,ima_file,bma_file",
#                     " WHERE bma01 = '",g_bma01,"' AND bmb03 = ? AND ima02 = ? AND bmb06 = ? AND bmb08 = ?",
                     "  WHERE bmb01 = '",g_bma01,"' AND bmb02 = ? AND bmb03 = ? AND bmb06 = ? AND bmb08 = ?",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_bmb_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_bmb WITHOUT DEFAULTS FROM s_bmb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      #  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
                        INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         #CKP
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         #CKP
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            #CKP
            LET p_cmd='u'
            LET g_bmb_t.* = g_bmb[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN p_bmb_bcl USING g_bmb_t.bmb02,g_bmb_t.bmb03,g_bmb_t.bmb06, g_bmb_t.bmb08
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_bmb_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_bmb_bcl INTO g_bmb[l_ac].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #CKP
        #NEXT FIELD bma02
 
      BEFORE INSERT
         #CKP
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_bmb[l_ac].* TO NULL       #900423
         LET g_bmb_t.* = g_bmb[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bmb02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
 
         #MOD-790002.................begin
         IF cl_null(g_bmb[l_ac].bmb02)  THEN
            LET g_bmb[l_ac].bmb02=' '
         END IF
         #MOD-790002.................end
 
         INSERT INTO bma_file(bma01,bmaoriu,bmaorig)
            VALUES (g_bma01_no, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         INSERT INTO bmb_file(bmb01,bmb02,bmb03,bmb06,bmb08,bmb33)     #No.FUN-830116
            VALUES (g_bma01_no,g_bmb[l_ac].bmb02,g_bmb[l_ac].bmb03, g_bmb[l_ac].bmb06,g_bmb[l_ac].bmb08,0) #No.FUN-830116
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_bma01,SQLCA.sqlcode,0)   #No.TQC-660046
             CALL cl_err3("ins","bmb_file",g_bma01_no,g_bmb[l_ac].bmb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
             #CKP
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_bmb_t.bmb03) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM bmb_file WHERE bmb01 = g_bma01_no
                                   AND bmb02 = g_bmb[l_ac].bmb02
                                   AND bmb03 = g_bmb[l_ac].bmb03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bmb_t.bmb03,SQLCA.sqlcode,0)   #No.TQC-660046
               CALL cl_err3("del","bmb_file",g_bma01_no,g_bmb[l_ac].bmb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_bmb[l_ac].* = g_bmb_t.*
            CLOSE p_bmb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_bmb[l_ac].bmb03,-263,1)
            LET g_bmb[l_ac].* = g_bmb_t.*
         ELSE
            UPDATE tmp_file
               SET tmp_bmb02 = g_bmb[l_ac].bmb02,
                   tmp_bmb03 = g_bmb[l_ac].bmb03,
                   tmp_ima02 = g_bmb[l_ac].ima02_b,
                   tmp_bmb06 = g_bmb[l_ac].bmb06,
                   tmp_bmb08 = g_bmb[l_ac].bmb08
             WHERE tmp_bmb02 = g_bmb_t.bmb02
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bmb[l_ac].bmb03,SQLCA.sqlcode,0)   #No.TQC-660046
               CALL cl_err3("upd","tmp_file",g_bmb_t.bmb02,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
               LET g_bmb[l_ac].* = g_bmb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D40030
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            IF p_cmd='u' THEN
               LET g_bmb[l_ac].* = g_bmb_t.*   
            #FUN-D40030--add--str--
            ELSE
               CALL g_bmb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE p_bmb_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D40030
         CLOSE p_bmb_bcl
         COMMIT WORK
 
     BEFORE FIELD bmb02
          IF g_bmb[l_ac].bmb02 IS NULL OR g_bmb[l_ac].bmb02 = 0 THEN
              SELECT MAX(tmp_bmb02)
                 INTO g_bmb[l_ac].bmb02
                 FROM tmp_file
              IF g_bmb[l_ac].bmb02 IS NULL THEN
                 LET g_bmb[l_ac].bmb02 = 0
              END IF
              LET g_bmb[l_ac].bmb02 = g_bmb[l_ac].bmb02 + g_sma.sma19                                                             
              DISPLAY g_bmb[l_ac].bmb02 TO s_bmb[l_ac].bmb02                                                                      
          END IF                                                                                                                  
 
        AFTER FIELD bmb02                        #default 項次                                                                      
            IF g_bmb[l_ac].bmb02 IS NOT NULL AND                                                                                    
               g_bmb[l_ac].bmb02 <> 0 AND p_cmd='a' THEN                                                                            
               LET l_n=0                                                                                                            
               SELECT COUNT(*) INTO l_n FROM tmp_file                                                                               
                      WHERE bmb02=g_bmb[l_ac].bmb02                                                                                 
               IF l_n>0 THEN                                                                                                        
                  IF NOT cl_confirm('asf-406') THEN NEXT FIELD bmb02 END IF                                                         
               END IF                                                                                                               
             END IF  
 
      AFTER FIELD bmb03
         #FUN-AA0059 ----------------------------add start-------------------
         IF NOT cl_null(g_bmb[l_ac].bmb03) THEN
            IF NOT s_chk_item_no(g_bmb[l_ac].bmb03,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmb03
            END IF 
         END IF 
         #FUN-AA0059 ---------------------------add end---------------------- 
         SELECT count(*) INTO l_n 
           FROM ima_file
          WHERE ima01 =  g_bmb[l_ac].bmb03
        IF l_n = 0 THEN
           CALL cl_err(g_bmb[l_ac].bmb03,'mfg6063',1)
           NEXT FIELD bmb03
        ELSE 
           SELECT ima02 INTO g_bmb[l_ac].ima02_b
             FROM ima_file
            WHERE ima01 = g_bmb[l_ac].bmb03
        END IF
 
      ON ACTION CONTROLP
        CASE                                                                                                                        
           WHEN INFIELD(bmb03)                                                                                                      
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()                                                                                                
            #  LET g_qryparam.form = "q_ima"                                                                                        
            #  LET g_qryparam.default1 = g_bmb[l_ac].bmb03                                                                           
            #  CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb03                                                                      
              CALL q_sel_ima(FALSE, "q_ima", "",g_bmb[l_ac].bmb03, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03
#FUN-AA0059 --End--
              DISPLAY BY NAME g_bmb[l_ac].bmb03                                                                                     
              NEXT FIELD bmb03                                                                                                      
                                                                                                                                    
           OTHERWISE                                                                                                                
              EXIT CASE                                                                                                             
           END CASE           
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
   CLOSE p_bmb_bcl
   COMMIT WORK
END FUNCTION
 
 
 
FUNCTION p_bmb_b_fill() 
 DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(400)
 DEFINE k          LIKE type_file.num5          #No.FUN-680096 SMALLINT
 DEFINE l_n        LIKE type_file.num5          #No.FUN-680096 SMALLINT
 DEFINE l_result3  STRING   
 DEFINE l_content  LIKE gep_file.gep05
 DEFINE l_noitem   STRING   
 DEFINE l_success01,l_success02    LIKE type_file.num5   #No.FUN-680096 SMALLINT
 DEFINE l_bmb30    LIKE bmb_file.bmb30
 DEFINE l_bmb02    LIKE bmb_file.bmb02
 DEFINE l_bmb03    LIKE bmb_file.bmb03
 DEFINE l_ima02    LIKE ima_file.ima02
 DEFINE l_ima02a   LIKE ima_file.ima02
 DEFINE l_bmb06    LIKE bmb_file.bmb06
 DEFINE l_bmb08    LIKE bmb_file.bmb08
 DEFINE l_bmbresult     DYNAMIC ARRAY OF RECORD 
                        bmbcontent  LIKE type_file.chr1000#No.FUN-680096 VARCHAR(100)
                        END RECORD
 
#No.FUN-680096----------start----------
    CREATE TEMP TABLE tmp_file(
        tmp_bmb02    LIKE bmb_file.bmb02,         
        tmp_bmb03    LIKE bmb_file.bmb02,          
        tmp_ima02    LIKE bmb_file.bmb02,                                                                                   
        tmp_bmb06    LIKE bmb_file.bmb02,                                                                                     
        tmp_bmb08    LIKE bmb_file.bmb02)            
#No.FUN-680096-----------end-----------       
    CREATE INDEX tmp_01 ON tmp_file(tmp_bmb02)                                                                                 
 
    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
#單身填充
   LET l_sql = " SELECT bmb02,bmb30 FROM bmb_file",
               "  WHERE bmb01 = '",g_bma01,"'"
   PREPARE tmp_bom1 FROM l_sql
   DECLARE bom_curs1 CURSOR FOR tmp_bom1
 
   FOREACH bom_curs1 INTO g_bmb02,l_bmb30
      IF l_bmb30 !='3' THEN
         LET l_sql = "SELECT bmb02,bmb03,ima02,bmb06,bmb08 ",
                     "  FROM bmb_file,ima_file ",
                     " WHERE bmb01 = '",g_bma01 CLIPPED,"' ",
                     "   AND bmb03 = ima01 ",
                     "   AND bmb02 = '",g_bmb02,"'" 
         PREPARE tmp_bom4 FROM l_sql
         DECLARE bom_curs4 CURSOR FOR tmp_bom4
         FOREACH bom_curs4 INTO l_bmb02,l_bmb03,l_ima02,l_bmb06,l_bmb08
           IF NOT cl_null(l_bmb03) AND l_bmb06 !=0 THEN   
            INSERT INTO tmp_file VALUES (l_bmb02,l_bmb03,l_ima02,l_bmb06,l_bmb08) 
           END IF   
         END FOREACH
      ELSE
         SELECT bmb02,bmb03 INTO l_bmb02,l_bmb03        
           FROM bmb_file 
          WHERE bmb01 = g_bma01 
            AND bmb02 = g_bmb02
 
         LET l_bmb03 = '&',l_bmb03
         LET l_sql = " SELECT gep05 FROM gep_file",
                     "  WHERE gep01 = '",l_bmb03,"-1&'" ,
                     "     OR gep01 = '",l_bmb03,"-2&'",
                     "     OR gep01 = '",l_bmb03,"-3&'",
                     "  ORDER BY gep01 "
         PREPARE tmp_bom3 FROM l_sql
         DECLARE bom_curs3 CURSOR FOR tmp_bom3
 
         LET k=0
         FOREACH bom_curs3 INTO l_content
            LET k = k+1
            CALL cl_fml_run_content(l_content,g_bomstring,k) RETURNING l_result3,l_success01 
            LET l_bmbresult[k].bmbcontent = l_result3 
         END FOREACH
         
         SELECT count(*) INTO l_n FROM ima_file
          WHERE ima01 = l_bmbresult[1].bmbcontent
         IF l_n = 0 THEN 
            LET l_ima02a = cl_getmsg('mfg6063',g_lang)
            LET g_ima02a = l_ima02a
         ELSE
            SELECT ima02 INTO l_ima02a FROM ima_file
             WHERE ima01 = l_bmbresult[1].bmbcontent
         END IF
         
         IF NOT cl_null(l_bmbresult[1].bmbcontent) AND (l_bmbresult[2].bmbcontent != 0) THEN  
           INSERT INTO tmp_file 
            VALUES(l_bmb02,l_bmbresult[1].bmbcontent,l_ima02a,l_bmbresult[2].bmbcontent,l_bmbresult[3].bmbcontent)  
         END IF
      END IF  
      END FOREACH
 
    
    LET l_sql = "SELECT * FROM tmp_file ",
                " ORDER BY tmp_bmb02 "
    PREPARE tmp_bom2 FROM l_sql 
    DECLARE bom_curs2 CURSOR FOR tmp_bom2
               
    FOREACH bom_curs2 INTO g_bmb[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    #CKP
    CALL g_bmb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_bma_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                  
         LET l_ac = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION save_bom    
         LET g_action_choice="save_bom"  
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()   
 
      ON ACTION controlg  
         CALL cl_cmdask()   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION save_bom()
DEFINE l_result     LIKE type_file.chr20         #No.FUN-680096 VARCHAR(20)
DEFINE l_bmb03c     LIKE bmb_file.bmb03
DEFINE l_i          LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
#FUN-640139 Add Start ---
DEFINE arr_detail   ARRAY[10] OF LIKE imx_file.imx01  
DEFINE str_tok      base.StringTokenizer
DEFINE l_ignore     LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE l_tok        STRING
#FUN-640139 Add End ---
DEFINE l_flag       LIKE type_file.chr1          #No.FUN-7B0018
DEFINE ls_value_fld LIKE ima_file.ima01          #No.FUN-7B0018
 
    SELECT count(*) INTO l_bmb03c FROM tmp_file 
     WHERE tmp_ima02 = g_ima02a
    IF l_bmb03c != 0 THEN
      CALL cl_err('','abm-992',1)
    ELSE
      #FUN-640139 Add By Lifeng Start , 這里加了N多邏輯，Jackie MM怎么這么粗心... -_-" 
      #首先判斷該相同料件的BOM是否已經存在（如果存在且發放了則在前面調用abmi600_2的時候就已經
      #被屏蔽掉，能run到這里說明如果存在也是可以更新的),提示用戶確認一下是否要覆蓋現有的BOM
      SELECT COUNT(*) INTO l_i FROM bma_file WHERE bma01 = g_bma01_no
      IF l_i > 0 THEN
         IF NOT cl_confirm('abm-994') THEN RETURN END IF
      END IF
      
      #然后開始保存操作
      #首先要在ima_file中找一下是否該料件已經存在，如果不存在則調用cl_copy_ima將料件
      #加BOM一起創建了，如果存在則只調用cl_copy_bom來更新BOM而已，料件信息不管它
      #因為在cl_copy_bom中已經將原來的單純INSERT改成DELETE+INSERT，所以這里調用起來就比較單純了
      #此外原來遺漏了一個邏輯是沒有在INSERT ima_file的同時INSERT imx_file資料，本次一并補上
      SELECT COUNT(*) INTO l_i FROM ima_file WHERE ima01 = g_bma01_no
      IF l_i > 0 THEN
         IF cl_copy_bom(g_bma01_no,g_bma01,g_bma01_param) = FALSE THEN RETURN END IF
      ELSE
        #沒有料件存在所以提示一下本次是連料件一起創建的
        IF NOT cl_confirm('abm-991') THEN RETURN END IF       
 
        #從傳進來的參數字符串中解析出插入imx_file需要的明細屬性列表
        LET str_tok = base.StringTokenizer.create(g_bma01_param,'|');
        LET l_i = 1              #每隔一個token取一個作為屬性
        LET l_ignore = TRUE      #第一個token是要被舍棄的
        WHILE str_tok.hasMoreTokens()
          LET l_tok = str_tok.nextToken()
          IF l_ignore THEN
             LET l_ignore = FALSE
          ELSE 
             LET arr_detail[l_i] = l_tok
             LET l_ignore = TRUE
             LET l_i = l_i + 1
             IF l_i > 10 THEN EXIT WHILE END IF #最多10個屬性
          END IF
        END WHILE
 
        IF cl_copy_ima(g_bma01,g_bma01_no,g_bma01_name,g_bma01_param) = TRUE THEN
           #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
           INSERT INTO imx_file VALUES(g_bma01_no,g_bma01,arr_detail[1],arr_detail[2],
              arr_detail[3],arr_detail[4],arr_detail[5],arr_detail[6],arr_detail[7],
              arr_detail[8],arr_detail[9],arr_detail[10])  #No.TQC-660059  由于表結構改變，將在最后的g_bma01插入到前面第二個欄位處
           #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
           #記錄的完全同步
           IF SQLCA.sqlcode THEN
#             CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)   #No.TQC-660046
              CALL cl_err3("ins","imx_file",g_bma01_no,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !'",1)  #No.TQC-660046
              DELETE FROM ima_file WHERE ima01 = ls_value_fld
              #NO.FUN-7B0018 08/02/28 add --begin
#             IF NOT s_industry('std') THEN   #No.FUN-830132 mark
              IF s_industry('icd') THEN       #No.FUN-830132 add
                 LET l_flag = s_del_imaicd(ls_value_fld,'')
              END IF
              #NO.FUN-7B0018 08/02/28 add --end
              RETURN
           END IF
        ELSE 
           RETURN
        END IF   
      END IF
      #FUN-640139 Add End
      
      #這里加注一下，估計是想把單身中進行的修改寫到數據庫中
      LET l_i=1
      FOREACH bom_curs2 INTO g_bmb[l_i].*
          UPDATE bmb_file
             SET bmb02 = g_bmb[l_i].bmb02,
                 bmb03 = g_bmb[l_i].bmb03,
                 bmb06 = g_bmb[l_i].bmb06,
                 bmb08 = g_bmb[l_i].bmb08,
                 bmbdate=g_today     #FUN-C40007 add
           WHERE bmb01 = g_bma01_no
             AND bmb02 = g_bmb[l_i].bmb02
          LET l_i=l_i+1
      END FOREACH
 
    END IF
    COMMIT WORK    #No.MOD-8C0242 add
END FUNCTION
 
