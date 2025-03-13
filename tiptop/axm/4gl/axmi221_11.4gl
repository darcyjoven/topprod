# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: axmi221_11.4gl
# Descriptions...: 客戶主檔--送貨地址--維護作業
# Date & Author..: 06/01/09 By yoyo
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C50070 12/06/05 By Sakura 修改aza50判斷,統一call customer_address1,並將開啟的畫面加入ocd230及ocd231欄位
# Modify.........: No:CHI-C60034 12/08/30 By pauline 不判斷狀態碼皆可讓使用者修改資料 
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ocd           DYNAMIC ARRAY OF RECORD
        ocd02           LIKE ocd_file.ocd02,
        ocd03           LIKE ocd_file.ocd03,
        ocd04           LIKE ocd_file.ocd04,
        ocd221          LIKE ocd_file.ocd221,
        ocd222          LIKE ocd_file.ocd222,
        ocd223          LIKE ocd_file.ocd223,
#FUN-C50070 add begin-------------------------
        ocd230          LIKE ocd_file.ocd230,
        ocd231          LIKE ocd_file.ocd231,
#FUN-C50070 add -end--------------------------
        ocd224          LIKE ocd_file.ocd224,
        ocd225          LIKE ocd_file.ocd225,
        ocd226          LIKE ocd_file.ocd226,
        ocd227          LIKE ocd_file.ocd227,
        ocd228          LIKE ocd_file.ocd228,
        ocd229          LIKE ocd_file.ocd229
                    END RECORD,
                    
    g_ocd_t         RECORD
        ocd02           LIKE ocd_file.ocd02,
        ocd03           LIKE ocd_file.ocd03, 
        ocd04           LIKE ocd_file.ocd04,
        ocd221          LIKE ocd_file.ocd221, 
        ocd222          LIKE ocd_file.ocd222,
        ocd223          LIKE ocd_file.ocd223,
#FUN-C50070 add begin-------------------------
        ocd230          LIKE ocd_file.ocd230,
        ocd231          LIKE ocd_file.ocd231,
#FUN-C50070 add -end--------------------------
        ocd224          LIKE ocd_file.ocd224,
        ocd225          LIKE ocd_file.ocd225,
        ocd226          LIKE ocd_file.ocd226,
        ocd227          LIKE ocd_file.ocd227,
        ocd228          LIKE ocd_file.ocd228,
        ocd229          LIKE ocd_file.ocd229
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,          #單身筆數       #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT     #No.FUN-680137 SMALLINT
    p_row,p_col     LIKE type_file.num5           #No.FUN-680137 SMALLINT
  
    
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE  SQL  
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680137 SMALLINT
DEFINE   g_ocd01         LIKE ocd_file.ocd01
 
FUNCTION i221_11(p_ocd01)
    DEFINE p_ocd01           LIKE ocd_file.ocd01

    WHENEVER ERROR CALL cl_err_msg_log
  
    IF cl_null(p_ocd01) THEN
         CALL cl_err('','atm-047',1)
         RETURN
    ELSE
	LET g_ocd01 = p_ocd01
    END IF
  
    OPEN WINDOW i221_11_w WITH FORM "axm/42f/axmi221_11" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_locale("axmi221_11")
 
    LET  g_wc2= "ocd01 = ","'",g_ocd01,"'"
    CALL i221_11_b_fill(g_wc2)
    CALL i221_11_menu()
    CLOSE WINDOW i221_11_w                 #結束畫面
 
END FUNCTION
 
FUNCTION i221_11_menu()
 
   WHILE TRUE
      CALL i221_11_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i221_11_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "accept"
           IF cl_chk_act_auth() THEN
              CALL i221_11_b()
           ELSE                                                                
              LET g_action_choice = NULL                                       
           END IF                               
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i221_11_b()
DEFINE
   l_occ1004       LIKE occ_file.occ1004,
   l_occacti       LIKE occ_file.occacti,
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680137 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,                #可新增否          #No.FUN-680137 VARCHAR(1)
   l_allow_delete  LIKE type_file.chr1                 #可刪除否          #No.FUN-680137 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_forupd_sql = "SELECT ocd02,ocd03,ocd04,ocd221,ocd222,ocd223,",
                      "ocd230,ocd231,", #FUN-C50070 add
                      "ocd224,ocd225,ocd226,",
                      "ocd227,ocd228,ocd229", 
                      " FROM ocd_file ",
                      "  WHERE ocd01= ? ",
                      "   AND ocd02= ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i221_11_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
        
   INPUT ARRAY g_ocd WITHOUT DEFAULTS FROM s_ocd.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
     BEFORE INPUT
      
     #CHI-C60034 mark START
     #不判斷狀態碼皆可讓使用者修改資料    
     ##判斷若客戶已審核則不允許進入單身進行相應的動作 added by chou 051024
     #SELECT occ1004 INTO l_occ1004
     #  FROM occ_file
     # WHERE occ01=g_ocd01
#    # IF l_occ1004!='1' THEN     #No.FUN-690025
     # IF l_occ1004!='0' THEN     #No.FUN-690025
     #    CALL cl_err(g_ocd01,'atm-046',1)
     #    EXIT INPUT
     # END IF
     #CHI-C60034 mark START

      SELECT occacti INTO l_occacti
        FROM occ_file
       WHERE occ01=g_ocd01
       IF l_occacti='N' THEN
          CALL cl_err(g_ocd01,'mfg0301',1)
          EXIT INPUT
       END IF
       
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_ocd_t.* = g_ocd[l_ac].*  #BACKUP
             OPEN i221_11_bcl USING g_ocd01,g_ocd_t.ocd02
             IF STATUS THEN
                CALL cl_err("OPEN i221_11_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i221_11_bcl INTO g_ocd[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ocd01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_ocd[l_ac].* TO NULL      #900423
          LET g_ocd_t.* = g_ocd[l_ac].*         #新輸入資料         
          NEXT FIELD ocd02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO ocd_file(ocd01,ocd02,ocd03,ocd04,ocd221,ocd222,ocd223,ocd230,ocd231, #FUN-C50070 add 230,231
                         ocd224,ocd225,ocd226,ocd227,ocd228,ocd229)
          VALUES(g_ocd01,g_ocd[l_ac].ocd02,g_ocd[l_ac].ocd03,g_ocd[l_ac].ocd04,g_ocd[l_ac].ocd221,
                #g_ocd[l_ac].ocd222,g_ocd[l_ac].ocd223,g_ocd[l_ac].ocd224,g_ocd[l_ac].ocd225, #FUN-C50070 mark
                 g_ocd[l_ac].ocd222,g_ocd[l_ac].ocd223,g_ocd[l_ac].ocd230,g_ocd[l_ac].ocd231, #FUN-C50070 add
                 g_ocd[l_ac].ocd224,g_ocd[l_ac].ocd225,                                       #FUN-C50070 add
                 g_ocd[l_ac].ocd226,g_ocd[l_ac].ocd227,g_ocd[l_ac].ocd228,g_ocd[l_ac].ocd229)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_ocd[l_ac].ocd02,SQLCA.sqlcode,0)   #No.FUN-660167
             CALL cl_err3("ins","ocd_file",g_ocd01,g_ocd[l_ac].ocd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
#            COMMIT WORK
          END IF
 
       AFTER FIELD ocd02                        #check 編號是否重復
          IF NOT cl_null(g_ocd[l_ac].ocd02) THEN
             IF g_ocd[l_ac].ocd02 != g_ocd_t.ocd02 OR
                g_ocd_t.ocd02 IS NULL THEN
                SELECT count(*) INTO l_n 
                  FROM ocd_file
                 WHERE ocd02 = g_ocd[l_ac].ocd02
                   AND ocd01 = g_ocd01
                IF l_n > 0 THEN
                   CALL cl_err('ocd02','axm-220',1)
                    LET g_ocd[l_ac].ocd02 = g_ocd_t.ocd02
                   NEXT FIELD ocd02
                END IF
             END IF
          END IF
       		
       BEFORE DELETE                            #是否取消單身
          IF g_ocd_t.ocd02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM ocd_file 
              WHERE     ocd02 = g_ocd_t.ocd02
                    AND ocd01 = g_ocd01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ocd_t.ocd02,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("del","ocd_file",g_ocd01,g_ocd_t.ocd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
             LET g_ocd[l_ac].* = g_ocd_t.*
             CLOSE i221_11_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_ocd[l_ac].ocd02,-263,0)
             LET g_ocd[l_ac].* = g_ocd_t.*
          ELSE
             UPDATE ocd_file SET ocd01=g_ocd01,
                                 ocd02=g_ocd[l_ac].ocd02,
                                 ocd03=g_ocd[l_ac].ocd03,
                                 ocd04=g_ocd[l_ac].ocd04,
                                 ocd221=g_ocd[l_ac].ocd221,
                                 ocd222=g_ocd[l_ac].ocd222,
                                 ocd223=g_ocd[l_ac].ocd223,
                                 ocd230=g_ocd[l_ac].ocd230,  #FUN-C50070 add
                                 ocd231=g_ocd[l_ac].ocd231,  #FUN-C50070 add
                                 ocd224=g_ocd[l_ac].ocd224,
                                 ocd225=g_ocd[l_ac].ocd225,
                                 ocd226=g_ocd[l_ac].ocd226,
                                 ocd227=g_ocd[l_ac].ocd227,
                                 ocd228=g_ocd[l_ac].ocd228,
                                 ocd229=g_ocd[l_ac].ocd229
               WHERE ocd02 = g_ocd_t.ocd02
                 AND ocd01 = g_ocd01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ocd[l_ac].ocd02,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("upd","ocd_file",g_ocd01,g_ocd_t.ocd02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                LET g_ocd[l_ac].* = g_ocd_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac       #FUN-D30034 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_ocd[l_ac].* = g_ocd_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_ocd.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE i221_11_bcl 
             ROLLBACK WORK 
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30034 add 
          CLOSE i221_11_bcl 
          COMMIT WORK
          
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about 
        CALL cl_about()
 
     ON ACTION help   
        CALL cl_show_help()
 
       
   END INPUT
 
   CLOSE i221_11_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i221_11_b_fill(p_wc2)    
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
      
    LET g_sql =
        "SELECT ocd02,ocd03,ocd04,ocd221,ocd222,ocd223,",
        "ocd230,ocd231,", #FUN-C50070 add
        "ocd224,ocd225,ocd226,",
        "ocd227,ocd228,ocd229",
        " FROM ocd_file ",
        " WHERE ", p_wc2 CLIPPED,
        " ORDER BY ocd02"
    PREPARE i221_11_pb FROM g_sql
    DECLARE ocd_curs CURSOR FOR i221_11_pb
 
    CALL g_ocd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ocd_curs INTO g_ocd[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ocd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i221_11_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocd TO s_ocd.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION about 
        CALL cl_about() 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
