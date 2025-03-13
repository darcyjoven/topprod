# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: almt590_sub.4gl
# Descriptions...: 生效范围作业
# Date & Author..: NO.FUN-C50085 12/05/28 By pauline 
# Modify.........: No.FUN-C50137 12/06/05 By pauline 積分換券優化處理
# Modify.........: No.FUN-C60089 12/07/20 By pauline 調整lsz02分類欄位內容 
# Modify.........: No.CHI-C80047 12/08/21 By pauline 將卡種納入PK值
DATABASE ds

GLOBALS "../../config/top.global"
DEFINE
     g_lsz          DYNAMIC ARRAY OF RECORD   
	lszplant        LIKE lsz_file.lszplant,
	azp02           LIKE azp_file.azp02,
	lsz03           LIKE lsz_file.lsz03,
	azp02_1         LIKE azp_file.azp02,
	lsz05           LIKE lsz_file.lsz05,
	lsz04           LIKE lsz_file.lsz04,
	oba02           LIKE oba_file.oba02,
	lsz10           LIKE lsz_file.lsz10
	END RECORD, 

     g_lsz_t        RECORD
	lszplant        LIKE lsz_file.lszplant,
	azp02           LIKE azp_file.azp02,
	lsz03           LIKE lsz_file.lsz03,
	azp02_1         LIKE azp_file.azp02,
	lsz05           LIKE lsz_file.lsz05,
	lsz04           LIKE lsz_file.lsz04,
	oba02           LIKE oba_file.oba02,
	lsz10           LIKE lsz_file.lsz10
	END RECORD,
   #g_wc2,g_sql     LIKE type_file.chr1000,    #FUN-C60089 mark  
    g_wc2,g_sql     STRING,                    #FUN-C60089 add
    g_rec_b         LIKE type_file.num5,                #單身筆數
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_lsu01      LIKE lsu_file.lsu01
DEFINE g_argv1      LIKE lsu_file.lsu12
DEFINE g_argv2      LIKE lsz_file.lsz02
DEFINE g_argv3      LIKE lsu_file.lsu11 
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_lsu00      LIKE lsu_file.lsu00     #FUN-C60089 add 
DEFINE g_lsu02      LIKE lsu_file.lsu02     #CHI-C80047 add
FUNCTION t590_sub_menu()
 DEFINE l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL t590_sub_bp("G")
      CASE g_action_choice
	 WHEN "detail"
	    IF cl_chk_act_auth() THEN
	       CALL t590_sub_b()
	    END IF
	 WHEN "help"
	    CALL cl_show_help()
	 WHEN "exit"
	    EXIT WHILE
	 WHEN "controlg"
	    CALL cl_cmdask()
	 WHEN "related_document"
	    IF cl_chk_act_auth() AND l_ac != 0 THEN
	       IF g_lsz[l_ac].lsz03 IS NOT NULL THEN
		  LET g_doc.column1 = "lsz03"
		  LET g_doc.value1 = g_lsz[l_ac].lsz03
		  CALL cl_doc()
	       END IF
	    END IF
	 WHEN "exporttoexcel"
	    IF cl_chk_act_auth() THEN
	      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsz),'','')
	    END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t590_sub(p_lsu01,p_argv1,p_argv2,p_argv3,p_argv4)
DEFINE p_lsu01        LIKE lsu_file.lsu01   #方案編號
DEFINE p_argv1        LIKE lsu_file.lsu12   #方案版本
DEFINE p_argv2        LIKE type_file.chr1   #來源
DEFINE p_argv3        LIKE lsu_file.lsu11   #制定營運中心
DEFINE p_argv4        LIKE lsu_file.lsu02   #卡種

    WHENEVER ERROR CALL cl_err_msg_log
    OPEN WINDOW t5901_w WITH FORM "alm/42f/almt590_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    LET g_lsu01 = p_lsu01
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_lsu02 = p_argv4
   #IF g_argv2 = '1' OR g_argv2 = '2' THEN  #FUN-C60089 mark 
    IF g_argv2 = '1' OR g_argv2 = '2' OR g_argv2 = '3' OR g_argv2 = '4' THEN  #FUN-C60089 add
       CALL cl_set_comp_visible("lszplant,azp02,lsz04,lsz05,oba02",FALSE)
    END IF
   #FUN-C60089 add START
    IF g_argv2 = '1' OR g_argv2 = '3' THEN  #almi590/almi600
       LET g_lsu00 = '0'
    END IF
    IF g_argv2 = '2' OR g_argv2 = '4' THEN  #almi591/almi601
       LET g_lsu00 = '1'
    END IF
   #FUN-C60089 add END
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       LET g_wc2 = '1=1'
       CALL t590_sub_b_fill(g_wc2)
    END IF
    IF cl_null(g_argv3) THEN
       LET g_argv3 = g_plant 
    END IF
    CALL t590_sub_menu()
    LET g_action_choice = ' '
    CLOSE WINDOW t5901_w 
END FUNCTION         

FUNCTION t590_sub_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsz TO s_lsz.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY

      BEFORE ROW
	 LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION detail
	 LET g_action_choice="detail"
	 LET l_ac = 1
	 LET l_ac = 1
	 EXIT DISPLAY

      ON ACTION help
	 LET g_action_choice="help"
	 EXIT DISPLAY

      ON ACTION locale
	 CALL cl_dynamic_locale()
	  CALL cl_show_fld_cont()

      ON ACTION exit
	 LET g_action_choice="exit"
	 EXIT DISPLAY

      ON ACTION controlg
	 LET g_action_choice="controlg"
	 EXIT DISPLAY

      ON ACTION accept
	 LET g_action_choice="detail"
	 LET l_ac = ARR_CURR()
	 EXIT DISPLAY

      ON ACTION cancel
	     LET INT_FLAG=FALSE
	 LET g_action_choice="exit"
	 EXIT DISPLAY

      ON IDLE g_idle_seconds
	 CALL cl_on_idle()
	 CONTINUE DISPLAY

      ON ACTION about
	 CALL cl_about()

       ON ACTION related_document
	 LET g_action_choice="related_document"
	 EXIT DISPLAY

      ON ACTION exporttoexcel
	 LET g_action_choice = 'exporttoexcel'
	 EXIT DISPLAY


      AFTER DISPLAY
	 CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t590_sub_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000

    LET g_sql =
	"SELECT lszplant,'',lsz03,'',lsz05,lsz04,'',lsz10 ",   
	" FROM lsz_file ",
	" WHERE lsz01 = '",g_lsu01,"' AND lsz12='",g_argv1,"' ",
	"   AND lsz02 = '",g_argv2,"' AND ",g_wc2 CLIPPED,        #單身
        "   AND lsz13 = '",g_lsu02,"' ",       #CHI-C80047 add
	"   AND lszplant = '",g_plant,"'  AND lsz11 = '",g_argv3,"' ",
	" ORDER BY lsz03"
    PREPARE t590_pb FROM g_sql
    DECLARE lsz_curs CURSOR FOR t590_pb 

    CALL g_lsz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH lsz_curs INTO g_lsz[g_cnt].*   #單身 ARRAY 填充
	IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
	SELECT azp02 INTO g_lsz[g_cnt].azp02 FROM azp_file
	   WHERE azp01 =g_lsz[g_cnt].lszplant
	SELECT azp02 INTO g_lsz[g_cnt].azp02_1 FROM azp_file
	   WHERE azp01 =g_lsz[g_cnt].lsz03
	 SELECT oba02 INTO g_lsz[g_cnt].oba02 FROM oba_file
	  WHERE oba01 = g_lsz[g_cnt].lsz04                     

	LET g_cnt = g_cnt + 1
	IF g_cnt > g_max_rec THEN
	   CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
	END IF
    END FOREACH
    CALL g_lsz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION t590_sub_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_n3            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
   p_cmd           LIKE type_file.chr1,                #處理狀態
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_count         LIKE type_file.num5,
   l_cot           LIKE type_file.num5,
   l_lsu06         LIKE lsu_file.lsu06, 
   l_lpq08         LIKE lpq_file.lpq08, 
   l_azp02         LIKE azp_file.azp02
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_azw02     LIKE azw_file.azw02
DEFINE l_lsu11     LIKE lsu_file.lsu11  #制定營運中心
DEFINE l_cnt       LIKE type_file.num5
   LET l_flag = 'N'

   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   IF cl_null(g_argv1) OR cl_null(g_argv2) THEN
      CALL cl_err('','alm-836',1)
      RETURN
   END IF
  #IF g_argv2='1' THEN                     #FUN-C60089 mark
   IF g_argv2 = '1' OR g_argv2 = '2' THEN  #FUN-C60089 add  #almt590/almt591
      SELECT lsu06,lsu11 INTO l_lsu06,l_lsu11 FROM lsu_file 
      WHERE lsu01 = g_lsu01  AND lsu12 = g_argv1 AND lsu11 = g_argv3 
        AND lsu00 = g_lsu00   #FUN-C60089 add 
        AND lsu02 = g_lsu02   #CHI-C80047 add
      IF l_lsu06 ='Y' THEN
        #CALL cl_err(g_argv1,'abm-879',1)   #FUN-C60089 mark
         CALL cl_err('','abm-879',1)
         RETURN
      END IF
      IF g_plant <> l_lsu11 THEN
         CALL cl_err('','art-977',0)
         RETURN
      END IF
   ELSE
     #FUN-C50137 add START
      SELECT lqx05,lqx10 INTO l_lsu06,l_lsu11 FROM lqx_file 
      WHERE lqx01=g_lsu01 AND lqx11 = g_argv1 AND lqx10 = g_argv3
        AND lqx00 = g_lsu00   #FUN-C60089 add
        AND lqx02 = g_lsu02   #CHI-C80047 add
      IF l_lsu06 ='Y' THEN
        #CALL cl_err(g_argv1,'abm-879',1)  #FUN-C60089 mark
         RETURN
      END IF
      IF g_plant <> l_lsu11 THEN
         CALL cl_err('','art-977',0)
         RETURN
      END IF
     #FUN-C50137 add END
   END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT lszplant,'',lsz03,'',lsz05,lsz04,'',lsz10 ",   
                      "  FROM lsz_file WHERE lsz01='",g_lsu01,"' AND lsz02='",g_argv2,"' ",
                      "  AND lsz12 = '",g_argv1,"' ",
                      "  AND lsz11 = '",g_argv3,"' ",
                      "  AND lsz13 = '",g_lsu02,"' ",  #CHI-C80047 add
                      "  AND lsz03= ? AND lsz05= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t590_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_lsz WITHOUT DEFAULTS FROM s_lsz.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
         #IF g_argv2 = '1' OR g_argv2 = '2' THEN                                    #FUN-C60089 mark
          IF g_argv2 = '1' OR g_argv2 = '2' OR g_argv2 = '3' OR g_argv2 = '4' THEN  #FUN-C60089 add 
             CALL cl_set_comp_entry("lsz10",FALSE)
          END IF

       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          CALL t560_sub_entry()  

          IF g_rec_b>=l_ac THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE
             LET g_before_input_done = TRUE
             LET g_lsz_t.* = g_lsz[l_ac].*  #BACKUP
             OPEN t590_bcl USING g_lsz_t.lsz03,g_lsz_t.lsz05
             IF STATUS THEN
                CALL cl_err("OPEN t590_bcl:",STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t590_bcl INTO g_lsz[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lsz_t.lsz04,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL t590_lsz05('d')
                   CALL t590_lsz03('d')
                END IF
             END IF
             CALL cl_show_fld_cont()
             SELECT azp02 INTO g_lsz[l_ac].azp02 FROM azp_file WHERE azp01=g_lsz[l_ac].lszplant
             DISPLAY BY NAME g_lsz[l_ac].azp02
          END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          INITIALIZE g_lsz[l_ac].* TO NULL
          LET g_lsz[l_ac].lsz10 = 'Y'
          LET g_lsz[l_ac].lszplant=g_plant
          SELECT azp02 INTO g_lsz[l_ac].azp02 FROM azp_file WHERE azp01=g_lsz[l_ac].lszplant
          DISPLAY BY NAME g_lsz[l_ac].azp02
          LET g_lsz_t.* = g_lsz[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD lsz03

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t590_bcl
             CANCEL INSERT
          END IF
          IF cl_null(g_lsz[l_ac].lsz05) THEN LET g_lsz[l_ac].lsz05 = ' ' END IF  
          INSERT INTO lsz_file(lszplant,lszlegal,lsz01,lsz02,lsz03,lsz04,lsz05,
                               lsz10,lsz11,lsz12,lsz13 )    #CHI-C80047 add lsz13
          VALUES(g_lsz[l_ac].lszplant,g_legal,g_lsu01,g_argv2,g_lsz[l_ac].lsz03,      
                 g_lsz[l_ac].lsz04,g_lsz[l_ac].lsz05,g_lsz[l_ac].lsz10,
                 g_argv3,g_argv1,g_lsu02 )     #CHI-C80047 add lsu02     
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lsz_file",g_lsz[l_ac].lsz03,"",SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       AFTER FIELD lsz03                        #check 門店加攤位是否重複
          IF NOT cl_null(g_lsz[l_ac].lsz03) THEN
             IF g_lsz[l_ac].lsz03 != g_lsz_t.lsz03 OR
                cl_null(g_lsz_t.lsz03) THEN
               #IF g_argv2 = '1' OR g_argv2 = '2' THEN                                    #FUN-C60089 mark
                IF g_argv2 = '1' OR g_argv2 = '2' OR g_argv2 = '3' OR g_argv2 = '4' THEN  #FUN-C60089 add
                   IF p_cmd = 'a' THEN
                      LET l_n1 = 0
                      SELECT COUNT(*) INTO l_n1 FROM lsz_file
                         WHERE lsz01=g_lsu01 AND lsz02=g_argv2 
                           AND lsz03 = g_lsz[l_ac].lsz03 
                           AND lsz11 = g_argv3
                           AND lsz13 = g_lsu02   #CHI-C80047 add
                      IF l_n1 > 0 THEN
                         CALL cl_err('','-239',0)
                         NEXT FIELD lsz03 
                      END IF
                   END IF
                   IF p_cmd = 'u' AND g_lsz[l_ac].lsz03 <> g_lsz_t.lsz03 THEN
                      SELECT COUNT(*) INTO l_n1 FROM lsz_file
                         WHERE lsz01=g_lsu01 AND lsz02=g_argv2 AND lsz03 = g_lsz[l_ac].lsz03
                         AND lsz12 = g_argv1
                         AND lsz11 = g_argv3 
                         AND lsz13 = g_lsu02  #CHI-C80047 add
                      IF l_n1 > 0 THEN
                         CALL cl_err('','-239',0)
                         NEXT FIELD lsz03 
                      END IF
                   END IF
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_errno = ''  #FUN-C60089 add
                      NEXT FIELD lsz03
                   END IF
                END IF
                CALL t590_check()
                CALL t590_lsz03('a')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_lsz[l_ac].lsz03 = g_lsz_t.lsz03
                  LET g_errno = ''  #FUN-C60089 add
                  NEXT FIELD lsz03
                END IF
             END IF
          ELSE
             LET g_lsz[l_ac].azp02_1=''
             DISPLAY '' TO g_lsz[l_ac].azp02_1
          END IF

        AFTER FIELD lsz05
           IF g_lsz[l_ac].lsz05 IS NOT NULL THEN
              IF g_lsz[l_ac].lsz05 != g_lsz_t.lsz05 OR
                 g_lsz_t.lsz05 IS NULL THEN
                 CALL t590_check()
                 CALL t590_lsz05('a')
                 IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_lsz[l_ac].lsz05 = g_lsz_t.lsz05
                   LET g_errno = ''  #FUN-C60089 add
                   NEXT FIELD lsz05 
                 END IF
              END IF
           ELSE
              LET g_lsz[l_ac].lsz05=' '
              CALL t590_check()
              IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                LET g_lsz[l_ac].lsz05 = g_lsz_t.lsz05
                LET g_errno = ''  #FUN-C60089 add
                NEXT FIELD lsz05 
              END IF
              LET g_lsz[l_ac].lsz04=''
              DISPLAY '' TO lsz04 
              DISPLAY '' TO oba02                
           END IF
           IF cl_null(g_lsz[l_ac].lsz05) THEN
              LET g_lsz[l_ac].lsz04=''
              LET g_lsz[l_ac].oba02=''            
           END IF

       BEFORE DELETE                            #是否取消單身
          IF g_lsz_t.lsz03 IS NOT NULL THEN
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM lni_file
               WHERE lni04 = g_lsz[l_ac].lsz03 AND lni01 = g_lsu01
                #AND lni02 = '1'       #FUN-C50137 mark
                 AND lni02 = g_argv2   #FUN-C50137 add
                 AND lniplant = g_plant             
             IF l_cnt > 0 THEN
                CALL cl_err('','alm-h38',0) 
                 CANCEL DELETE
                NEXT FIELD CURRENT 
             END IF
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "lsz03"               
             LET g_doc.value1 = g_lsz[l_ac].lsz03
             CALL cl_del_doc()                       
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM lsz_file WHERE lsz03 = g_lsz_t.lsz03 AND lsz05=g_lsz_t.lsz05
                                    AND lsz01 = g_lsu01 AND lsz02 = g_argv2 AND lsz12 = g_argv1
                                    AND lsz13 = g_lsu02     #CHI-C80047 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lsz_file",g_lsz_t.lsz03,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lsz[l_ac].* = g_lsz_t.*
             CLOSE t590_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lsz[l_ac].lsz03,-263,0)
             LET g_lsz[l_ac].* = g_lsz_t.*
          ELSE
             UPDATE lsz_file SET lsz03=g_lsz[l_ac].lsz03,
                                 lsz04=g_lsz[l_ac].lsz04,
                                 lsz05=g_lsz[l_ac].lsz05,
                                 lsz10=g_lsz[l_ac].lsz10
              WHERE lsz03 = g_lsz_t.lsz03
                AND lsz01 = g_lsu01
                AND lsz02 = g_argv2
                AND lsz12 = g_argv1
                AND lsz13 = g_lsu02   #CHI-C80047 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lsz_file",g_lsz_t.lsz03,"",SQLCA.sqlcode,"","",1)
                LET g_lsz[l_ac].* = g_lsz_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增

          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lsz[l_ac].* = g_lsz_t.*
             END IF
             CLOSE t590_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF

          CLOSE t590_bcl               # 新增
          COMMIT WORK

       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lsz03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.where=" azw01 IN ",g_auth," "
                 IF cl_null(g_lsz[l_ac].lsz03) THEN      
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_count  FROM lsz_file
                          WHERE lsz01 = g_lsu01 AND lsz02 = g_argv2
                           AND lsz03 = l_plant AND lsz05 = ' '
                           AND lsz11 = g_argv3   
                           AND lsz13 = g_lsu02    #CHI-C80047 add
                         IF l_count > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01= g_plant
                       IF cl_null(g_lsz[l_ac].lsz05) THEN LET g_lsz[l_ac].lsz05 = ' ' END IF  
                       INSERT INTO lsz_file(lszplant,lszlegal,lsz01,lsz02,lsz03,lsz04,lsz05,
                                            lsz10,lsz11,lsz12,lsz13 )   #CHI-C80047 add lsz13
                       VALUES(g_plant,g_legal,g_lsu01,g_argv2,l_plant,
                              g_lsz[l_ac].lsz04,g_lsz[l_ac].lsz05,g_lsz[l_ac].lsz10,
                              g_argv3,g_argv1,g_lsu02 )   #CHI-C80047 add lsu02
                    END WHILE
                    LET l_flag = 'Y'
                    EXIT INPUT
                 ELSE
                    CALL cl_create_qry() RETURNING g_lsz[l_ac].lsz03
                 END IF
           END CASE

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lsz03) AND l_ac > 1 THEN
             LET g_lsz[l_ac].* = g_lsz[l_ac-1].*
             NEXT FIELD lsz03
          END IF

       ON ACTION CONTROLR
          CALL cl_show_req_fields()


       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT
   IF l_flag = 'Y' THEN
       CALL t590_sub_b_fill(" 1=1")
       CALL t590_sub_b()
   END IF
   CLOSE t590_bcl
   COMMIT WORK

END FUNCTION

FUNCTION t590_lsz03(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_azp02   LIKE azp_file.azp02
    DEFINE   l_rtz28   LIKE rtz_file.rtz28 

    IF NOT cl_null(g_errno) AND p_cmd !='d'THEN
       RETURN
    END IF
    LET g_sql = " SELECT azp02 FROM azp_file,azw_file",
                "  WHERE azp01='",g_lsz[l_ac].lsz03,"'",
                "    AND azw01=azp01",
                "    AND azp01 IN ",g_auth," "
    PREPARE sel_azp_pre01 FROM g_sql
    EXECUTE sel_azp_pre01 INTO l_azp02
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='art-500'
                                LET l_azp02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE

    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_lsz[l_ac].azp02_1=l_azp02
       DISPLAY BY NAME g_lsz[l_ac].azp02_1
    END IF
END FUNCTION

FUNCTION t590_lsz05(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_azp02      LIKE azp_file.azp02
DEFINE l_lml02      LIKE lml_file.lml02
DEFINE l_lml06      LIKE lml_file.lml06

    IF NOT cl_null(g_errno) THEN
       RETURN
    END IF
    IF cl_null(g_lsz[l_ac].lsz05) AND p_cmd !='d' THEN
       SELECT lmlstore INTO g_lsz[l_ac].lsz03 FROM lml_file
        WHERE lml01=g_lsz[l_ac].lsz05
       IF SQLCA.sqlcode=100 THEN
          LET g_errno='alm-840'
          RETURN
       END IF
       LET g_sql = " SELECT azp02 FROM azp_file",
                   "  WHERE azp01='",g_lsz[l_ac].lsz03,"'",
                   "    AND azp01 IN ",g_auth," "
       PREPARE sel_azp_pre02 FROM g_sql
       EXECUTE sel_azp_pre02 INTO l_azp02
       IF SQLCA.sqlcode=100 THEN
          LET g_lsz[l_ac].lsz03 = g_lsz_t.lsz03
          LET g_errno='art-500'
          RETURN
       END IF
       LET g_lsz[l_ac].azp02_1=l_azp02
       DISPLAY BY NAME g_lsz[l_ac].azp02_1
       DISPLAY BY NAME g_lsz[l_ac].lsz03
    END IF
    SELECT lml02,lml06
      INTO l_lml02,l_lml06
      FROM lml_file
     WHERE lml01=g_lsz[l_ac].lsz05

      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                  LET l_lml02=NULL
           WHEN l_lml06='N'       LET g_errno='9028'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE

    IF cl_null(g_errno) OR p_cmd= 'd' THEN
       LET g_lsz[l_ac].lsz04=l_lml02
        SELECT oba02
          INTO g_lsz[l_ac].oba02
          FROM oba_file
         WHERE oba01 =g_lsz[l_ac].lsz04
        DISPLAY BY NAME g_lsz[l_ac].lsz04
        DISPLAY BY NAME g_lsz[l_ac].oba02
    END IF

END FUNCTION

FUNCTION t590_check()
DEFINE    l_n             LIKE type_file.num5,
          l_n1            LIKE type_file.num5,
          l_n2            LIKE type_file.num5

    IF NOT cl_null(g_lsz[l_ac].lsz03) AND g_lsz[l_ac].lsz05 IS NOT NULL  THEN
       SELECT count(*) INTO l_n FROM lsz_file
        WHERE lsz01=g_lsu01 AND lsz02=g_argv2 AND lsz03 = g_lsz[l_ac].lsz03
          AND lsz05 = g_lsz[l_ac].lsz05
          AND lsz11 = g_argv3
          AND lsz13 = g_lsu02   #CHI-C80047 add
       IF l_n>0 THEN
           LET g_errno='alm-835'
           RETURN
       END IF
    END IF
    IF NOT cl_null(g_lsz[l_ac].lsz03) AND NOT cl_null(g_lsz[l_ac].lsz05) THEN
       SELECT COUNT(*) INTO l_n1 FROM lml_file
        WHERE lml01=g_lsz[l_ac].lsz05
          AND lmlstore=g_lsz[l_ac].lsz03
       IF l_n1=0 THEN
          LET g_errno='alm-837'
          RETURN
       END IF
    END IF
END FUNCTION

FUNCTION t590_sub_chk_lsz03()
   DEFINE l_lsu02        LIKE lsu_file.lsu02
   DEFINE l_sql          STRING
   DEFINE l_n            LIKE type_file.num5

   LET l_lsu02 = g_lsu02  #CHI-C80047 add
 #CHI-C80047 mark START
 # LET g_errno = ' '
 ##IF g_argv2 = '1' THEN  #FUN-C60089 mark
 # IF g_argv2 = '1' OR g_argv2 = '2' THEN  #FUN-C60089 add
 #    SELECT lsu03 INTO l_lsu02 FROM lsu_file 
 #     WHERE lsu01 = g_lsu01 AND lsu12 = g_argv1
 #       AND lsu00 = g_lsu00   #FUN-C60089 add
 # ELSE
 #    SELECT lqx02 INTO l_lsu02 FROM lqx_file 
 #     WHERE lqx01 = g_lsu01 AND lqx13 = g_argv1 
 #       AND lqx00 = g_lsu00   #FUN-C60089 add
 # END IF
 #CHI-C80047 mark END
   IF cl_null(l_lsu02) THEN RETURN END IF
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_lsz[l_ac].lsz03, 'lnk_file'),
               "   WHERE lnk01 = '",l_lsu02,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
               "      AND lnk03 = '",g_lsz[l_ac].lsz03,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_lsz[l_ac].lsz03) RETURNING l_sql
   PREPARE trans_cnt FROM l_sql
   EXECUTE trans_cnt INTO l_n

   IF l_n = 0 OR cl_null(l_n) THEN
      LET g_errno = 'alm-h33'
      RETURN
   END IF
END FUNCTION

FUNCTION t560_sub_entry()  #已存在原先單內的營運中心,不允許修改,只允許有效否的修改  
DEFINE l_n          LIKE type_file.num5

   LET l_n = 0
   IF cl_null(g_lsz[l_ac].lsz03) THEN 
      CALL cl_set_comp_entry("lsz03",TRUE)
      CALL cl_set_comp_entry("lsz10",FALSE)
   ELSE 
      SELECT COUNT(*) INTO l_n FROM lni_file
        WHERE lni04 = g_lsz[l_ac].lsz03 AND lni01 = g_lsu01 
         #AND lni02 = '1'         #FUN-C50137 add
          AND lni02 = g_argv2     #FUN-C50137 add
          AND lniplant = g_plant
      IF l_n = 0 OR cl_null(l_n) THEN
         CALL cl_set_comp_entry("lsz03",TRUE)
         CALL cl_set_comp_entry("lsz10",FALSE)
      ELSE
         CALL cl_set_comp_entry("lsz03",FALSE)
         CALL cl_set_comp_entry("lsz10",TRUE)
      END IF
   END IF
END FUNCTION
#FUN-C50085 
