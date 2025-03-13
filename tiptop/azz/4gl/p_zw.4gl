# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zw.4gl
# Descriptions...: 權限類別建立作業
# Date & Author..: 80/06/09 By LYS
# Modify.........: No.MOD-490233 04/09/13 By saki 改CONTROLF及CURSOR寫法
# Modify.........: No.FUN-4B0083 04/11/08 By alex 增加和 p_zy 的串接
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-510050 05/01/28 By pengu 報表轉XML
# Modify.........: No.MOD-530147 05/03/17 By alex 重過程式更新 146 行語法
# Modify.........: No.MOD-560214 05/06/30 By pengu 修改[有效]欄位值,重新查詢時,卻發現未儲存
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.FUN-580069 05/08/12 By alex 增加 p_zy2 和 p_zw 串接作業
# Modify.........: No.FUN-560182 05/08/22 By alex 新增權限群組成立時自動加入基本作業
# Modify.........: No.MOD-560212 05/10/17 By alex 修改有效欄位更新方式
# Modify.........: No.FUN-5C0057 05/12/13 By alex 刪除 zy06 權限的控管
# Modify.........: No.FUN-620010 06/02/09 By alex 增加基本賦予作業項目
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-680119 06/11/16 By pengu FUN-620010賦予的基本作業，允許執行的功能不能只default "exit"
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0042 07/12/14 By alex 修改報表列印方式
# Modify.........: No.FUN-880014 08/08/20 By sherry 增加接收p_zy中的參數
#                  08/08/27 MOD-880221 alexstar zw02:讓開窗選出的資料可正常寫入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30054 10/03/15 By alex 加上default webpasswd處理
# Modify.........: No.MOD-A90163 10/09/25 By lilingyu 錄入完“權限類型編號”後,鼠標依次往後點,點到"閒置處理"欄位時,程序當掉 
# Modify.........: No:FUN-9C0043 11/01/06 By tsai_yen 新增權限時,自動把"webpasswd"程式加入p_zy
# Modify.........: No:FUN-910101 11/01/06 By tsai_yen 新增權限時,自動把"cl_cmdask"與"p_query"加入p_zy
# Modify.........: No:MOD-B40031 11/04/06 By sabrina 新增放棄在新增時，無法輸入zw01
# Modify.........: No:FUN-B40008 11/04/07 By tsai_yen 當p_zy無資料時,p_zw可按Action新增基本程式權限到p_zy
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_zw           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        zw01       LIKE zw_file.zw01,         #權限類別
        zw02       LIKE zw_file.zw02,         #權限名稱
        zw03       LIKE zw_file.zw03,     
        zw04       LIKE zw_file.zw04,
        zw05       LIKE zw_file.zw05,
        zw06       LIKE zw_file.zw06,
        zwacti     LIKE zw_file.zwacti        #資料有效碼
                    END RECORD,
    g_zw_t         RECORD                     #程式變數 (舊值)
        zw01       LIKE zw_file.zw01,         #權限類別
        zw02       LIKE zw_file.zw02,         #權限名稱
        zw03       LIKE zw_file.zw03,     
        zw04       LIKE zw_file.zw04,
        zw05       LIKE zw_file.zw05,
        zw06       LIKE zw_file.zw06,
        zwacti     LIKE zw_file.zwacti        #資料有效碼
                    END RECORD,
       g_wc                STRING,
       g_sql               STRING,
       g_rec_b             LIKE type_file.num5,    #No.FUN-680135 SMALLINT
       l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE g_msg               STRING
DEFINE g_argv1             LIKE type_file.chr1     #No.FUN-880014
DEFINE g_edit              LIKE type_file.chr1     #MOD-A90163
DEFINE g_defzy             DYNAMIC ARRAY OF RECORD #FUN-B40008
        zy02       LIKE zy_file.zy02               #Programe Code
                    END RECORD

#主程式開始
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0096
   DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680135  SMALLINT 
 
   OPTIONS                                         #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
   LET p_row = 5 LET p_col = 25
   OPEN WINDOW p_zw_w AT p_row,p_col WITH FORM "azz/42f/p_zw"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   LET g_argv1 = ARG_VAL(1)           #No.FUN-880014

   ###FUN-B40008 START ###
   #p_zy預設基本程式
   LET g_defzy[1].zy02 = "aoos901"
   LET g_defzy[2].zy02 = "cl_cmdask"
   LET g_defzy[3].zy02 = "p_contview"
   LET g_defzy[4].zy02 = "p_cron"
   LET g_defzy[5].zy02 = "p_favorite"
   LET g_defzy[6].zy02 = "p_load_msg"
   LET g_defzy[7].zy02 = "p_query"
   LET g_defzy[8].zy02 = "p_view"
   LET g_defzy[9].zy02 = "udm_tree"
   LET g_defzy[10].zy02 = "webpasswd"
   ###FUN-B40008 END ###
    
   CALL cl_ui_init()
       
   CALL p_zw_menu()
 
   CLOSE WINDOW p_zw_w                 #結束畫面
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
END MAIN
 
FUNCTION p_zw_menu()
 
   WHILE TRUE
      CALL p_zw_bp("G")
      CASE g_action_choice
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_zw_curs()
            END IF
 
         WHEN "modify_p_zy"
            IF cl_chk_act_auth() THEN
               IF l_ac != 0 AND l_ac IS NOT NULL THEN
                  LET g_msg='p_zy "',g_zw[l_ac].zw01 CLIPPED,'" '
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF
 
         WHEN "modify_p_zy2"     #FUN-580069
            IF cl_chk_act_auth() THEN
               IF l_ac != 0 AND l_ac IS NOT NULL THEN
                  LET g_msg='p_zy2 "',g_zw[l_ac].zw01 CLIPPED,'" '
                  CALL cl_cmdrun_wait(g_msg)
               ELSE
                  CALL cl_err('',-400,0)
               END IF
            END IF

         WHEN "add_p_zy"     #FUN-B40008
            IF cl_chk_act_auth() THEN
               CALL p_zw_add_zy(g_zw[l_ac].zw01)
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zw_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output" 
            IF cl_chk_act_auth() THEN
#              CALL p_zw_out()    #FUN-7C0042
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg='p_query "p_zw" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zw_curs()
 
   CALL cl_opmsg('q')
   CLEAR FORM                             #清除畫面
   CALL g_zw.clear()
 
   CONSTRUCT g_wc ON zw01,zw02,zw03,zw04,zw05,zw06,zwacti    #螢幕上取條件
        FROM s_zw[1].zw01,s_zw[1].zw02,s_zw[1].zw03,
             s_zw[1].zw04,s_zw[1].zw05,s_zw[1].zw06,s_zw[1].zwacti
 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(zw03)
                CALL cl_init_qry_var()       
                LET g_qryparam.form = "q_gaz2"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1= g_zw[1].zw03
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO zw03
                NEXT FIELD zw03
             OTHERWISE
                EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zwuser', 'zwgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   LET g_sql= "SELECT zw01,zw02,zw03,zw04,zw05,zw06,zwacti FROM zw_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zw01"
   PREPARE p_zw_prepare FROM g_sql      #預備一下
   DECLARE p_zw_curs CURSOR FOR p_zw_prepare
 
   CALL p_zw_b_fill()                 #單身
 
END FUNCTION
 
FUNCTION p_zw_b()
 
    DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
           l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680135 SMALLINT
           l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680135 VARCHAR(1)
           p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680135 VARCHAR(1)
           l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680135 SMALLINT
           l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680135 SMALLINT
    DEFINE li_chkzx        LIKE type_file.num10   #MOD-560212        #No.FUN-680135 INTEGER
    DEFINE li_chkzxw       LIKE type_file.num10   #MOD-560212        #No.FUN-680135 INTEGER
    DEFINE ls_progname     STRING                 #MOD-560212
    DEFINE li_zw01upd      LIKE type_file.num5    #FUN-560182        #No.FUN-680135 SMALLINT
    DEFINE l_zz04         LIKE zz_file.zz04      #FUN-680119 add
    DEFINE l_i             LIKE type_file.num5    #FUN-B40008
 
    LET g_action_choice = ""
 
    LET g_forupd_sql = " SELECT zw01,zw02,zw03,zw04,zw05,zw06,zwacti ",
                         " FROM zw_file",
                        " WHERE zw01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_zw_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_zw WITHOUT DEFAULTS FROM s_zw.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = '' 
           LET g_edit = ''                #MOD-A90163 
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET li_zw01upd = FALSE         #FUN-560182
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_zw_t.* = g_zw[l_ac].*  #BACKUP
              OPEN p_zw_bcl USING g_zw_t.zw01
              IF STATUS THEN
                 CALL cl_err("OPEN p_zw_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE  
                 FETCH p_zw_bcl INTO g_zw[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_zw_t.zw01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              LET g_before_input_done = FALSE
 #NO.MOD-580056 MARK
              #CALL p_zw_set_entry()
              #CALL p_zw_set_no_entry()
              #---
              CALL p_zw_set_entry(p_cmd)
              CALL p_zw_set_no_entry(p_cmd)
              LET g_before_input_done = TRUE
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO zw_file(zw01,zw02,zw03,zw04,zw05,zw06,zwacti,zworiu,zworig)
                VALUES(g_zw[l_ac].zw01,g_zw[l_ac].zw02,g_zw[l_ac].zw03,
                        g_zw[l_ac].zw04,g_zw[l_ac].zw05,g_zw[l_ac].zw06,g_zw[l_ac].zwacti, g_user, g_grup)      ##No.MOD-560214      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              #CALL cl_err(g_zw[l_ac].zw01,SQLCA.sqlcode,0)  #No.FUN-660081
              CALL cl_err3("ins","zw_file",g_zw[l_ac].zw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              #FUN-560182
              #FUN-560182 #FUN-5C0057 取消 zy06  #FUN-620010新增
             #---FUN-680119 add
             IF cl_null(g_argv1) THEN   #No.FUN-880014
                ###FUN-B40008 START ###
                #p_zy預設基本程式
                FOR l_i = 1 TO g_defzy.getlength()
                   LET l_zz04 = NULL
                   SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = g_defzy[l_i].zy02
                   INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate)
                           VALUES(g_zw[l_ac].zw01,g_defzy[l_i].zy02,l_zz04,"0","0","0",
                                  g_user,g_grup,g_today)
                END FOR
                ###FUN-B40008 END ###
                ###FUN-B40008 mark START ###
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'aoos901'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"aoos901",l_zz04,"0","0","0",         #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'udm_tree'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"udm_tree",l_zz04,"0","0","0",        #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-FUN-A30054 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'webpasswd'
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"webpasswd",l_zz04,"0","0","0",      
                  #                     g_user,g_grup,g_today, g_user, g_grup)    
                  ##---FUN-FUN-A30054 end
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_favorite'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"p_favorite",l_zz04,"0","0","0",      #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_load_msg'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"p_load_msg",l_zz04,"0","0","0",      #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_cron'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"p_cron",l_zz04,"0","0","0",          #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)   #FUN-620010      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_view'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"p_view",l_zz04,"0","0","0",         #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)   #FUN-620010      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  ##---FUN-680119 add
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_contview'
                  ##---FUN-680119 end
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate,zyoriu,zyorig)
                  #              VALUES(g_zw[l_ac].zw01,"p_contview",l_zz04,"0","0","0",     #FUN-680119 add
                  #                     g_user,g_grup,g_today, g_user, g_grup)   #FUN-620010      #No.FUN-980030 10/01/04  insert columns oriu, orig
              
                  # ###FUN-9C0043 START ###
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'webpasswd'
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate)
                  #              VALUES(g_zw[l_ac].zw01,"webpasswd",l_zz04,"0","0","0",
                  #                     g_user,g_grup,g_today)
                  # ###FUN-9C0043 END ###
                  # ###FUN-910101 START ###
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'cl_cmdask'
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate)
                  #              VALUES(g_zw[l_ac].zw01,"cl_cmdask",l_zz04,"0","0","0",
                  #                     g_user,g_grup,g_today)
                  # 
                  # LET l_zz04 = NULL
                  # SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = 'p_query'
                  # INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate)
                  #              VALUES(g_zw[l_ac].zw01,"p_query",l_zz04,"0","0","0",
                  #                     g_user,g_grup,g_today)
                  # ###FUN-910101 END ###
              ###FUN-B40008 mark END ###
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
             END IF   #No.FUN-880014
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_zw[l_ac].* TO NULL      #900423
           LET g_zw[l_ac].zw04 = '1'
           LET g_zw[l_ac].zwacti='Y'
           LET g_zw_t.* = g_zw[l_ac].*         #新輸入資料
           LET g_before_input_done = FALSE
            #NO.MOD-580056 MARK
           #CALL p_zw_set_entry()
           #CALL p_zw_set_no_entry()
           #--
           CALL p_zw_set_entry(p_cmd)
           CALL p_zw_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER FIELD zw01                        #check 序號是否重複
           IF g_zw[l_ac].zw01 != g_zw_t.zw01 OR g_zw_t.zw01 IS NULL THEN
              SELECT count(*)
                INTO l_n
                FROM zw_file
               WHERE zw01 = g_zw[l_ac].zw01
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_zw[l_ac].zw01 = g_zw_t.zw01
                 NEXT FIELD zw01
              END IF
           END IF
#          #FUN-560182
           IF g_zw[l_ac].zw01 != g_zw_t.zw01 AND NOT cl_null(g_zw_t.zw01) THEN
              LET li_chkzx = 0
              SELECT count(*) INTO li_chkzx FROM zx_file
               WHERE zx04 = g_zw_t.zw01
              IF li_chkzx > 0 THEN
                 CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
                 LET ls_progname = ls_progname.trim(),"|p_zx|",g_zw_t.zw01
                 CALL cl_err_msg(NULL,"azz-220",ls_progname.trim(), 10)
                 LET g_zw[l_ac].zw01 = g_zw_t.zw01
              ELSE
                 LET li_chkzxw = 0
                 SELECT count(*) INTO li_chkzxw FROM zxw_file
                  WHERE zxw03 = "1" AND zxw04 = g_zw_t.zw01
                 IF li_chkzxw > 0 THEN
                    CALL cl_get_progname("p_zxw",g_lang) RETURNING ls_progname
                    LET ls_progname = ls_progname.trim(),"|p_zxw|",g_zw_t.zw01
                    CALL cl_err_msg(NULL,"azz-220",ls_progname.trim(), 10)
                    LET g_zw[l_ac].zw01 = g_zw_t.zw01
                    DISPLAY g_zw[l_ac].zw01 TO zw01
                 ELSE
                    LET li_zw01upd = TRUE
                 END IF
              END IF
           END IF
 
        AFTER FIELD zw03
          IF NOT cl_null(g_zw[l_ac].zw03) THEN
             SELECT zz01 FROM zz_file WHERE zz01=g_zw[l_ac].zw03 AND zz011="MENU"
             IF STATUS THEN
                #CALL cl_err("select "||g_zw[l_ac].zw03||" ",STATUS,0)  #No.FUN-660081
                CALL cl_err3("sel","zz_file",g_zw[l_ac].zw01,"MENU",STATUS,"","select "||g_zw[l_ac].zw03,0)    #No.FUN-660081
                NEXT FIELD zw03
             END IF
          END IF
 
        BEFORE FIELD zw04
            #CALL p_zw_set_entry(p_cmd)  #NO.MOD-580056 MARK
           CALL p_zw_set_entry(p_cmd)
 
        AFTER FIELD zw04
            #CALL p_zw_set_no_entry()  #NO.MOD-580056 MARK
           CALL p_zw_set_no_entry(p_cmd)
           IF g_zw[l_ac].zw04 != "2" THEN
              LET g_zw[l_ac].zw05 = ""
              LET g_zw[l_ac].zw06 = ""
           END IF
#MOD-A90163 --begin--
           IF g_zw[l_ac].zw04 != "2" AND g_edit = 'Y' THEN
              NEXT FIELD zwacti
           END IF 
#MOD-A90163 --end--
 
        AFTER FIELD zwacti   #MOD-560212
           IF g_zw_t.zwacti = "Y" AND g_zw[l_ac].zwacti = "N" THEN
              LET li_chkzx = 0
              SELECT count(*) INTO li_chkzx FROM zx_file
               WHERE zx04 = g_zw[l_ac].zw01
              IF li_chkzx > 0 THEN
                 CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
                 LET ls_progname = ls_progname.trim(),"|p_zx|",g_zw[l_ac].zw01
                 CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(), 10)
                 LET g_zw[l_ac].zwacti = "Y"
                 DISPLAY g_zw[l_ac].zwacti TO zwacti
              ELSE
                 LET li_chkzxw = 0
                 SELECT count(*) INTO li_chkzxw FROM zxw_file
                  WHERE zxw03 = "1" AND zxw04 = g_zw[l_ac].zw01
                 IF li_chkzxw > 0 THEN
                    CALL cl_get_progname("p_zxw",g_lang) RETURNING ls_progname
                    LET ls_progname = ls_progname.trim(),"|p_zxw|",g_zw[l_ac].zw01
                    CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(), 10)
                    LET g_zw[l_ac].zwacti = "Y"
                    DISPLAY g_zw[l_ac].zwacti TO zwacti
                 END IF
                 # Never Check p_perright, Because data must be come from p_zx
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_zw_t.zw01 IS NOT NULL THEN
              LET l_ac_t = l_ac
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
               ELSE                               #MOD-560212
                 LET li_chkzx = 0
                 SELECT count(*) INTO li_chkzx FROM zx_file
                  WHERE zx04 = g_zw[l_ac].zw01
                 IF li_chkzx > 0 THEN
                    CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
                    LET ls_progname = ls_progname.trim(),"|p_zx|",g_zw[l_ac].zw01
                    CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(),10)
                    CANCEL DELETE
                 ELSE
                    LET li_chkzxw = 0
                    SELECT count(*) INTO li_chkzxw FROM zxw_file
                     WHERE zxw03 = "1" AND zxw04 = g_zw[l_ac].zw01
                    IF li_chkzxw > 0 THEN
                       CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
                       LET ls_progname = ls_progname.trim(),"|p_zx|",g_zw[l_ac].zw01
                       CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(),10)
                       CANCEL DELETE
                    END IF
                 END IF
              END IF
              SELECT COUNT(*) INTO g_cnt FROM zy_file 
               WHERE zy01 = g_zw_t.zw01
              IF g_cnt > 0 THEN
                 CALL cl_err(g_zw_t.zw01,'azz-005',1)
                 EXIT INPUT
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM zw_file
               WHERE zw01 = g_zw_t.zw01
              IF SQLCA.SQLERRD[3]=0 THEN
                 #CALL cl_err(g_zw_t.zw01,SQLCA.sqlcode,0)  #No.FUN-660081
                 CALL cl_err3("del","zw_file",g_zw_t.zw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 ROLLBACK WORK 
                 CANCEL DELETE 
              END IF
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_zw[l_ac].* = g_zw_t.*
              CLOSE p_zw_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_zw[l_ac].zw01,-263,1)
              LET g_zw[l_ac].* = g_zw_t.*
           ELSE
              UPDATE zw_file SET zw01=g_zw[l_ac].zw01,
                                 zw02=g_zw[l_ac].zw02,
                                 zw03=g_zw[l_ac].zw03,
                                 zw04=g_zw[l_ac].zw04,
                                 zw05=g_zw[l_ac].zw05,
                                 zw06=g_zw[l_ac].zw06,
                                  zwacti=g_zw[l_ac].zwacti    #No.MOD-560214 add
               WHERE zw01=g_zw_t.zw01
              IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_zw[l_ac].zw01,SQLCA.sqlcode,0)  #No.FUN-660081
                 CALL cl_err3("upd","zw_file",g_zw_t.zw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 LET g_zw[l_ac].* = g_zw_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 IF li_zw01upd THEN      #FUN-560182
                    CALL cl_err_msg(NULL,"azz-221",g_zw_t.zw01||"|"||g_zw[l_ac].zw01,10)
                 END IF
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac        #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_zw[l_ac].* = g_zw_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_zw.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE p_zw_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET g_zw_t.* = g_zw[l_ac].*
          #MOD-B40031---add---start---
           IF cl_null(g_zw[l_ac].zw01) THEN
              CALL g_zw.deleteElement(l_ac)
           END IF
          #MOD-B40031---add---end---
           LET l_ac_t = l_ac        #FUN-D30034 add
           CLOSE p_zw_bcl
           COMMIT WORK
 
        ON ACTION modify_p_zy
           LET g_action_choice="modify_p_zy"
           IF cl_chk_act_auth() THEN
              LET g_msg="p_zy '",g_zw[l_ac].zw01 CLIPPED,"' "
              CALL cl_cmdrun_wait(g_msg)
           END IF
 
        ON ACTION modify_p_zy2                    #FUN-580069
           LET g_action_choice="modify_p_zy2"
           IF cl_chk_act_auth() THEN
              LET g_msg="p_zy2 '",g_zw[l_ac].zw01 CLIPPED,"' "
              CALL cl_cmdrun_wait(g_msg)
           END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(zw03)
                  CALL cl_init_qry_var()       
                  LET g_qryparam.form = "q_gaz2"
                  LET g_qryparam.default1= g_zw[l_ac].zw03
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  LET g_qryparam.arg2 = g_user CLIPPED
                  LET g_qryparam.where = " zz03 = 'M'"
                  CALL cl_create_qry() RETURNING g_zw[l_ac].zw03
                  DISPLAY g_zw[l_ac].zw03 TO s_zw[1].zw03  #MOD-880221 
                  NEXT FIELD zw03
               OTHERWISE
                  EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(zw01) AND l_ac > 1 THEN
              LET g_zw[l_ac].* = g_zw[l_ac-1].*
              NEXT FIELD zw01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION update_all_user_menu
           CALL p_zw_t()
 
#       ON ACTION CONTROLU
#          CALL p_zw_out()
 
 
#       ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
    CLOSE p_zw_bcl
    COMMIT WORK
 
END FUNCTION
 
 #FUNCTION p_zw_set_entry()  #NO.MOD-580056
FUNCTION p_zw_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    #NO.MOD-580056
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zw01",TRUE)
   END IF
   #--END
 
   IF INFIELD(zw04) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("zw05,zw06",TRUE)
   END IF
END FUNCTION
 
 #FUNCTION p_zw_set_no_entry()  #NO.MOD-580056 MARK
FUNCTION p_zw_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
    #NO.MOD-580056
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zw01",FALSE)
   END IF
   #--end
 
   IF INFIELD(zw04) OR (NOT g_before_input_done) THEN
      IF g_zw[l_ac].zw04 != "2" THEN
         CALL cl_set_comp_entry("zw05,zw06",FALSE)
         LET g_edit = 'Y'                 #MOD-A90163
      END IF
   END IF
END FUNCTION
   
FUNCTION p_zw_b_fill()              #BODY FILL UP
       
    CALL g_zw.clear()
    LET g_cnt = 1
 
    FOREACH p_zw_curs INTO g_zw[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_zw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
 
END FUNCTION
 
FUNCTION p_zw_t()
   DEFINE l_zw	RECORD LIKE zw_file.*
 
   IF NOT cl_confirm('azz-001') THEN RETURN END IF
 
   DECLARE p_zw_t_c CURSOR FOR
           SELECT * FROM zw_file WHERE zw03 IS NOT NULL AND zw03<>' '
 
   FOREACH p_zw_t_c INTO l_zw.*
      MESSAGE 'upd:',l_zw.zw01
      UPDATE zx_file SET zx05=l_zw.zw03 WHERE zx04=l_zw.zw01
   END FOREACH
 
   MESSAGE ''
 
END FUNCTION
 
FUNCTION p_zw_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No.FUN-880014---Begin
   IF g_argv1 = 'Y' THEN 
      CALL cl_set_act_visible("modify_p_zy,modify_p_zy2,add_p_zy", FALSE)   #FUN-B40008 add "add_p_zy"
   END IF
   #No.FUN-880014---End
   DISPLAY ARRAY g_zw TO s_zw.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION modify_p_zy       # 串接 p_zy
         LET g_action_choice="modify_p_zy"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION modify_p_zy2      # 串接 p_zy2   FUN-580069
         LET g_action_choice="modify_p_zy2"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION add_p_zy          #FUN-B40008
         LET g_action_choice="add_p_zy"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zw_out()
DEFINE l_i         LIKE type_file.num5,    #No.FUN-680135 SMALLINT
       sr          RECORD
        zw01       LIKE zw_file.zw01,      #目錄序號
        zw02       LIKE zw_file.zw02,      #程式代號
        zw03       LIKE zw_file.zw03,      #程式代號
        zw04       LIKE zw_file.zw04,
        zw05       LIKE zw_file.zw05,
        zw06       LIKE zw_file.zw06
                   END RECORD,
    l_name         LIKE type_file.chr20,   #External(Disk) file name #No.FUN-680135 VARCHAR(20)
    l_za05         LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    CALL cl_wait()
 
    CALL cl_outnam('p_zw') RETURNING l_name
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT zw01,zw02,zw03,zw04,zw05,zw06 ",
              " FROM zw_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE p_zw_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zw_curo                         # SCROLL CURSOR
      CURSOR  FOR p_zw_p1
 
    START REPORT p_zw_rep TO l_name
 
    FOREACH p_zw_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p_zw_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_zw_rep
 
    CLOSE p_zw_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zw_rep(sr)
DEFINE
    l_trailer_sw   LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    sr             RECORD
        zw01       LIKE zw_file.zw01,      #目錄序號
        zw02       LIKE zw_file.zw02,      #程式代號
        zw03       LIKE zw_file.zw03,      #程式代號
        zw04       LIKE zw_file.zw04,
        zw05       LIKE zw_file.zw05,
        zw06       LIKE zw_file.zw06
                   END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.zw01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.zw01,
                  COLUMN g_c[32],sr.zw02,
                  COLUMN g_c[33],sr.zw03
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
###FUN-B40008 START ###
#p_zy新增基本程式權限
FUNCTION p_zw_add_zy(p_zw01)
   DEFINE p_zw01         LIKE zw_file.zw01
   DEFINE l_zz04         LIKE zz_file.zz04
   DEFINE l_i            LIKE type_file.num5
   DEFINE l_add          STRING
   DEFINE l_cnt          LIKE type_file.num10

   IF NOT cl_null(p_zw01) THEN
      SELECT COUNT(zy01) INTO l_cnt FROM zy_file WHERE zy01 = p_zw01
      IF l_cnt = 0 THEN
         FOR l_i = 1 TO g_defzy.getlength()
            LET l_zz04 = NULL
            SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = g_defzy[l_i].zy02
            INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyuser,zygrup,zydate)
                    VALUES(p_zw01,g_defzy[l_i].zy02,l_zz04,"0","0","0",
                           g_user,g_grup,g_today)
         END FOR

         IF SQLCA.sqlcode THEN
            CALL cl_err('INSERT:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('','azz-312',1)   #新增成功
         END IF
      END IF
   ELSE
      CALL cl_err('',-400,0)
   END IF
END FUNCTION
###FUN-B40008 END ###
