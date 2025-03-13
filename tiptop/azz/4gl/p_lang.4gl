# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_lang.4gl
# Descriptions...: 語言別設定維護作業
# Date & Author..: 03/10/16 alex
# Modify.........: No.MOD-490436 04/09/27 By alex 增 accept delete,新增在單身後變更gay02
# Modify.........: No.MOD-470254 05/01/05 By alex 功能修正
# Modify.........: No.MOD-580056 05/08/04 By yiting key可更改
# Modify.........: No.MOD-580359 05/08/30 By alex 取消無用的 output
# Modify.........: No.MOD-580387 05/09/21 By alex 取消 MOD-580056
# Modify.........: No.FUN-5A0002 05/10/18 By alex Keep some ID for system using.
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-830021 08/03/05 By alex 取消 gay02,p_gay_item 使用
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-880019 08/09/04 By alex 限制新增項目,匯入語言包
 
IMPORT os   #FUN-830021
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gay                DYNAMIC ARRAY OF RECORD 
         gay01         LIKE gay_file.gay01,  
         gay03         LIKE gay_file.gay03,
         gayacti       LIKE gay_file.gayacti
                            END RECORD 
DEFINE g_gay_t              RECORD 
         gay01         LIKE gay_file.gay01,  
         gay03         LIKE gay_file.gay03,
         gayacti       LIKE gay_file.gayacti
                            END RECORD 
DEFINE g_wc2                STRING 
DEFINE g_sql                STRING 
DEFINE g_rec_b              LIKE type_file.num5    # 單身筆數   #No.FUN-680135 SMALLINT
DEFINE l_ac                 LIKE type_file.num5    # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE g_forupd_sql         STRING
DEFINE g_before_input_done  LIKE type_file.num5   #NO.580056         #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)                  # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_lang_w WITH FORM "azz/42f/p_lang"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = " SELECT gay01,gay03,gayacti FROM gay_file ",
                       "  WHERE gay01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_lang_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_wc2 = '1=1'         #FUN-830021
   CALL p_lang_b_fill(g_wc2)
   CALL p_lang_menu()
 
   CLOSE WINDOW p_lang_w                           # 結束畫面
   CALL  cl_used(g_prog,g_time,2)                  # 計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
 
FUNCTION p_lang_menu()
 
   WHILE TRUE
      CALL p_lang_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_lang_q()
         END IF
 
       WHEN "detail"                            # "B.單身"
          IF cl_chk_act_auth() THEN
             CALL p_lang_b()
          ELSE
             LET g_action_choice = " "
          END IF
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "exporttoexcel"   #No.FUN-4B0020
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gay),'','')
         END IF
 
      WHEN "chkdirstruct"    #FUN-830021
        IF cl_chk_act_auth() THEN
           CALL p_lang_chkdir()
        END IF
 
      WHEN "invalid"         #FUN-830021
        IF cl_chk_act_auth() THEN
           CALL p_lang_x()
        END IF
 
      WHEN "import_langpack"  #FUN-880019
        IF cl_chk_act_auth() THEN
           CALL p_lang_langpack()
        END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_lang_q()
   CALL p_lang_b_askkey()
END FUNCTION
 
FUNCTION p_lang_b()
 
DEFINE   l_ac_t          LIKE type_file.num5,                   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
         l_n             LIKE type_file.num5,                   # 檢查重複用        #No.FUN-680135 SMALLINT
         l_modify_flag   LIKE type_file.chr1,                   # 單身更改否        #No.FUN-680135 VARCHAR(1)
         l_lock_sw       LIKE type_file.chr1,                   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
         l_exit_sw       LIKE type_file.chr1,                   #FUN-680135         VARCHAR(1) # Esc結束INPUT ARRAY 否
         p_cmd           LIKE type_file.chr1,                   # 處理狀態          #No.FUN-680135 VARCHAR(1)
         l_allow_insert  LIKE type_file.num5,                   # 可否新增          #No.FUN-680135 SMALLINT
         l_allow_delete  LIKE type_file.num5,                   # 可否刪除          #No.FUN-680135 SMALLINT
         l_jump          LIKE type_file.num5                    #FUN-680135         SMALLINT # 判斷是否跳過AFTER ROW的處理
 
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = FALSE  #已建立語系資料不可刪除,可de-active FUN-830021
 
   INPUT ARRAY g_gay WITHOUT DEFAULTS FROM s_gay.*
      ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
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
            LET g_gay_t.* = g_gay[l_ac].*  #BACKUP
# MOD-580387   #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_lang_set_entry_b(p_cmd)
#           CALL p_lang_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
# #No.MOD-580056 --end
            OPEN p_lang_bcl USING g_gay_t.gay01
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_lang_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_lang_bcl INTO g_gay[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_lang_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gay[l_ac].* TO NULL      #900423
          LET g_gay[l_ac].gayacti = "N"
          LET g_gay_t.* = g_gay[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
 
       AFTER INSERT     #FUN-830021
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE p_lang_bcl
             CANCEL INSERT
          ELSE
             IF NOT cl_confirm("azz-106") THEN   #FUN-830021
                CANCEL INSERT
             END IF
             IF NOT p_lang_mkdir(g_gay[l_ac].gay01) THEN
                CANCEL INSERT
             END IF
             BEGIN WORK
             INSERT INTO gay_file(gay01,gay03,gayacti,gayuser,gaygrup,gaydate,gayoriu,gayorig)
                    VALUES(g_gay[l_ac].gay01,g_gay[l_ac].gay03,
                           g_gay[l_ac].gayacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","gay_file",g_gay[l_ac].gay01,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL INSERT
             ELSE
                COMMIT WORK
             END IF
          END IF
 
       AFTER FIELD gay01 
          #check 代號+語言別是否重複    #FUN-880019
          IF p_cmd="a" AND g_gay[l_ac].gay01 MATCHES "[01-9a-p]" THEN
           #(g_gay[l_ac].gay01='0' OR g_gay[l_ac].gay01='1' OR
           # g_gay[l_ac].gay01='2') THEN
             CALL cl_err_msg(NULL,"azz-222",g_gay[l_ac].gay01,40)
             NEXT FIELD gay01
          END IF #FUN-5A0002
          IF g_gay[l_ac].gay01 != g_gay_t.gay01 AND
             NOT cl_null(g_gay[l_ac].gay01) THEN 
             SELECT count(*) INTO l_n FROM gay_file
              WHERE gay01 = g_gay[l_ac].gay01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_gay[l_ac].gay01 = g_gay_t.gay01
                DISPLAY g_gay[l_ac].gay01 TO gay01
                NEXT FIELD gay01
             END IF
          END IF
 
#      BEFORE FIELD gay03    #FUN-830021
#         IF NOT cl_null(g_gay[l_ac].gay01) THEN
#            IF NOT p_gay_item(g_gay[l_ac].gay01) THEN
#               # Record update successfully
#            END IF
#         END IF
#         NEXT FIELD gay01
 
       BEFORE DELETE                            #是否取消單身
          IF g_gay_t.gay01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM gay_file WHERE gay01 = g_gay_t.gay01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","gay_file",g_gay_t.gay01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
                ROLLBACK WORK 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             CLOSE p_lang_bcl
             COMMIT WORK 
          END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gay[l_ac].* = g_gay_t.*
             CLOSE p_lang_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gay[l_ac].gay01,-263,1)
             LET g_gay[l_ac].* = g_gay_t.*
          ELSE
             UPDATE gay_file SET gay01 = g_gay[l_ac].gay01,
                                 gay03 = g_gay[l_ac].gay03,
                                 gaymodu = g_user,
                                 gaydate = g_today
              WHERE gay01=g_gay_t.gay01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gay_file",g_gay_t.gay01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
                LET g_gay[l_ac].* = g_gay_t.*
             ELSE
                CLOSE p_lang_bcl
                COMMIT WORK 
             END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gay[l_ac].* = g_gay_t.*
             #FUN-D30034---add---str---
             ELSE
                CALL g_gay.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034---add---end---
             END IF
             CLOSE p_lang_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE p_lang_bcl
          COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gay01) AND l_ac > 1 THEN
             LET g_gay[l_ac].* = g_gay[l_ac-1].*
             NEXT FIELD gay01
          END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE p_lang_bcl
   COMMIT WORK 
END FUNCTION
 
FUNCTION p_lang_b_askkey()
    CLEAR FORM
    CALL g_gay.clear()
    CONSTRUCT g_wc2 ON gay01,gay03,gayacti
         FROM s_gay[1].gay01,s_gay[1].gay03,s_gay[1].gayacti
#TQC-860017 start
       ON ACTION about
          CALL cl_about()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gayuser', 'gaygrup') #FUN-980030
#TQC-860017 end   
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p_lang_b_fill(g_wc2)
 
END FUNCTION
 
 
 
FUNCTION p_lang_b_fill(p_wc2)              #BODY FILL UP
 
   DEFINE p_wc2       STRING
 
    LET g_sql = " SELECT gay01,gay03,gayacti FROM gay_file ",
                 " WHERE ", p_wc2 CLIPPED,                     #單身
                 " ORDER BY gay01"
 
    PREPARE p_lang_pb FROM g_sql
    DECLARE gay_curs CURSOR FOR p_lang_pb
 
    CALL g_gay.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
 
    FOREACH gay_curs INTO g_gay[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
           CALL cl_err('foreach:',SQLCA.SQLCODE,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_gay.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt=0
END FUNCTION
 
 
FUNCTION p_lang_bp(p_ud)
 
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gay TO s_gay.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query                  # Q.查詢
           LET g_action_choice="query"
           EXIT DISPLAY
 
         ON ACTION detail                 # B.單身
            LET g_action_choice="detail"
            EXIT DISPLAY
 
#       ON ACTION output                  #MOD-580359
#          LET g_action_choice="output"
#          EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION cancel
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION exit                   # Esc.結束
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help                   # H.說明
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exporttoexcel   #No.FUN-830021
           LET g_action_choice = "exporttoexcel"
           EXIT DISPLAY
 
        ON ACTION chkdirstruct    #FUN-830021
           LET g_action_choice="chkdirstruct"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION invalid         #FUN-830021
           LET g_action_choice="invalid"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION import_langpack      #FUN-880019
           LET g_action_choice="import_langpack"
           EXIT DISPLAY
 
#以下為保護段action寫於此,以大括號保護,本作業無用,但也請勿移除 FUN-880019
{
   ON ACTION backup_data   #資料備份
   ON ACTION make_confirm  #筆數確認
   ON ACTION make_clean    #清除資料
   ON ACTION install_pack  #安裝套件
}
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_lang_mkdir(lc_gay01)   #FUN-830021
 
   DEFINE lc_gay01     LIKE gay_file.gay01
   DEFINE ls_top       STRING
   DEFINE ls_cmd       STRING
   DEFINE ls_tmp       STRING
   DEFINE li_cnt       LIKE type_file.num5
   DEFINE lc_default   LIKE gay_file.gay01
   DEFINE li_err       LIKE type_file.num5 
 
   #確認是否為中英文版, 若為中英文版則以英文為主, 無則以繁體中文為主
   SELECT COUNT(*) INTO li_cnt FROM gay_file WHERE gay01="1"
   IF li_cnt > 0 THEN
      LET lc_default = "1"
   ELSE
      LET lc_default = "0"
   END IF
 
   FOR li_cnt = 1 TO 2
      CASE
         WHEN li_cnt = 1 LET ls_top = FGL_GETENV("TOP")
         WHEN li_cnt = 2 LET ls_top = FGL_GETENV("CUST")
         OTHERWISE EXIT FOR
      END CASE
 
      #Build config/4ad/[lang_id]
      LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"config"),"4ad")
      IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
         CALL cl_cp_r(os.Path.join(ls_cmd,lc_default),os.Path.join(ls_cmd,lc_gay01 CLIPPED))
              RETURNING li_err,ls_tmp
         IF NOT li_err THEN 
            CALL cl_err_msg(NULL,"azz-287",os.Path.join(ls_cmd,lc_default)||"|"||os.Path.join(ls_cmd,lc_gay01 CLIPPED),20)
            RETURN FALSE
         END IF
      END IF
 
      #Build doc/help/[lang_id]
      LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"doc"),"help")
      IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
         CALL cl_cp_r(os.Path.join(ls_cmd,lc_default),os.Path.join(ls_cmd,lc_gay01 CLIPPED)) 
              RETURNING li_err,ls_tmp
         IF NOT li_err THEN 
            CALL cl_err_msg(NULL,"azz-287",os.Path.join(ls_cmd,lc_default)||"|"||os.Path.join(ls_cmd,lc_gay01 CLIPPED),20)
            RETURN FALSE
         END IF
      END IF
 
      IF li_cnt = 1 THEN
         #Build config/4sm/[lang_id]
         LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"config"),"4sm")
         IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
            CALL cl_cp_r(os.Path.join(ls_cmd,lc_default),os.Path.join(ls_cmd,lc_gay01 CLIPPED))
                 RETURNING li_err,ls_tmp
            IF NOT li_err THEN 
               CALL cl_err_msg(NULL,"azz-287",os.Path.join(ls_cmd,lc_default)||"|"||os.Path.join(ls_cmd,lc_gay01 CLIPPED),20)
               RETURN FALSE
            END IF
         END IF
 
         #Build doc/sop/[lang_id]
         LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"doc"),"sop")
         IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
            CALL cl_cp_r(os.Path.join(ls_cmd,lc_default),os.Path.join(ls_cmd,lc_gay01 CLIPPED)) 
                 RETURNING li_err,ls_tmp
            IF NOT li_err THEN 
               CALL cl_err_msg(NULL,"azz-287",os.Path.join(ls_cmd,lc_default)||"|"||os.Path.join(ls_cmd,lc_gay01 CLIPPED),20)
               RETURN FALSE
            END IF
         END IF
      END IF
   END FOR
 
   RETURN TRUE
 
END FUNCTION
 
 
FUNCTION p_lang_chkdir()   #FUN-830021
 
   DEFINE lc_gay01     LIKE gay_file.gay01
   DEFINE ls_top       STRING
   DEFINE ls_cmd       STRING
   DEFINE li_cnt       LIKE type_file.num5   #FUN-810093
   DEFINE ls_tmp       STRING
 
   IF cl_null(g_gay[l_ac].gay01) THEN
      CALL cl_err('',-400,0)
      RETURN
   ELSE
      LET lc_gay01 = g_gay[l_ac].gay01
      LET ls_tmp = ""
   END IF
   
   FOR li_cnt = 1 TO 2      #FUN-810093
      CASE
         WHEN li_cnt = 1 LET ls_top = FGL_GETENV("TOP")
         WHEN li_cnt = 2 LET ls_top = FGL_GETENV("CUST")
         OTHERWISE EXIT FOR
      END CASE
 
      #Check config/4ad/[lang_id]
      LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"config"),"4ad")
      IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
         LET ls_tmp = ls_tmp,"\n",os.Path.join(ls_cmd,lc_gay01 CLIPPED)
      END IF
 
      #Check doc/help/[lang_id]
      LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"doc"),"help")
      IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
         LET ls_tmp = ls_tmp,"\n",os.Path.join(ls_cmd,lc_gay01 CLIPPED)
      END IF
 
      IF li_cnt = 1 THEN
         #Check config/4ad/[lang_id]/tiptop.4ad
         LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"config"),"4ad")
         LET ls_cmd = os.Path.join(ls_cmd.trim(),lc_gay01 CLIPPED)
         IF NOT os.Path.exists(os.Path.join(ls_cmd,"tiptop.4ad")) THEN
            LET ls_tmp = ls_tmp,"\n",os.Path.join(ls_cmd,"tiptop.4ad" CLIPPED)
         END IF
 
         #Check config/4sm/[lang_id]
         LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"config"),"4sm")
         IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
            LET ls_tmp = ls_tmp,"\n",os.Path.join(ls_cmd,lc_gay01 CLIPPED)
         END IF
 
         #Check doc/sop/[lang_id]
         LET ls_cmd = os.Path.join(os.Path.join(ls_top.trim(),"doc"),"sop")
         IF NOT os.Path.exists(os.Path.join(ls_cmd,lc_gay01 CLIPPED)) THEN
            LET ls_tmp = ls_tmp,"\n",os.Path.join(ls_cmd,lc_gay01 CLIPPED)
         END IF
      END IF
   END FOR
   IF NOT cl_null(ls_tmp) THEN
      LET ls_tmp = cl_getmsg("azz-288",g_lang),"\n",ls_tmp.trim()
      CALL cl_err(ls_tmp,"!",1)
   ELSE
      CALL cl_err("Check Result: Structure Correct","!",1) 
   END IF
 
END FUNCTION
 
 
 
FUNCTION p_lang_x()    #FUN-830021
 
   DEFINE lc_gayacti    LIKE gay_file.gayacti
   DEFINE lc_chr        LIKE gay_file.gayacti
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gay[l_ac].gay01) THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   BEGIN WORK
   OPEN p_lang_bcl USING g_gay[l_ac].gay01
   IF SQLCA.sqlcode THEN
      CALL cl_err('OPEN p_lang_bcl',SQLCA.sqlcode,1)
      CLOSE p_lang_bcl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_lang_bcl INTO g_gay[l_ac].* 
   IF SQLCA.sqlcode THEN
      CALL cl_err('FETCH p_lang_bcl',SQLCA.sqlcode,1)
      CLOSE p_lang_bcl
      ROLLBACK WORK
      RETURN
   ELSE
      SELECT gayacti INTO lc_gayacti FROM gay_file WHERE gay01=g_gay[l_ac].gay01
   END IF
 
   IF cl_exp(0,0,lc_gayacti) THEN
       IF lc_gayacti="Y" THEN
           LET lc_gayacti="N"
       ELSE
           LET lc_gayacti="Y"
       END IF
       UPDATE gay_file SET gayacti = lc_gayacti,
                           gaymodu = g_user,
                           gaydate = g_today
           WHERE gay01=g_gay[l_ac].gay01
       IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_gay[l_ac].gay01,SQLCA.sqlcode,0)
           LET lc_gayacti = lc_chr
       END IF
       DISPLAY lc_gayacti TO gayacti
   END IF
   CLOSE p_lang_bcl
   COMMIT WORK
END FUNCTION
 
