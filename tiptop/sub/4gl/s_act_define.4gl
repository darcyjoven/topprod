# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_act_define.4gl
# Descriptions...: Action定義維護作業 USING p_zz,p_zy,p_zxw
# Date & Author..: 03/11/25 by Hiko
# Modify.........: 04/06/08 alex 權限變更為使用自己的 table gap_file
# Modify.........: No.MOD-490479 04/11/26 alex 不可變gap06=Y的值
# Modify.........: No.FUN-4C0104 05/01/05 alex 修改 4js bug 定義超長
# Modify.........: No.MOD-540204 05/04/29 alex 移除組合時多出來的逗號
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.TQC-6B0044 06/11/15 pengu s_act_define_set_data_zxwy()中default lc_gap06變數等於null
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   mc_user_or_class   LIKE zz_file.zz01,  #No.FUN-680147 CAHR(10)
         mc_prog            LIKE zz_file.zz01,  #此為權限參照來源
         ms_table           STRING,
         mc_return_act      STRING
DEFINE   mc_default_act     STRING 
DEFINE   mc_detail          LIKE zz_file.zz32   #單身新增或刪除權限訂義
DEFINE   ma_act             DYNAMIC ARRAY OF RECORD
           sel                LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
           gbd01              LIKE gbd_file.gbd01,
           gbd04              LIKE gbd_file.gbd04
                            END RECORD 
DEFINE   mi_rec_b           LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE   mi_cnt             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE   ms_with_gap06      STRING
 
# Memo : p_zz 的參數為: NULL,      prog_name,"zz_file", zz04, zz32 
#      : p_zy 的參數為: class_name,prog_name,"zy_file", zy03, zy07
#      : p_zxw的參數為: user_name, prog_name,"zxw_file",zxw05,zxw08
# 注意 : 本程式的 pc_prog 為 zz08 中權限來源, 如為共用程式請傳共用部份為參照
 
FUNCTION s_act_define(pc_user_or_class, pc_prog, ps_table, pc_default_act, pc_detail)
   DEFINE pc_user_or_class   LIKE zz_file.zz01,         #No.FUN-680147 VARCHAR(10)
          pc_prog            LIKE zz_file.zz01,         #No.FUN-680147 VARCHAR(10)
          ps_table           STRING,
          pc_default_act     STRING,
          pc_detail          LIKE zz_file.zz32
    DEFINE li_correct         LIKE type_file.num5       #MOD-540146 	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET mc_return_act = ""
   LET mc_user_or_class = pc_user_or_class
   LET ms_table = ps_table
   LET mc_detail= pc_detail
 
   IF cl_null(pc_detail) THEN
      LET pc_detail='0'
   END IF
 
   LET mc_default_act = DOWNSHIFT(pc_default_act)
 
   # 2004/06/08 若為 "共用程式" 則傳入值必須為共用之名
   LET mc_prog = pc_prog CLIPPED
 
   OPEN WINDOW w_act_def WITH FORM "sub/42f/s_act_define"
   ATTRIBUTE(STYLE = "act_def")
 
   CALL cl_ui_locale("s_act_define")
 
   # 設定此程式所有的 Action 資料
   # 2004/06/08 設定時改為不傳值, 直接將資料選入 dynamic array
   # 2004/06/21 此處要 by 現在是在哪個地方 if zz_file -> gap_file selected
   #            zy_file and zxw_file -> zz04 selected
   IF ms_table = "zz_file" THEN      #p_zz以後均免設定 2005/05/02補述
      CALL s_act_define_set_data()
   ELSE
      CALL s_act_define_set_data_zxwy() RETURNING li_correct
   END IF
 
   # 根據傳入值  該勾選的就先勾選 
   CALL s_act_define_pre_chked()
 
    # 維護Action資料  MOD-540146
   IF li_correct THEN
      CALL s_act_define_modify()
   ELSE
      LET mc_return_act = s_act_define_sel_action()
      CALL cl_err_msg(NULL, "sub-139",mc_prog CLIPPED,10)
   END IF
 
   CLOSE WINDOW w_act_def
   
  #IF (g_trace = 'Y') THEN
     #display  "s_act_define : Select action = ",mc_return_act
  #END IF
 
   RETURN mc_return_act,mc_detail
END FUNCTION
 
 
FUNCTION s_act_define_set_data_zxwy()
 
   DEFINE li_index      LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE ls_gbd01      STRING
   DEFINE lc_gbd04      LIKE gbd_file.gbd04
   DEFINE lc_zz04       LIKE zz_file.zz04
   DEFINE lt_zz04       base.StringTokenizer
    DEFINE lc_gap06      LIKE gap_file.gap06  #MOD-490479
    DEFINE lc_gbd01      LIKE gbd_file.gbd01  #MOD-540146
 
   # 2004/07/26 zxw_file zz_file 必需改用 zz_file.zz04
   SELECT zz04 INTO lc_zz04 FROM zz_file WHERE zz01=mc_prog
 
   # 2004/07/26 輸出各項 4ad
   LET li_index = 1
   LET ms_with_gap06 = ""
    CALL ma_act.clear()   #MOD-540146
   LET lt_zz04 = base.StringTokenizer.create(lc_zz04 CLIPPED, ",")
 
   WHILE lt_zz04.hasMoreTokens()
      LET ls_gbd01 = lt_zz04.nextToken()
      IF cl_null(ls_gbd01) THEN
         CONTINUE WHILE
      END IF
 
 #     #MOD-540146 Sequencial Changing
      LET lc_gbd01 = ls_gbd01.trim()
      # 2004/11/16 抽離gap06="N" 沒抓到 g_action_choice 的 ="N"
      LET lc_gap06 = NULL      #No.TQC-6B0044 
      SELECT gap06 INTO lc_gap06 FROM gap_file
       WHERE gap01 = mc_prog
          AND gap02 = lc_gbd01  #ma_act[li_index].gbd01  #MOD-540146
      IF UPSHIFT(lc_gap06)="N" THEN
         LET ms_with_gap06 = ms_with_gap06.trimRight(),", ",ls_gbd01.trim()
#        LET ms_with_gap06 = ms_with_gap06.trimRight(),", ",ma_act[li_index].gbd01 CLIPPED
         CONTINUE WHILE
      END IF
 
      LET ma_act[li_index].sel = 'N'
      LET ma_act[li_index].gbd01 = ls_gbd01.trim()
 
      # 2004/06/15 判斷它有沒有寫 "本程式自定的名字" 有的話就查給他
      SELECT gbd04 INTO ma_act[li_index].gbd04 FROM gbd_file
       WHERE gbd_file.gbd01 = ma_act[li_index].gbd01
         AND gbd_file.gbd02 = mc_prog
         AND gbd_file.gbd03 = g_lang 
      IF cl_null(lc_gbd04) THEN
         SELECT gbd04 INTO ma_act[li_index].gbd04 FROM gbd_file
          WHERE gbd_file.gbd01 = ma_act[li_index].gbd01
            AND gbd_file.gbd02 = 'standard'
            AND gbd_file.gbd03 = g_lang 
      END IF
 
      LET li_index = li_index + 1
   END WHILE
   LET li_index = li_index - 1
 
    #MOD-540204
   LET ms_with_gap06 = ms_with_gap06.subString(3,ms_with_gap06.getLength())
 
    #MOD-540146
   IF ma_act.getLength()=0 THEN
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
 
END FUNCTION
 
# 設定此程式所有的 Action 資料
# 2004/06/08 由於記錄表改變, function 改為不傳值
FUNCTION s_act_define_set_data()
   DEFINE li_i          LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE li_index      LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE ls_gbd01      STRING
   DEFINE ls_sql        STRING
   DEFINE lc_gbd04      LIKE gbd_file.gbd04
 
#  2004/06/08 改用 gap_file
   LET ls_sql = "SELECT 'N',gap02,gbd_file.gbd04 ",
                 " FROM gap_file, OUTER gbd_file ",
                " WHERE gap_file.gap01 = '",mc_prog CLIPPED,"'",
                  " AND gap_file.gap02 = gbd_file.gbd01 ",
                  " AND gbd_file.gbd02 = 'standard' ",
                  " AND gbd_file.gbd03='",g_lang CLIPPED,"' ",
                  " AND gap06='N' ",
                " ORDER BY gbd06 ASC,gap02 "
   DECLARE s_act_define_sel CURSOR FROM ls_sql
 
   CALL ma_act.clear()
 
   LET mi_cnt = 1
   LET mi_rec_b = 0
 
   FOREACH s_act_define_sel INTO ma_act[mi_cnt].*       #單身 ARRAY 填充
       LET mi_rec_b = mi_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET mi_cnt = mi_cnt + 1
 
       # 2004/06/15 判斷它有沒有寫 "本程式自定的名字" 有的話就查給他
       SELECT gbd04 INTO lc_gbd04 FROM gbd_file
        WHERE gbd_file.gbd01 = ma_act[mi_cnt].gbd01
          AND gbd_file.gbd02 = mc_prog
          AND gbd_file.gbd03 = g_lang 
       IF NOT cl_null(lc_gbd04) THEN
          LET ma_act[mi_cnt].gbd04 = lc_gbd04 CLIPPED
       END IF
 
       IF mi_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL ma_act.deleteElement(mi_cnt)
 
    LET mi_rec_b = mi_cnt - 1
 
END FUNCTION
 
 
# 根據傳入值  該勾選的就先勾選 
FUNCTION s_act_define_pre_chked()
 
   DEFINE ls_default_act      STRING
   DEFINE lt_default_act      base.StringTokenizer
   DEFINE ls_act_item         STRING
   DEFINE lc_gbd01            LIKE gbd_file.gbd01
   DEFINE li_i                LIKE type_file.num5   	#No.FUN-680147  SMALLINT
 
   # 析出 pre checked 每一項 在該打勾的地方打勾  找不到就算了
   LET ls_default_act = mc_default_act.trim() # CLIPPED
   LET lt_default_act = base.StringTokenizer.create(ls_default_act.trim(), ",")
   WHILE lt_default_act.hasMoreTokens()
 
      LET ls_act_item = lt_default_act.nextToken()
 
      # 2004/04/24 判斷單身及是否擁有 新增或刪除
      # 2004/06/15 結構修改 變成判斷是否有單身類存在
      LET lc_gbd01 = ls_act_item.trim()
 
      FOR li_i = 1 TO ma_act.getLength()
         IF lc_gbd01 = ma_act[li_i].gbd01 THEN
            LET ma_act[li_i].sel = "Y"
         END IF
      END FOR
 
   END WHILE
END FUNCTION
 
 
# 維護Action資料.
FUNCTION s_act_define_modify()
 
   DEFINE   ls_act       STRING
   DEFINE   li_i         LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   lc_sel_t     LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE   lc_detail_sw LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE   li_count     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   l_ac         LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   # 2004/06/16 選取 gap 看看本程式中有沒有屬性是 "單身" 的 action
   LET lc_detail_sw="N"
   LET li_count=0
   SELECT COUNT(*) INTO li_count FROM gap_file
    WHERE gap01=mc_prog AND gap04="Y"
   IF li_count >= 1 THEN LET lc_detail_sw="Y" END IF
 
   INPUT ARRAY ma_act WITHOUT DEFAULTS FROM s_act.*
      ATTRIBUTE(COUNT=ma_act.getLength(), INSERT ROW=FALSE, DELETE ROW=FALSE,
                APPEND ROW=FALSE, UNBUFFERED)
 
      BEFORE INPUT
         IF lc_detail_sw="Y" THEN
            CALL cl_set_act_visible("modify_detail_auth",TRUE)
         ELSE
            CALL cl_set_act_visible("modify_detail_auth",FALSE)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET lc_sel_t = ma_act[l_ac].sel
 
      AFTER INPUT
         IF (INT_FLAG) THEN
            LET mc_return_act = mc_default_act
            LET INT_FLAG = FALSE
         ELSE
            # 不是放棄 那就組起來回傳
            LET mc_return_act = s_act_define_sel_action()
         END IF
 
      ON ACTION select_all
         FOR li_i = 1 TO ma_act.getLength()
            LET ma_act[li_i].sel = "Y"
         END FOR
         LET mc_detail = "0"
         CONTINUE INPUT 
 
      ON ACTION un_select_all
         FOR li_i = 1 TO ma_act.getLength()
            LET ma_act[li_i].sel = "N"
         END FOR
         LET mc_detail = "3"
         CONTINUE INPUT 
 
      ON ACTION modify_detail_auth
         CALL s_act_detail(mc_detail) RETURNING mc_detail
         CONTINUE INPUT 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
END FUNCTION
 
 
# 不是放棄 那就組起來回傳
FUNCTION s_act_define_sel_action()
   DEFINE   li_i            LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   ls_act          STRING  
   DEFINE   lsb_act         STRING
#  DEFINE   lsb_act         base.StringBuffer
 
#  LET lsb_act = base.StringBuffer.create()
   LET lsb_act = ""
 
   FOR li_i = 1 TO ma_act.getLength()
      IF (ma_act[li_i].sel = 'Y') THEN
 
         # 2004/04/16 組回傳, 一個一個組, 但若遇到 detail,需將單身細項也組進去
         # 2004/06/15 不管 單身細項  了  因為獨立為另一欄位
         # 2004/06/15 改 gbd
         LET ls_act = ma_act[li_i].gbd01
         LET ls_act = ls_act.trim()
         IF ls_act.trim() IS NOT NULL THEN
            LET lsb_act = lsb_act.trimRight(),", ",ls_act.trim()
         END IF
      END IF
   END FOR
 
   LET lsb_act = lsb_act.subString(3,lsb_act.getLength())
 
    #MOD-540204
   IF cl_null(lsb_act.trim()) THEN
      LET lsb_act = ms_with_gap06.trim()
   ELSE
      LET lsb_act = lsb_act.trim(),", ",ms_with_gap06.trim()
   END IF
    #MOD-540204
 
   RETURN lsb_act
END FUNCTION
 
 
# 如果遇到 detail 本來沒選但要加選的話
 
FUNCTION s_act_detail(lc_detail)
 
   DEFINE lc_detail        LIKE zz_file.zz32
 
   IF cl_null(lc_detail) THEN LET lc_detail = "0" END IF
   LET INT_FLAG = FALSE
 
   OPEN WINDOW s_act_detail_w WITH FORM "sub/42f/s_act_detail"
   ATTRIBUTE(STYLE = "act_def")
 
   CALL cl_ui_locale("s_act_detail")
 
   INPUT lc_detail WITHOUT DEFAULTS FROM detail
 
      AFTER INPUT
         IF (INT_FLAG) THEN
            LET INT_FLAG = FALSE
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE WINDOW s_act_detail_w
 
   RETURN lc_detail
 
END FUNCTION
 
