# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asft200.4gl
# Descriptions...: 工單分派優先順序維護作業
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-550067 05/06/01 By Will 單據編號放大
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-940172 09/05/11 By mike 將單身的錄入和刪除按鈕變灰     
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_sfb          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sfb40       LIKE sfb_file.sfb40,
        sfb01       LIKE sfb_file.sfb01,
        sfb02       LIKE sfb_file.sfb02,
        disc1       LIKE sfb_file.sfb03,        #No.FUN-680121 VARCHAR(22)
        sfb04       LIKE sfb_file.sfb04,
        disc2       LIKE type_file.chr20,        #No.FUN-680121 VARCHAR(12)
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        sfb13       LIKE sfb_file.sfb13,
        sfb15       LIKE sfb_file.sfb15,
        sfb08       LIKE sfb_file.sfb08,
        ima55       LIKE ima_file.ima55,
        sfb09       LIKE sfb_file.sfb09
                    END RECORD,
    g_sfb_t         RECORD                 #程式變數 (舊值)
        sfb40       LIKE sfb_file.sfb40,
        sfb01       LIKE sfb_file.sfb01,
        sfb02       LIKE sfb_file.sfb02,
        disc1       LIKE sfb_file.sfb03,          #No.FUN-680121 VARCHAR(22)
        sfb04       LIKE sfb_file.sfb04,
        disc2       LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(12)
        sfb05       LIKE sfb_file.sfb05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        sfb13       LIKE sfb_file.sfb13,
        sfb15       LIKE sfb_file.sfb15,
        sfb08       LIKE sfb_file.sfb08,
        ima55       LIKE ima_file.ima55,
        sfb09       LIKE sfb_file.sfb09
                    END RECORD,
     g_sql           string,  #No.FUN-580092 HCN
     g_wc2           string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)  RETURNING g_time   #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
    OPEN WINDOW t200_w WITH FORM "asf/42f/asft200"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL t200_b_fill(g_wc2)
    CALL t200_menu()
    CLOSE WINDOW t200_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION t200_menu()
 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_q()
   CALL t200_b_askkey()
END FUNCTION
 
FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
#TQC-940172   ---start
    p_cmd           LIKE type_file.chr1
   #p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
   #l_allow_insert  LIKE type_file.chr1,                #No.FUN-680121 VARCHAR(1)#可新增否 
   #l_allow_delete  LIKE type_file.chr1                 #No.FUN-680121 VARCHAR(1)#可刪除否   
#TQC-940172   ---end
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
   #LET l_allow_insert = cl_detail_input_auth('insert') #TQC-940172  
   #LET l_allow_delete = cl_detail_input_auth('delete') #TQC-940172 
 
    LET g_forupd_sql = "SELECT sfb40,sfb01,sfb02,'',sfb04,'',sfb05,",
                       " '','',sfb13,sfb15,sfb08,'',sfb09 FROM sfb_file ",
                       " WHERE sfb01= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    #INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #TQC-940172     
                     INSERT ROW = false,DELETE ROW=false,APPEND ROW=false) #TQC-940172  
 
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
           LET g_sfb_t.* = g_sfb[l_ac].*  #BACKUP
 
           OPEN t200_bcl USING g_sfb_t.sfb01
           IF STATUS THEN
              CALL cl_err("OPEN t200_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
              FETCH t200_bcl INTO g_sfb[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_sfb_t.sfb01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 CALL s_wotype(g_sfb[l_ac].sfb02) RETURNING g_sfb[l_ac].disc1
                 CALL s_wostatu(g_sfb[l_ac].sfb04) RETURNING g_sfb[l_ac].disc2
                 SELECT ima02,ima021,ima55 INTO g_sfb[l_ac].ima02,
                        g_sfb[l_ac].ima021,g_sfb[l_ac].ima55 FROM ima_file
                  WHERE ima01 = g_sfb[l_ac].sfb05
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_sfb[l_ac].* = g_sfb_t.*
           CLOSE t200_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_sfb[l_ac].sfb01,-263,0)
           LET g_sfb[l_ac].* = g_sfb_t.*
        ELSE
           UPDATE sfb_file
              SET sfb40=g_sfb[l_ac].sfb40
            WHERE sfb01 = g_sfb_t.sfb01
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_sfb[l_ac].sfb01,SQLCA.sqlcode,0)   #No.FUN-660128
              CALL cl_err3("upd","sfb_file",g_sfb_t.sfb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
              LET g_sfb[l_ac].* = g_sfb_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
        LET l_ac_t = l_ac                # 新增
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_sfb[l_ac].* = g_sfb_t.*
           END IF
           CLOSE t200_bcl            # 新增
           ROLLBACK WORK             # 新增
           EXIT INPUT
        END IF
        CLOSE t200_bcl               # 新增
        COMMIT WORK
 
#    ON ACTION CONTROLN
#        CALL t200_b_askkey()
#        EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(sfb01) AND l_ac > 1 THEN
            LET g_sfb[l_ac].* = g_sfb[l_ac-1].*
            NEXT FIELD sfb40
         END IF
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
         CALL cl_cmdask()
 
     ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
     END INPUT
 
 
    CLOSE t200_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_b_askkey()
 
    CLEAR FORM
    CALL g_sfb.clear()
 
    CONSTRUCT g_wc2 ON sfb40,sfb01,sfb02,sfb04,sfb05,sfb13,sfb15,sfb08,sfb09
         FROM s_sfb[1].sfb40,s_sfb[1].sfb01,s_sfb[1].sfb02,
              s_sfb[1].sfb04,s_sfb[1].sfb05,s_sfb[1].sfb13,
              s_sfb[1].sfb15,s_sfb[1].sfb08,s_sfb[1].sfb09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL t200_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(600)
 
    LET g_sql =
        "SELECT sfb40,sfb01,sfb02,'',sfb04,'',sfb05,ima02,",
        " ima021,sfb13,sfb15,sfb08,ima55,sfb09",
        " FROM sfb_file,OUTER ima_file ",
        " WHERE sfb_file.sfb05 = ima_file.ima01 AND ", p_wc2 CLIPPED,      #單身
        " ORDER BY sfb40,sfb01,sfb02 "
    PREPARE t200_pb FROM g_sql
    DECLARE sfb_curs CURSOR FOR t200_pb
 
    CALL g_sfb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!"
    FOREACH sfb_curs INTO g_sfb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL s_wotype(g_sfb[g_cnt].sfb02) RETURNING g_sfb[g_cnt].disc1
        CALL s_wostatu(g_sfb[g_cnt].sfb04) RETURNING g_sfb[g_cnt].disc2
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
 
    CALL g_sfb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf   #No.FUN-550067
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.TQC-610037 <001> #
