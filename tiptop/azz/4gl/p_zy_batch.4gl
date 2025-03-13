# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: p_zy_batch.4gl
# Descriptions...: 整批新增或刪除特定群組內特定功能批次作業
# Date & Author..: 05/10/20 alex
# Modify.........: No.MOD-5A0329 05/10/21 By alex 修改規格
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60058 11/01/18 By tommas 開窗查詢改為多選方式，以處理多個權限類別。
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zy01          LIKE zy_file.zy01        # 類別代號 (假單頭)
DEFINE   g_zw02          LIKE zw_file.zw02 
DEFINE   g_finish        LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
DEFINE   g_gbd           DYNAMIC ARRAY OF RECORD
           gbd01         LIKE gbd_file.gbd01,
           gbd04         LIKE gbd_file.gbd04,
           choice        LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
                     END RECORD
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(72)
DEFINE   g_rec_b         LIKE type_file.num5      #No.FUN-680135 SMALLINT
DEFINE   l_ac            LIKE type_file.num5      #No.FUN-680135 SMALLINT
DEFINE   g_sql           STRING
DEFINE   g_cn2           LIKE type_file.num5      #No.FUN-680135 SMALLINT
DEFINE   g_iadd,g_imov   LIKE type_file.num10     #No.FUN-680135 INTEGER
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8           #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)      # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_zz_w WITH FORM "azz/42f/p_zy_batch"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p_zy_batch_init()
   CALL p_zy_batch_prepare()
   CALL p_zy_batch_menu()
 
   CLOSE WINDOW p_zy_batch_w          # 結束畫面
   CALL  cl_used(g_prog,g_time,2)      # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zy_batch_init()
 
   INITIALIZE g_zy01   TO NULL 
   INITIALIZE g_zw02   TO NULL 
   LET g_finish="N"
   LET g_cn2=0
   LET g_iadd=0
   LET g_imov=0
   CALL g_gbd.clear()
   DISPLAY g_zy01,g_zw02,g_finish,g_cn2
        TO zy01,zw02,finish,cn2
 
END FUNCTION
 
FUNCTION p_zy_batch_menu()
 
   MENU ''
      ON ACTION locale
         CALL cl_dynamic_locale() 
 
      ON ACTION a_r_action
         CALL p_zy_batch_init()
         CALL p_zy_batch_prepare()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION exit                           #"Esc.結束"
         EXIT MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE                 #MOD-570244     mars
         EXIT MENU
   END MENU
 
END FUNCTION
 
FUNCTION p_zy_batch_prepare()
   DEFINE li_exit  LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_cnt   LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_pos   LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_check LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_zy01    STRING                 #No.FUN-A60058 STRING
   DEFINE l_st      base.StringTokenizer   #No.FUN-A60058
   DEFINE l_gup_cnt LIKE type_file.num5    #No.FUN-A60058 群組數目
   DEFINE l_gup_str STRING                 #No.FUN-A60058
 
   INITIALIZE g_zy01 TO NULL
   INITIALIZE g_zw02 TO NULL
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT l_zy01 WITHOUT DEFAULTS FROM zy01
 
      AFTER FIELD zy01
          IF cl_null(l_zy01) THEN
             CALL cl_err_msg(NULL, "azz-223", l_zy01 CLIPPED, 20)
             NEXT FIELD zy01
          END IF

#  mark by tommas No.FUN-A60058 start
#         IF NOT cl_null(g_zy01) THEN
#            SELECT count(*) INTO li_cnt FROM zw_file WHERE zw01=g_zy01
#            IF li_cnt <> 1 OR STATUS THEN
#               CALL cl_err_msg(NULL,"azz-223",g_zy01 CLIPPED,20)
#               NEXT FIELD zy01
#            ELSE
#               SELECT zw02,zwacti INTO g_zw02,g_zwacti FROM zw_file
#                WHERE zw01=g_zy01
#               IF g_zwacti = "N" THEN
#                  CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,20)
#                  NEXT FIELD zy01
#               END IF
#               DISPLAY g_zw02,g_zwacti TO zw02,zwacti
#            END IF
#         END IF
#  mark by tommas No.FUN-A60058 end         

      ON ACTION controlp
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_zw"
         LET g_qryparam.default1 = g_zy01
         LET g_qryparam.state = "c"         #No.FUN-A60058 add by tommas
         CALL cl_create_qry() RETURNING l_zy01
         DISPLAY l_zy01 TO zy01
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_rec_b = 0
   CALL g_gbd.clear()
   INPUT ARRAY g_gbd WITHOUT DEFAULTS FROM s_gbd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=TRUE, DELETE ROW=TRUE,
                        APPEND ROW=TRUE)
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       BEFORE INSERT
          INITIALIZE g_gbd[l_ac].* TO NULL
          LET g_gbd[l_ac].choice="Y"
 
       AFTER INSERT
          LET g_cn2=g_gbd.getLength()
          DISPLAY g_cn2 TO cn2
 
       AFTER FIELD gbd01
          IF NOT cl_null(g_gbd[l_ac].gbd01) THEN
             SELECT gbd04 INTO g_gbd[l_ac].gbd04 FROM gbd_file
              WHERE gbd01=g_gbd[l_ac].gbd01
                AND gbd02='standard'
                AND gbd03=g_lang
             IF SQLCA.SQLCODE THEN
                #CALL cl_err('SEL p_zw:'||g_gbd[l_ac].gbd01 CLIPPED||' ',SQLCA.SQLCODE,1)   #No.FUN-660081
                CALL cl_err3("sel","gbd_file",g_gbd[l_ac].gbd01,g_lang,SQLCA.sqlcode,"","SEL p_zw:"||g_gbd[l_ac].gbd01 CLIPPED,1)    #No.FUN-660081
                NEXT FIELD gbd01
             END IF
             LET li_check=FALSE
             FOR li_pos=1 TO g_gbd.getLength()
                IF li_pos <> l_ac THEN
                   IF DOWNSHIFT(g_gbd[li_pos].gbd01 CLIPPED)=DOWNSHIFT(g_gbd[l_ac].gbd01 CLIPPED) THEN
                      LET li_check=TRUE
                   END IF
                END IF 
             END FOR
             IF li_check THEN
                CALL cl_err_msg(NULL,"azz-228",g_gbd[l_ac].gbd01,30)
                NEXT FIELD gbd01
             END IF
          END IF
 
       ON ACTION controlp
          CASE WHEN INFIELD(gbd01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_gbd"
             LET g_qryparam.default1 = g_gbd[l_ac].gbd01
             LET g_qryparam.arg1 = g_lang CLIPPED
             CALL cl_create_qry() RETURNING g_gbd[l_ac].gbd01
             DISPLAY g_gbd[l_ac].gbd01 TO gbd01
          END CASE
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL cl_err('',9001,0)
   ELSE
      IF cl_confirm("azz-226") THEN

         ############     No.FUN-A60058  start
         LET l_st = base.StringTokenizer.create(l_zy01, "|")
         LET l_gup_cnt = 0                            
         LET g_finish = "Y"   #預設flag是Y
         BEGIN WORK
         WHILE l_st.hasMoreTokens()
            LET g_zy01 = l_st.nextToken()
            IF NOT p_zy_batch_do() THEN
               CALL cl_err_msg(NULL,'azz-225',g_zy01, 40)
               LET g_finish = "N"
               EXIT WHILE      
            ELSE
               LET l_gup_cnt = l_gup_cnt + 1
            END IF
         END WHILE
       
         IF g_finish != "N" THEN
            COMMIT WORK
            LET l_gup_str = l_gup_cnt
            DISPLAY g_finish TO finish
            LET g_sql= l_gup_str.trim() ,"|",g_iadd CLIPPED,"|",g_imov CLIPPED,"|",g_iadd+g_imov
            CALL cl_err_msg(NULL,"azz-289",g_sql.trim(),40)
         ELSE
            ROLLBACK WORK
         END IF
         ############     No.FUN-A60058  end

      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION p_zy_batch_do()
 
   DEFINE li_i        LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_done     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE lc_zy02     LIKE zy_file.zy02
   DEFINE lc_zy03     LIKE zy_file.zy03
   DEFINE ls_zy03     STRING
   DEFINE li_pos      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE li_success  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   LET g_sql=" SELECT zy02,zy03 FROM zy_file ",
             " WHERE zy01='",g_zy01 CLIPPED,"' ",
             " AND zy02 NOT IN('aoos901','udm_tree','webpasswd','p_favorite','p_load_msg','p_cron','p_view','p_contview','webpasswd','cl_cmdask','p_query') " #No.FUN-A60058 這些程式不受控管
   PREPARE p_zy_batch_pre FROM g_sql
   DECLARE p_zy_batch_cs CURSOR FOR p_zy_batch_pre
   LET li_success = TRUE
 
   FOR li_i=1 TO g_gbd.getLength()
      IF cl_null(g_gbd[li_i].gbd01) THEN
         CONTINUE FOR
      END IF
      CASE
         WHEN g_gbd[li_i].choice="Y"
            FOREACH p_zy_batch_cs INTO lc_zy02,lc_zy03
               LET ls_zy03 = lc_zy03 CLIPPED
               IF p_zy_batch_check(ls_zy03.trim(),g_gbd[li_i].gbd01 CLIPPED) THEN
                  CONTINUE FOREACH
               END IF
               SELECT count(*) INTO li_pos FROM gap_file
                WHERE gap01=lc_zy02 AND gap02=g_gbd[li_i].gbd01
               IF li_pos = 1 THEN
                  CALL p_zy_batch_add(lc_zy03,g_gbd[li_i].gbd01)
                       RETURNING lc_zy03
                  UPDATE zy_file SET zy03=lc_zy03
                   WHERE zy01=g_zy01 AND zy02=lc_zy02 
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                     LET li_success = FALSE
                  ELSE
                     LET g_iadd=g_iadd+1
                  END IF
               ELSE
                  CONTINUE FOREACH
               END IF
            END FOREACH
 
         WHEN g_gbd[li_i].choice="N"
            FOREACH p_zy_batch_cs INTO lc_zy02,lc_zy03
               LET ls_zy03 = lc_zy03 CLIPPED
               IF p_zy_batch_check(ls_zy03.trim(),g_gbd[li_i].gbd01 CLIPPED) THEN
                  CALL p_zy_batch_remove(lc_zy03,g_gbd[li_i].gbd01)
                       RETURNING lc_zy03
                  UPDATE zy_file SET zy03=lc_zy03
                   WHERE zy01=g_zy01 AND zy02=lc_zy02 
                  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                     LET li_success = FALSE
                  ELSE
                     LET g_imov=g_imov+1
                  END IF
               END IF
            END FOREACH
      END CASE
   END FOR
 
   IF li_success THEN
      RETURN TRUE
   ELSE
      CALL cl_err("","azz-224",1)
      RETURN FALSE
   END IF
 
END FUNCTION
   
FUNCTION p_zy_batch_add(lc_zy03,lc_gbd01)
   DEFINE lc_zy03       LIKE zy_file.zy03
   DEFINE lc_gbd01      LIKE gbd_file.gbd01
   DEFINE ls_zy03       STRING
 
   LET ls_zy03 = lc_zy03 CLIPPED
   IF cl_null(lc_zy03) THEN
      LET lc_zy03 = lc_gbd01 CLIPPED
   ELSE
      LET lc_zy03 = lc_zy03 CLIPPED,", ",lc_gbd01 CLIPPED
   END IF
   RETURN lc_zy03
END FUNCTION
 
 
FUNCTION p_zy_batch_remove(lc_zy03,lc_gbd01)
   DEFINE lc_zy03        LIKE zy_file.zy03
   DEFINE lc_zy03_new    LIKE zy_file.zy03
   DEFINE lc_gbd01       LIKE gbd_file.gbd01
   DEFINE lst_act_list   base.StringTokenizer,
          ls_act         STRING
   DEFINE li_pos         LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   LET lst_act_list = base.StringTokenizer.create(lc_zy03 CLIPPED, ",")
 
   INITIALIZE lc_zy03_new TO NULL
   LET li_pos=1
   LET lc_gbd01 = DOWNSHIFT(lc_gbd01) CLIPPED
   WHILE lst_act_list.hasMoreTokens()
      LET ls_act = lst_act_list.nextToken()
      LET ls_act = ls_act.trim()
      IF (ls_act.equalsIgnoreCase(lc_gbd01 CLIPPED)) OR cl_null(ls_act) THEN
         CONTINUE WHILE
      ELSE
         IF li_pos = 1 THEN
            LET lc_zy03_new = ls_act.trim()
         ELSE
            LET lc_zy03_new = lc_zy03_new CLIPPED,", ",ls_act.trim()
         END IF
         LET li_pos = li_pos + 1
      END IF
   END WHILE
   RETURN lc_zy03_new
 
END FUNCTION
 
 
FUNCTION p_zy_batch_check(lc_zy03,lc_gbd01)
 
   DEFINE lst_act_list   base.StringTokenizer,
          ls_act         STRING
   DEFINE lc_zy03        LIKE zy_file.zy03
   DEFINE lc_gbd01       LIKE gbd_file.gbd01
   DEFINE li_act_allow   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   IF cl_null(lc_zy03) OR cl_null(lc_gbd01) THEN
      RETURN FALSE
   ELSE 
      LET lc_gbd01 = DOWNSHIFT(lc_gbd01) CLIPPED
   END IF
 
   LET lst_act_list = base.StringTokenizer.create(lc_zy03 CLIPPED, ",")
 
   LET li_act_allow = FALSE
   WHILE lst_act_list.hasMoreTokens()
      LET ls_act = lst_act_list.nextToken()
      LET ls_act = ls_act.trim()
      IF (ls_act.equalsIgnoreCase(lc_gbd01 CLIPPED)) THEN
         LET li_act_allow = TRUE
         EXIT WHILE
      END IF
      CONTINUE WHILE
   END WHILE
   RETURN li_act_allow 
 
END FUNCTION
