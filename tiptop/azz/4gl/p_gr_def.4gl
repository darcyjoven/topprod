# Prog. Version..: '5.30.06-13.04.22(00005)'     #
# Pattern name...: p_gr_def.4gl
# Descriptions...: GR報表樣板整體設定作業
# Date & Author..: FUN-C40048 12/04/23 By odyliao
# Modify.........: FUN-C60096 12/06/25 By odyliao
# Modify.........: FUN-C70095 12/06/25 By janet 增加舊檔備份'單雙行4rp補上}}
# Modify.........: FUN-D40033 13/04/08 By odyliao 增加單雙行顏色屬性的判斷
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
     
PRIVATE DEFINE g_gft DYNAMIC ARRAY OF RECORD  #FUN-C40048
                        gft01    LIKE gft_file.gft01,   #語言別
                        gft02    LIKE gft_file.gft02,   #類別
                        gft03    LIKE gft_file.gft03,   #字型
                        gft04    LIKE gft_file.gft04,   #字型大小
                        gft05    LIKE gft_file.gft05,   #粗體
                        gft06    LIKE gft_file.gft06,   #顏色代號
                        gft07    LIKE gft_file.gft07,   #顏色RGB值
                        gft08    LIKE gft_file.gft08    #對齊位置
                     END RECORD
PRIVATE DEFINE g_gft_t RECORD #舊值
                        gft01    LIKE gft_file.gft01,   #語言別
                        gft02    LIKE gft_file.gft02,   #類別
                        gft03    LIKE gft_file.gft03,   #字型
                        gft04    LIKE gft_file.gft04,   #字型大小
                        gft05    LIKE gft_file.gft05,   #粗體
                        gft06    LIKE gft_file.gft06,   #顏色代號
                        gft07    LIKE gft_file.gft07,   #顏色RGB值
                        gft08    LIKE gft_file.gft08    #對齊位置
                     END RECORD
PRIVATE DEFINE g_wc                 STRING
PRIVATE DEFINE g_sql                STRING
PRIVATE DEFINE g_rec_b              LIKE type_file.num5     # 單身筆數
PRIVATE DEFINE g_cnt                LIKE type_file.num5     
PRIVATE DEFINE l_ac                 LIKE type_file.num5     # 目前處理的ARRAY CNT
PRIVATE DEFINE l_ac_t               LIKE type_file.num5     #FUN-D30034 add
PRIVATE DEFINE g_msg                LIKE type_file.chr1000
PRIVATE DEFINE g_curs_index         LIKE type_file.num10
PRIVATE DEFINE g_row_count          LIKE type_file.num10
PRIVATE DEFINE b_gft                RECORD LIKE gft_file.*
PRIVATE DEFINE g_forupd_sql         STRING
PRIVATE DEFINE g_before_input_done  LIKE type_file.num5
PRIVATE DEFINE g_gft0  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft1  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft2  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft3  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft4  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft5  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft6  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft7  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft8  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft9  RECORD LIKE gft_file.*
PRIVATE DEFINE g_gft_flag LIKE type_file.chr1
PRIVATE DEFINE g_align0 LIKE type_file.chr10
PRIVATE DEFINE g_align1 LIKE type_file.chr10
PRIVATE DEFINE g_align2 LIKE type_file.chr10
PRIVATE DEFINE g_align3 LIKE type_file.chr10
PRIVATE DEFINE g_align4 LIKE type_file.chr10
PRIVATE DEFINE g_align5 LIKE type_file.chr10
PRIVATE DEFINE g_align6 LIKE type_file.chr10
PRIVATE DEFINE g_align7 LIKE type_file.chr10
PRIVATE DEFINE g_align8 LIKE type_file.chr10
PRIVATE DEFINE g_align9 LIKE type_file.chr10
PRIVATE DEFINE g_now_cnt,g_tot_cnt LIKE type_file.num10
PRIVATE DEFINE g_sel   RECORD 
                          lang   LIKE gay_file.gay01,
                          chk0   LIKE type_file.chr1,
                          chk1   LIKE type_file.chr1,
                          chk2   LIKE type_file.chr1,
                          chk3   LIKE type_file.chr1,
                          chk4   LIKE type_file.chr1,
                          chk5   LIKE type_file.chr1,
                          chk6   LIKE type_file.chr1,
                          chk7   LIKE type_file.chr1,
                          chk8   LIKE type_file.chr1,
                          chk9   LIKE type_file.chr1
                       END RECORD

MAIN 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-73001
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
   
   WHENEVER ERROR CONTINUE

   IF (NOT cl_user()) THEN EXIT PROGRAM END IF
   IF (NOT cl_setup("AZZ")) THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW p_gr_def_w WITH FORM "azz/42f/p_gr_def"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   #設定語言別選項
   CALL cl_set_combo_lang("gft01")

   CALL p_gr_def_b_fill(' 1=1')
   CALL p_gr_def_menu()

   CLOSE WINDOW p_gr_def_w                        # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

PRIVATE FUNCTION p_gr_def_cs()                         # QBE 查詢資料

   CALL g_gft.clear()

   CONSTRUCT g_wc ON gft01,gft02,gft03,gft04,gft05,gft06,gft07,gft08
     FROM s_gft[1].gft01, s_gft[1].gft02, s_gft[1].gft03,
          s_gft[1].gft04, s_gft[1].gft05, s_gft[1].gft06,
          s_gft[1].gft07, s_gft[1].gft08

       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION about
          CALL cl_about()
      
       ON ACTION help
          CALL cl_show_help()
      
       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION qbe_select
         CALL cl_qbe_select()

       ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
   

END FUNCTION

FUNCTION p_gr_def_menu()
 
   WHILE TRUE
      CALL p_gr_def_bp("G")
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_gr_def_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_gr_def_q()
        #FUN-C60096----------------(S)
            END IF
         WHEN "update_by_select"
            IF cl_chk_act_auth() THEN
               CALL p_gr_def_update4rp('s')
        #FUN-C60096----------------(E)
            END IF
         WHEN "update_all4rp"
            IF cl_chk_act_auth() THEN
               CALL p_gr_def_update4rp('a')
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION p_gr_def_q()                            #Query 查詢

   CALL cl_msg("")
   CLEAR FORM           #清除畫面
   CALL g_gft.clear()   #清除單身
   
   DISPLAY '' TO FORMONLY.cnt
   CALL p_gr_def_cs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL p_gr_def_b_fill(g_wc)

END FUNCTION
 
FUNCTION p_gr_def_b()                            # 單身
DEFINE p_cmd               LIKE type_file.chr1
DEFINE l_lock_sw           LIKE type_file.chr1
DEFINE l_allow_insert      LIKE type_file.num5
DEFINE l_allow_delete      LIKE type_file.num5
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql = "SELECT gft01,gft02,gft03,gft04,gft05,gft06,gft07,gft08 ",
                      "  FROM gft_file ",
                      " WHERE gft01=? AND gft02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE gr_def_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_gft WITHOUT DEFAULTS FROM s_gft.* 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    #FUN-C70095 add-start---   
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
    #FUN-C70095 add-end--- 

    BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT

         BEGIN WORK

         IF g_rec_b >= l_ac THEN 
            LET p_cmd='u'
            LET g_gft_t.* = g_gft[l_ac].*  #BACKUP
            OPEN gr_def_bcl USING g_gft_t.gft01, g_gft_t.gft02
            IF STATUS THEN
               CALL cl_err("OPEN gr_def_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH gr_def_bcl INTO b_gft.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gft_t.gft02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL p_gr_def_b_move_to() 
               END IF
            END IF
            LET g_before_input_done = FALSE
            CALL p_gr_def_set_entry_b(p_cmd)
            CALL p_gr_def_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont() 
            CALL p_gr_def_gft08combo(g_gft[l_ac].gft02)
         END IF
         NEXT FIELD gft01   #FUN-C70095 add 讓欄位跳至第一個       
      BEFORE INSERT
         LET p_cmd = 'a'
         INITIALIZE g_gft[l_ac].* TO NULL
         LET g_gft_t.* = g_gft[l_ac].*
         LET g_gft[l_ac].gft05 = 'N' #粗體
         LET g_before_input_done = FALSE
         CALL p_gr_def_set_entry_b(p_cmd)
         CALL p_gr_def_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
         CALL p_gr_def_gft08combo(g_gft[l_ac].gft02)
         NEXT FIELD gft01

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gft[l_ac].* = g_gft_t.*
            CLOSE gr_def_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gft[l_ac].gft02,-263,1)
         ELSE
            CALL p_gr_def_b_move_back() 
            UPDATE gft_file SET * = b_gft.*
             WHERE gft01 = g_gft_t.gft01
               AND gft02 = g_gft_t.gft02
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_gft[l_ac].gft01||'/'||g_gft[l_ac].gft02,SQLCA.sqlcode,0)
                LET g_gft[l_ac].* = g_gft_t.*
            ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
            END IF
         END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         CALL p_gr_def_b_move_back() 
         INSERT INTO gft_file VALUES(b_gft.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_gft[l_ac].gft02,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE DELETE
         IF g_gft_t.gft01 IS NOT NULL AND g_gft_t.gft02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM gft_file
             WHERE gft01 = g_gft_t.gft01
               AND gft02 = g_gft_t.gft02
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gft_t.gft02,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_gft[l_ac].* = g_gft_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gft.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE gr_def_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 add
         CLOSE gr_def_bcl
         COMMIT WORK
        
         
      AFTER FIELD gft01 #語言
         IF NOT cl_null(g_gft[l_ac].gft01) THEN
            IF (g_gft[l_ac].gft01 <> g_gft_t.gft01) OR g_gft_t.gft01 IS NULL THEN
               IF NOT p_gr_def_chkkey() THEN NEXT FIELD CURRENT END IF
            END IF
         END IF

      BEFORE FIELD gft02
         CALL p_gr_def_set_entry_b(p_cmd)
         CALL p_gr_def_set_no_entry_b(p_cmd)

      ON CHANGE gft02 
         IF NOT cl_null(g_gft[l_ac].gft02) THEN
            CALL p_gr_def_gft08combo(g_gft[l_ac].gft02)
         END IF

      AFTER FIELD gft02 #類別
         IF NOT cl_null(g_gft[l_ac].gft02) THEN
            IF g_gft[l_ac].gft02 NOT MATCHES '[0123456789]' THEN
               NEXT FIELD CURRENT
            END IF
            IF (g_gft[l_ac].gft02 <> g_gft_t.gft02) OR g_gft_t.gft02 IS NULL THEN
               IF NOT p_gr_def_chkkey() THEN NEXT FIELD CURRENT END IF
            END IF
            CALL p_gr_def_gft08combo(g_gft[l_ac].gft02)
         END IF
         CALL p_gr_def_set_entry_b(p_cmd)
         CALL p_gr_def_set_no_entry_b(p_cmd)

      AFTER FIELD gft04 #字型大小
         IF NOT cl_null(g_gft[l_ac].gft04) THEN
            IF g_gft[l_ac].gft04 <=0 THEN
               CALL cl_err('','aim-391',1)
               NEXT FIELD CURRENT
            END IF
         END IF

      ON CHANGE gft06
         IF NOT cl_null(g_gft[l_ac].gft06) THEN
            IF (g_gft[l_ac].gft06 <> g_gft_t.gft06) OR g_gft_t.gft06 IS NULL THEN
               CASE g_gft[l_ac].gft06
                 WHEN "black"  LET g_gft[l_ac].gft07 = '#000000'
                 WHEN "gray"   LET g_gft[l_ac].gft07 = '#808080'
                 WHEN "blue"   LET g_gft[l_ac].gft07 = '#00008B'
                 WHEN "green"  LET g_gft[l_ac].gft07 = '#006400'
                 WHEN "red"    LET g_gft[l_ac].gft07 = '#8B0000'
               END CASE
            END IF
         END IF
         CALL p_gr_def_set_entry_b(p_cmd)
         CALL p_gr_def_set_no_entry_b(p_cmd)

      AFTER FIELD gft06
         IF NOT cl_null(g_gft[l_ac].gft06) THEN
            IF (g_gft[l_ac].gft06 <> g_gft_t.gft06) OR g_gft_t.gft06 IS NULL THEN
               CASE g_gft[l_ac].gft06
                 WHEN "black"  LET g_gft[l_ac].gft07 = '#000000'
                 WHEN "gray"   LET g_gft[l_ac].gft07 = '#808080'
                 WHEN "blue"   LET g_gft[l_ac].gft07 = '#00008B'
                 WHEN "green"  LET g_gft[l_ac].gft07 = '#006400'
                 WHEN "red"    LET g_gft[l_ac].gft07 = '#8B0000'
                 WHEN "other"  LET g_gft[l_ac].gft07 = NULL
               END CASE
            END IF
         ELSE
            LET g_gft[l_ac].gft07 = NULL
         END IF
         CALL p_gr_def_set_entry_b(p_cmd)
         CALL p_gr_def_set_no_entry_b(p_cmd)


      AFTER FIELD gft07
         IF NOT cl_null(g_gft[l_ac].gft07) THEN
            IF NOT p_gr_def_chk_gft07(g_gft[l_ac].gft07) THEN
               NEXT FIELD CURRENT
            END IF
         END IF

      AFTER FIELD gft08
         IF NOT cl_null(g_gft[l_ac].gft08) THEN
            IF g_gft[l_ac].gft08 NOT MATCHES '[1234]' THEN
               NEXT FIELD CURRENT
            END IF
         END IF
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
    
      ON ACTION CONTROLG
         CALL cl_cmdask()
    
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help   
         CALL cl_show_help()

   END INPUT
END FUNCTION

FUNCTION p_gr_def_b_fill(p_wc)               #BODY FILL UP
DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)

   CALL g_gft.clear()
   LET g_sql = "SELECT gft01,gft02,gft03,gft04,gft05,gft06,gft07,gft08 ",
               "  FROM gft_file ",
               " WHERE ",p_wc,
               " ORDER BY 1,2 "
   PREPARE p_gr_def_fill_pr FROM g_sql
   DECLARE p_gr_def_fill_cs CURSOR FOR p_gr_def_fill_pr
   LET g_cnt = 1
   FOREACH p_gr_def_fill_cs INTO g_gft[g_cnt].*
       IF STATUS THEN CALL cl_err('fill:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gft.deleteElement(g_cnt)
   LET g_rec_b = g_gft.getLength()
   DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION
 
FUNCTION p_gr_def_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gft TO s_gft.* ATTRIBUTE(UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION update_by_select                  #依條件更新
         LET g_action_choice="update_by_select"
         EXIT DISPLAY

      ON ACTION update_all4rp                     #更新全系統4rp
         LET g_action_choice="update_all4rp"
         EXIT DISPLAY
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                    
         CALL cl_set_combo_lang("gft03")
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                          
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_gr_def_set_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gft01,gft02",TRUE)
    END IF

    CALL cl_set_comp_entry("gft03,gft04,gft05,gft06,gft07,gft08",TRUE)

END FUNCTION

FUNCTION p_gr_def_set_no_entry_b(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gft01,gft02",FALSE)
    END IF
    
    IF NOT cl_null(g_gft[l_ac].gft06) THEN
       IF g_gft[l_ac].gft06 <> 'other' THEN
          CALL cl_set_comp_entry("gft07",FALSE)
       END IF
    ELSE
       CALL cl_set_comp_entry("gft07",FALSE)
    END IF

    IF NOT cl_null(g_gft[l_ac].gft02) THEN
       IF g_gft[l_ac].gft02 = '9' THEN
          CALL cl_set_comp_entry("gft03,gft04,gft05,gft08",FALSE)
       END IF
       IF g_gft[l_ac].gft02 = '0' THEN
          CALL cl_set_comp_entry("gft03,gft04,gft05,gft06,gft07",FALSE)
       END IF
    END IF

END FUNCTION

FUNCTION p_gr_def_b_move_back() 

   LET b_gft.gft01=g_gft[l_ac].gft01
   LET b_gft.gft02=g_gft[l_ac].gft02
   LET b_gft.gft03=g_gft[l_ac].gft03
   LET b_gft.gft04=g_gft[l_ac].gft04
   LET b_gft.gft05=g_gft[l_ac].gft05
   LET b_gft.gft06=g_gft[l_ac].gft06
   LET b_gft.gft07=g_gft[l_ac].gft07
   LET b_gft.gft08=g_gft[l_ac].gft08

END FUNCTION

FUNCTION p_gr_def_b_move_to() 

   LET g_gft[l_ac].gft01=b_gft.gft01
   LET g_gft[l_ac].gft02=b_gft.gft02
   LET g_gft[l_ac].gft03=b_gft.gft03
   LET g_gft[l_ac].gft04=b_gft.gft04
   LET g_gft[l_ac].gft05=b_gft.gft05
   LET g_gft[l_ac].gft06=b_gft.gft06
   LET g_gft[l_ac].gft07=b_gft.gft07
   LET g_gft[l_ac].gft08=b_gft.gft08

END FUNCTION

FUNCTION p_gr_def_chk_gft07(p_rgb) 
DEFINE p_rgb LIKE gft_file.gft07
DEFINE l_str LIKE type_file.chr10
DEFINE l_n,i LIKE type_file.num5

    LET l_n = LENGTH(p_rgb)
    IF l_n <> 7 THEN CALL cl_err(p_rgb,'azz1227',1) RETURN FALSE END IF

    IF p_rgb[1,1] <> '#' THEN CALL cl_err(p_rgb,'azz1227',1) RETURN FALSE END IF
    FOR i = 2 TO LENGTH(p_rgb)
        IF p_rgb[i,i] NOT MATCHES '[0123456789ABCDEF]' THEN
           CALL cl_err(p_rgb,'azz1227',1) RETURN FALSE
        END IF
    END FOR

    RETURN TRUE

END FUNCTION

FUNCTION p_gr_def_chkkey() 
DEFINE l_n   LIKE type_file.num5

   IF cl_null(g_gft[l_ac].gft01) THEN RETURN TRUE END IF
   IF cl_null(g_gft[l_ac].gft02) THEN RETURN TRUE END IF

   SELECT COUNT(*) INTO l_n FROM gft_file
    WHERE gft01 = g_gft[l_ac].gft01
      AND gft02 = g_gft[l_ac].gft02
   IF l_n > 0 THEN
      CALL cl_err('','-239',1)
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

FUNCTION p_gr_def_update4rp(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_sql    STRING
DEFINE l_zz01   LIKE zz_file.zz01
DEFINE l_zz011  LIKE zz_file.zz011
DEFINE l_sys    STRING
DEFINE l_mdir   STRING
DEFINE l_gdw01  LIKE gdw_file.gdw01
DEFINE l_gdw02  LIKE gdw_file.gdw02
DEFINE l_gdw03  LIKE gdw_file.gdw03
DEFINE l_gdw04  LIKE gdw_file.gdw04
DEFINE l_gdw05  LIKE gdw_file.gdw05
DEFINE l_gdw06  LIKE gdw_file.gdw06
DEFINE l_gdw08  LIKE gdw_file.gdw08
DEFINE l_gdw09  LIKE gdw_file.gdw09
DEFINE l_gdm03  LIKE gdm_file.gdm03
DEFINE l_4rpdir     STRING
DEFINE l_4rpfile    STRING
DEFINE l_base4rp    STRING
DEFINE l_str,l_tmp  STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_doc        om.DomDocument
DEFINE l_rootnode   om.DomNode
DEFINE l_node_list  om.NodeList
DEFINE l_node       om.DomNode
DEFINE l_node2      om.DomNode
DEFINE l_type       LIKE type_file.chr1
DEFINE l_gdm04_Value LIKE type_file.chr100
DEFINE l_gdm        RECORD LIKE gdm_file.*
DEFINE l_flag1,l_flag2  LIKE type_file.num5
DEFINE l_gay        RECORD LIKE gay_file.*
DEFINE l_success    LIKE type_file.chr1
DEFINE l_errno      LIKE ze_file.ze01
DEFINE l_rwx        LIKE type_file.num5
DEFINE l_cmd        STRING
DEFINE l_now_str   STRING #FUN-C70095 add
DEFINE l_result    BOOLEAN #FUN-C70095 add


   LET g_sel.lang = NULL
   IF p_cmd = 's' THEN
      OPEN WINDOW p_gr_def_1_w WITH FORM "azz/42f/p_gr_def_1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("p_gr_def_1")
      CALL cl_set_combo_lang("lang")
      
      LET g_sel.chk0 = 'N'
      LET g_sel.chk1 = 'N'
      LET g_sel.chk2 = 'N'
      LET g_sel.chk3 = 'N'
      LET g_sel.chk4 = 'N'
      LET g_sel.chk5 = 'N'
      LET g_sel.chk6 = 'N'
      LET g_sel.chk7 = 'N'
      LET g_sel.chk8 = 'N'
      LET g_sel.chk9 = 'N'     
      LET g_sel.lang= g_lang   #FUN-C70095
      INPUT BY NAME g_sel.lang,g_sel.chk0,g_sel.chk1,
                    g_sel.chk2,g_sel.chk3,g_sel.chk4,
                    g_sel.chk5,g_sel.chk6,g_sel.chk7,
                    g_sel.chk8,g_sel.chk9 WITHOUT DEFAULTS
           BEFORE INPUT 

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
       
           ON ACTION about    
              CALL cl_about()  
       
           ON ACTION help       
              CALL cl_show_help()
       
           ON ACTION controlg
              CALL cl_cmdask()
      END INPUT
      CLOSE WINDOW p_gr_def_1_w 
   ELSE
      LET g_sel.chk0 = 'Y'
      LET g_sel.chk1 = 'Y'
      LET g_sel.chk2 = 'Y'
      LET g_sel.chk3 = 'Y'
      LET g_sel.chk4 = 'Y'
      LET g_sel.chk5 = 'Y'
      LET g_sel.chk6 = 'Y'
      LET g_sel.chk7 = 'Y'
      LET g_sel.chk8 = 'Y'
      LET g_sel.chk9 = 'Y'
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=FALSE
      RETURN
   END IF

   IF cl_null(g_sel.lang) THEN LET g_sel.lang = 'a' END IF #全語言
   IF cl_sure(0,0) THEN 
      
      LET l_sql = "SELECT * FROM gay_file WHERE gayacti = 'Y' "
      IF g_sel.lang <> 'a' THEN
         LET l_sql = l_sql CLIPPED, " AND gay01 = '",g_sel.lang,"' ORDER BY gay01 "
      END IF
      PREPARE p_gr_def_gay_pr FROM l_sql
      DECLARE p_gr_def_gay_cs CURSOR FOR p_gr_def_gay_pr
      FOREACH p_gr_def_gay_cs INTO l_gay.*
         CALL p_gr_def_init_gft(l_gay.gay01)
         IF g_gft_flag = 'N' THEN CONTINUE FOREACH END IF #未維護此語言的整體設定
         LET l_sql = "SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                     "                gdw03,gdw09,gdw08,gay01",
                     " FROM gdw_file JOIN gdm_file ON gdw08=gdm01",
                     "   LEFT JOIN (SELECT gay01 FROM gay_file WHERE gay01 = '",l_gay.gay01,"') B ON gdm03=gay01",
                     " ORDER BY gdw01,gdw02,gdw03,gdw09,gay01"
         PREPARE p_gr_def_gdw_pr FROM l_sql
         DECLARE p_gr_def_gdw_cs CURSOR FOR p_gr_def_gdw_pr
         FOREACH p_gr_def_gdw_cs INTO l_gdw01,l_gdw02,l_gdw05,l_gdw04,l_gdw06,
                                      l_gdw03,l_gdw09,l_gdw08,l_gdm03
      
           MESSAGE "Processing:",l_gdw01
           CALL ui.interface.refresh()
           #抓取系統別
           LET l_zz01 = l_gdw01
           LET l_sql = "SELECT zz011 FROM ",s_dbstring("ds") CLIPPED,"zz_file WHERE zz01=?"
           PREPARE p_replang_pre FROM l_sql
           EXECUTE p_replang_pre USING l_zz01 INTO l_zz011
           FREE p_replang_pre
           LET l_sys = l_zz011
           LET l_sys = l_sys.toLowerCase()
           IF l_gdw03 = "Y" THEN
               IF l_sys.getCharAt(1) = "a" THEN
                   CALL cl_err_msg("",'azz1206',l_gdw01,1)
                   LET l_sys = 'c',l_sys.subString(2,l_sys.getLength()) CLIPPED
                   LET l_mdir = l_sys
               ELSE
                   LET l_mdir = l_sys
               END IF
           ELSE
               IF l_sys.getCharAt(1) = "c" THEN
                   LET l_sys = l_sys.subString(2,l_sys.getLength())
                   LET l_sql = "SELECT count(gao01) FROM ",s_dbstring("ds") CLIPPED,"gao_file WHERE gao01=?"
                   PREPARE p_replang_pre1 FROM l_sql
                   EXECUTE p_replang_pre1 USING l_zz011 INTO l_cnt
                   FREE p_replang_pre1
                   IF l_cnt=0 THEN
                       LET l_sys='a',l_sys
                   ELSE
                       LET l_mdir = l_sys
                   END IF
               ELSE
                   LET l_mdir = l_sys
               END IF
           END IF
      
           LET l_4rpdir = os.Path.join(FGL_GETENV(UPSHIFT(l_mdir)),"4rp") #取得4rp路徑
      
           IF os.Path.exists(l_4rpdir) THEN
               LET l_sql = "SELECT * FROM gdm_file WHERE gdm01=? AND gdm03 = ? ORDER BY gdm02"
               DECLARE p_replang_gdm3_cur SCROLL CURSOR FROM l_sql
               
               LET l_4rpfile = os.Path.join(l_4rpdir,l_gdm03 CLIPPED)
               LET l_4rpfile = os.Path.join(l_4rpfile,l_gdw09 CLIPPED||".4rp")
               LET l_base4rp = l_4rpfile

               #FUN-C70095 add-start
               LET l_now_str = CURRENT
               LET l_now_str = cl_replace_str(l_now_str, "-", "")
               LET l_now_str = cl_replace_str(l_now_str, " ", "")
               LET l_now_str = cl_replace_str(l_now_str, ":", "")
               LET l_now_str = cl_replace_str(l_now_str, ".", "")
               LET l_now_str= "BAK",l_now_str
               #將舊檔備份
               CALL os.Path.copy(l_base4rp, l_base4rp || "." || l_now_str) RETURNING l_result
               #FUN-C70095 add-end
               
               LET l_doc = om.DomDocument.createFromXmlFile(l_base4rp)
               IF l_doc IS NOT NULL THEN
                   LET l_rootnode = l_doc.getDocumentElement()
                   IF l_rootnode IS NOT NULL THEN 
                        IF g_sel.chk9 = 'Y' THEN
                           CALL p_gr_def_change_bgcolor(l_rootnode)
                        END IF
                        IF g_sel.chk0 = 'Y' THEN
                           CALL p_gr_def_change_logo(l_rootnode)
                        END IF
                        FOREACH p_replang_gdm3_cur USING l_gdw08,l_gdm03 INTO l_gdm.*
                            LET l_type = p_gr_def_get_type(l_rootnode,l_gdm.gdm04,l_gdm.gdm05)
                            IF l_type = "X" THEN CONTINUE FOREACH END IF
                            CALL p_gr_def_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"_Label\"]",l_doc,l_rootnode,l_gdm.*,"L",l_type)
                            CALL p_gr_def_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V",l_type)
                            CALL p_gr_def_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"_Label\"]",l_doc,l_rootnode,l_gdm.*,"L",l_type)
                            CALL p_gr_def_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V",l_type)
                            CALL p_gr_def_change_node("//DECIMALFORMATBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V",l_type)
                        END FOREACH

                        CALL l_rootnode.writeXml(l_4rpfile)
                    
                        #變更權限為777 Unix/Linux only
                        LET l_rwx = 511 #7*64 + 7*8 + 7
                        IF NOT os.Path.chrwx(l_4rpfile,l_rwx) THEN END IF
                        LET l_cmd = "chmod 777 ",l_4rpfile
                        #DISPLAY l_cmd
                   END IF
               END IF
           END IF
           LET g_now_cnt = g_now_cnt + 1
         END FOREACH
      END FOREACH
   END IF
   CALL cl_msg('')

END FUNCTION

#載入此語言的整體設定
FUNCTION p_gr_def_init_gft(p_gft01)
DEFINE l_sql   STRING
DEFINE p_gft01 LIKE gft_file.gft01

    LET l_sql = "SELECT * FROM gft_file WHERE gft01=? AND gft02=? "
    PREPARE p_gr_def_init_gft_pr FROM l_sql
 
    INITIALIZE g_gft0.* TO NULL
    INITIALIZE g_gft1.* TO NULL
    INITIALIZE g_gft2.* TO NULL
    INITIALIZE g_gft3.* TO NULL
    INITIALIZE g_gft4.* TO NULL
    INITIALIZE g_gft5.* TO NULL
    INITIALIZE g_gft6.* TO NULL
    INITIALIZE g_gft7.* TO NULL
    INITIALIZE g_gft8.* TO NULL
    INITIALIZE g_gft9.* TO NULL

    LET g_gft_flag = 'Y'
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'0' INTO g_gft0.*
    LET g_align0 = p_gr_def_align(g_gft0.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'1' INTO g_gft1.*
    LET g_align1 = p_gr_def_align(g_gft1.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'2' INTO g_gft2.*
    LET g_align2 = p_gr_def_align(g_gft2.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'3' INTO g_gft3.*
    LET g_align3 = p_gr_def_align(g_gft3.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'4' INTO g_gft4.*
    LET g_align4 = p_gr_def_align(g_gft4.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'5' INTO g_gft5.*
    LET g_align5 = p_gr_def_align(g_gft5.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'6' INTO g_gft6.*
    LET g_align6 = p_gr_def_align(g_gft6.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'7' INTO g_gft7.*
    LET g_align7 = p_gr_def_align(g_gft7.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'8' INTO g_gft8.*
    LET g_align8 = p_gr_def_align(g_gft8.gft08) 
    EXECUTE p_gr_def_init_gft_pr USING p_gft01,'9' INTO g_gft9.*
    LET g_align9 = p_gr_def_align(g_gft9.gft08) 

    IF cl_null(g_gft1.gft01) AND cl_null(g_gft2.gft01) AND
       cl_null(g_gft3.gft01) AND cl_null(g_gft4.gft01) AND
       cl_null(g_gft5.gft01) AND cl_null(g_gft6.gft01) AND
       cl_null(g_gft7.gft01) AND cl_null(g_gft8.gft01) AND
       cl_null(g_gft9.gft01) AND cl_null(g_gft0.gft01) THEN
       LET g_gft_flag = 'N'
    END IF

END FUNCTION

FUNCTION p_gr_def_align(p_gft08) 
DEFINE l_align   LIKE type_file.chr10
DEFINE p_gft08   LIKE gft_file.gft08

    LET l_align = NULL
    IF NOT cl_null(p_gft08) THEN
       CASE p_gft08
         WHEN "1" LET l_align = "left"
         WHEN "2" LET l_align = "right"
         WHEN "3" LET l_align = "center"
       END CASE
    END IF

    RETURN l_align

END FUNCTION

FUNCTION p_gr_def_change_node(p_tagname,p_doc,p_node,p_gdm,p_tagtype,p_type)
   DEFINE p_tagname    STRING
   DEFINE p_doc        om.DomDocument
   DEFINE p_node       om.DomNode
   DEFINE p_gdm        RECORD LIKE gdm_file.*        #從DB讀取的屬性
   DEFINE p_tagtype    LIKE type_file.chr1           #L:Label,V:Value
   DEFINE p_type       LIKE type_file.chr1           #N:數字 C:文字
   DEFINE l_nodes      om.NodeList
   DEFINE l_curnode    om.DomNode
   DEFINE l_i          LIKE type_file.num10
   DEFINE l_parent     om.DomNode
   DEFINE l_pos        LIKE type_file.num15_3
   DEFINE l_tmpstr     STRING
   DEFINE l_gdm        RECORD LIKE gdm_file.*        #從4rp讀取的屬性
   DEFINE l_value      LIKE type_file.chr100
   DEFINE l_type       LIKE type_file.chr1           #欄位型態

   LET l_nodes = p_node.selectByPath(p_tagname)
   FOR l_i = 1 TO l_nodes.getLength()
      LET l_curnode = l_nodes.item(l_i)
      LET l_parent = l_curnode.getParent()

      CASE p_tagtype
         WHEN "L"
           #單頭欄位說明
            #IF p_gdm.gdm05 = '1' AND g_gft3.gft01 IS NOT NULL AND g_sel.chk6='Y' THEN #FUN-C70095 mark
            IF p_gdm.gdm05 = '1' AND g_gft3.gft01 IS NOT NULL AND g_sel.chk3='Y' THEN  #FUN-C70095 add
               #字型
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",g_gft3.gft03)
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",g_gft3.gft04)
              #粗體
               LET l_value = p_gr_def_fontbold(g_gft3.gft05)
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",l_value)
              #顏色
               CALL l_curnode.removeAttribute("color")
               CALL l_curnode.setAttribute("color",g_gft3.gft07)
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",g_align3)
            END IF
           #單身欄位說明
            IF p_gdm.gdm05 = '2' AND g_gft6.gft01 IS NOT NULL AND g_sel.chk6='Y' THEN
              #字型
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",g_gft6.gft03)
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",g_gft6.gft04)
              #粗體
               LET l_value = p_gr_def_fontbold(g_gft6.gft05)
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",l_value)
              #顏色
               CALL l_curnode.removeAttribute("color")
               CALL l_curnode.setAttribute("color",g_gft6.gft07)
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",g_align3)
            END IF
         
         WHEN "V"
           #單頭欄位
            IF p_gdm.gdm05 = '1' AND g_gft4.gft01 IS NOT NULL AND g_sel.chk4='Y' THEN
              #字型
               CALL l_curnode.removeAttribute("fontName")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("fontName",g_gft4.gft03)
               ELSE   
                  CALL l_curnode.setAttribute("fontName",g_gft5.gft03)
               END IF
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("fontSize",g_gft4.gft04)
               ELSE   
                  CALL l_curnode.setAttribute("fontSize",g_gft5.gft04)
               END IF
              #粗體
               CALL l_curnode.removeAttribute("fontBold")
               IF p_type = 'C' THEN
                  LET l_value = p_gr_def_fontbold(g_gft4.gft05)
                  CALL l_curnode.setAttribute("fontBold",l_value)
               ELSE   
                  LET l_value = p_gr_def_fontbold(g_gft5.gft05)
                  CALL l_curnode.setAttribute("fontBold",l_value)
               END IF
              #顏色
               CALL l_curnode.removeAttribute("color")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("color",g_gft4.gft07)
               ELSE   
                  CALL l_curnode.setAttribute("color",g_gft5.gft07)
               END IF
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("textAlignment",g_align4)
               ELSE   
                  CALL l_curnode.setAttribute("textAlignment",g_align5)
               END IF
            END IF
           #單身欄位
            IF p_gdm.gdm05 = '2' AND g_gft7.gft01 IS NOT NULL AND g_sel.chk7='Y' THEN
              #字型
               CALL l_curnode.removeAttribute("fontName")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("fontName",g_gft7.gft03)
               ELSE   
                  CALL l_curnode.setAttribute("fontName",g_gft8.gft03)
               END IF
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("fontSize",g_gft7.gft04)
               ELSE   
                  CALL l_curnode.setAttribute("fontSize",g_gft8.gft04)
               END IF
              #粗體
               CALL l_curnode.removeAttribute("fontBold")
               IF p_type = 'C' THEN
                  LET l_value = p_gr_def_fontbold(g_gft7.gft05)
                  CALL l_curnode.setAttribute("fontBold",l_value)
               ELSE   
                  LET l_value = p_gr_def_fontbold(g_gft8.gft05)
                  CALL l_curnode.setAttribute("fontBold",l_value)
               END IF
              #顏色
               CALL l_curnode.removeAttribute("color")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("color",g_gft7.gft07)
               ELSE   
                  CALL l_curnode.setAttribute("color",g_gft8.gft07)
               END IF
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               IF p_type = 'C' THEN
                  CALL l_curnode.setAttribute("textAlignment",g_align7)
               ELSE   
                  CALL l_curnode.setAttribute("textAlignment",g_align8)
               END IF
            END IF
           #title1
            IF p_gdm.gdm05 = '3' AND g_gft1.gft01 IS NOT NULL AND p_gdm.gdm04='title1' AND g_sel.chk1='Y' THEN
              #字型
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",g_gft1.gft03)
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",g_gft1.gft04)
              #粗體
               LET l_value = p_gr_def_fontbold(g_gft1.gft05)
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",l_value)
              #顏色
               CALL l_curnode.removeAttribute("color")
               CALL l_curnode.setAttribute("color",g_gft1.gft07)
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",g_align1)
            END IF
           #title2
            IF p_gdm.gdm05 = '3' AND g_gft2.gft01 IS NOT NULL AND p_gdm.gdm04='title2' AND g_sel.chk2='Y' THEN
              #字型
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",g_gft2.gft03)
              #字型大小
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",g_gft2.gft04)
              #粗體
               LET l_value = p_gr_def_fontbold(g_gft2.gft05)
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",l_value)
              #顏色
               CALL l_curnode.removeAttribute("color")
               CALL l_curnode.setAttribute("color",g_gft2.gft07)
              #對齊
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",g_align2)
            END IF
      END CASE

   END FOR
END FUNCTION

FUNCTION p_gr_def_fontbold(p_gft05)
DEFINE p_gft05  LIKE gft_file.gft05
DEFINE l_value  LIKE type_file.chr10

    IF cl_null(p_gft05) THEN
       LET l_value = 'false'
    ELSE
       IF p_gft05 = 'Y' THEN
          LET l_value = 'true'
       ELSE
          LET l_value = 'false'
       END IF
    END IF

    RETURN l_value

END FUNCTION

FUNCTION p_gr_def_get_type(p_node,p_gdm04,p_gdm05)
DEFINE p_gdm04      LIKE gdm_file.gdm04
DEFINE p_gdm05      LIKE gdm_file.gdm05
DEFINE p_node       om.DomNode
DEFINE l_node_list  om.NodeList
DEFINE l_node       om.DomNode
DEFINE l_type       LIKE type_file.chr100
DEFINE l_i          LIKE type_file.num5
DEFINE l_str        STRING
DEFINE l_chr        LIKE type_file.chr1
DEFINE l_tagname    LIKE type_file.chr1000
DEFINE l_name       LIKE type_file.chr100
DEFINE l_name1      LIKE type_file.chr100

   IF p_gdm04 = 'title1' THEN RETURN 'C' END IF
   IF p_gdm04 = 'title2' THEN RETURN 'C' END IF
   IF p_gdm05 NOT MATCHES '[12]' THEN RETURN 'X' END IF #目前僅處理單頭/單身/title欄位,其它類不處理

   LET l_tagname = "rtl:input-variable"
   LET l_node_list = p_node.selectByTagName(l_tagname)
   LET l_chr = "C"
   LET l_i = l_node_list.getLength()
   FOR l_i = 1 TO l_node_list.getLength()
      LET l_node = l_node_list.item(l_i)
      LET l_name = l_node.getAttribute("name")
      LET l_name1= l_name CLIPPED,"_1"
      IF l_name = p_gdm04 OR l_name1 = p_gdm04 THEN
         LET l_type = l_node.getAttribute("type")
         IF l_type = "FGLNumeric" THEN
            LET l_chr = "N"
         ELSE
            LET l_chr = "C"
         END IF
         EXIT FOR
      END IF
   END FOR

   RETURN l_chr

END FUNCTION

FUNCTION p_gr_def_change_bgcolor(p_node)
DEFINE p_node       om.DomNode
DEFINE l_node_list  om.NodeList
DEFINE l_i          LIKE type_file.num5
DEFINE l_str        STRING
DEFINE l_name       LIKE type_file.chr100
DEFINE l_name1      LIKE type_file.chr100
DEFINE l_bgcolor    STRING
DEFINE l_curnode    om.DomNode

   LET l_node_list = p_node.selectByTagName("LAYOUTNODE")
   LET l_i = l_node_list.getLength()
   FOR l_i = 1 TO l_node_list.getLength()
      LET l_curnode = l_node_list.item(l_i)
      LET l_name = l_curnode.getAttribute("name")
      IF l_curnode.getAttribute("name") = "Details" THEN
        #FUN-D40033 add----(s)
         LET l_str = NULL
         LET l_str = l_curnode.getAttribute("bgColor")
         IF cl_null(l_str) THEN CONTINUE FOR END IF
        #FUN-D40033 add----(e)
         CASE g_gft9.gft06 
           WHEN "black" LET l_str = "BLACK"
          # WHEN "gray"  LET l_str = "LIGHT-GRAY" #FUN-C70095 mark
           WHEN "gray"  LET l_str = "LIGHT_GRAY"  #FUN-C70095 add
           WHEN "blue"  LET l_str = "BLUE"
           WHEN "green" LET l_str = "GREEN"
           WHEN "red"   LET l_str = "RED"
           OTHERWISE    LET l_str = "WHITE"
         END CASE
         LET l_bgcolor = "{{l_lineno%2==1?Color.WHITE:Color.",l_str,"}}" #FUN-C70095 ADD ,"}}"
         
         CALL l_curnode.removeAttribute("bgColor")
         CALL l_curnode.setAttribute("bgColor",l_bgcolor)
         LET l_str = l_curnode.toString()
      END IF
   END FOR
END FUNCTION

FUNCTION p_gr_def_gft08combo(p_gft02)
DEFINE p_gft02  LIKE gft_file.gft02
DEFINE l_item   LIKE ze_file.ze03
DEFINE l_desc   LIKE ze_file.ze03

   IF l_ac <=0 THEN RETURN END IF
   IF cl_null(p_gft02) THEN RETURN END IF

   IF p_gft02 = '0' THEN #LOGO僅靠左&靠右
      LET l_item = cl_getmsg('azz1229',g_lang)
      LET l_desc = cl_getmsg('azz1230',g_lang)
   ELSE
      LET l_item = cl_getmsg('azz1231',g_lang)
      LET l_desc = cl_getmsg('azz1232',g_lang)
   END IF
   CALL cl_set_combo_items("gft08",l_item,l_desc)   

END FUNCTION

FUNCTION p_gr_def_change_logo(p_node)
DEFINE p_node       om.DomNode
DEFINE l_node_list  om.NodeList
DEFINE l_i          LIKE type_file.num5
DEFINE l_str        STRING
DEFINE l_align      LIKE type_file.chr100
DEFINE l_name       LIKE type_file.chr100
DEFINE l_curnode    om.DomNode

   LET l_node_list = p_node.selectByTagName("IMAGEBOX")
   LET l_i = l_node_list.getLength()
   FOR l_i = 1 TO l_node_list.getLength()
      LET l_curnode = l_node_list.item(l_i)
      LET l_name = l_curnode.getAttribute("name")
      IF l_curnode.getAttribute("name") = "logo_Value" THEN
         CASE g_gft0.gft08 
           WHEN "1"     LET l_str = "0.000cm"
           WHEN "2"     LET l_str = "max-2.5cm"
           OTHERWISE    LET l_str = "x"
         END CASE
         IF l_str <> "x" THEN
            LET l_align = l_curnode.getAttribute("y")
            IF NOT cl_null(l_align) THEN
               CALL l_curnode.removeAttribute("y")
               CALL l_curnode.setAttribute("y",l_str)
            ELSE
               CALL l_curnode.removeAttribute("x")
               CALL l_curnode.setAttribute("x",l_str)
            END IF
         END IF
      END IF
   END FOR
END FUNCTION
