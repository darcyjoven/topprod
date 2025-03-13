# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_act_desc_tab.4gl
# Descriptions...: Action 說明轉換為依語言別顯示 (資料來源 4ad多語言對照檔gbd)
# Date & Author..: 04/04/06 alex
# Modify.........: 04/08/19 alex 找不到該語言別的說明時則 show 原值
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
 
DATABASE ds  #FUN-850069 FUN-7C0053
 
GLOBALS "../../config/top.global"  
 
   DEFINE   ms_return_act      STRING
   DEFINE   mc_default_action  LIKE zy_file.zy03
   DEFINE   ma_act             DYNAMIC ARRAY OF RECORD
            act_name           STRING,
            act_desc           STRING
                               END RECORD 
   DEFINE   mc_show_method     LIKE type_file.chr1        # Show 的方法 	#No.FUN-680147 VARCHAR(1)
   DEFINE   mc_prog            LIKE zz_file.zz01
   DEFINE   mc_detail          LIKE zz_file.zz32
 
 
# Descriptions...: Action 說明轉換為依語言別顯示 (資料來源 4ad多語言對照檔gbd)
# Input Parameter: pc_prog           程式名稱 Ex.zz01,zy02,zxw04
#                  pc_default_action 權限清單 Ex.zz04,zy03,zxw05
#                  pc_detail         單身權限 Ex.zz32,zy07,zxw08
#                  pc_show_method    顯示方式 Ex."0"Enter切開, 直排顯示如 p_zz
#                                                "1"兩空白切開,橫排顯示如 p_zy
# Return Code....: ls_zz_ds 要顯示的字串
 
FUNCTION s_act_desc_tab(pc_prog,pc_default_action,pc_detail,pc_show_method)
 
   DEFINE   pc_default_action  LIKE zy_file.zy03
   DEFINE   pc_show_method     LIKE type_file.chr1        # 顯示的方法 	#No.FUN-680147 VARCHAR(1)
   DEFINE   pc_prog            LIKE zz_file.zz01
   DEFINE   pc_detail          LIKE zz_file.zz32
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET mc_default_action = DOWNSHIFT(pc_default_action)
   LET mc_show_method = pc_show_method
   LET mc_prog = pc_prog CLIPPED
   LET mc_detail = pc_detail CLIPPED
 
   CALL s_act_desc_tab_get_set() RETURNING ms_return_act
   RETURN ms_return_act
 
END FUNCTION
 
 
# Descriptions...: 抓取傳入值並與資料陣列做比對
 
FUNCTION s_act_desc_tab_get_set()
 
   DEFINE   lc_gbd04        LIKE gbd_file.gbd04
   DEFINE   lc_gbd01        LIKE gbd_file.gbd01
   DEFINE   lst_act         base.StringTokenizer,
            ls_act          STRING
   DEFINE   ls_return_act   STRING
   DEFINE   lc_detail       LIKE zy_file.zy07   # 進單身的權限
   DEFINE   li_count        LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   ls_sql          STRING
   DEFINE   lc_gae02        LIKE gae_file.gae02
 
   LET lst_act = base.StringTokenizer.create(mc_default_action CLIPPED, ",")
  
   LET ls_return_act = ""
  
   WHILE lst_act.hasMoreTokens()
      LET ls_act = lst_act.nextToken()
      LET ls_act = ls_act.trim()
 
      # 2004/04/24 判斷單身  及是否擁有 新增或刪除
      LET lc_gbd01 = ls_act.trim()
      LET lc_gbd04=""
 
      # 2004/04/06 由 gbd 多語言對照檔帶出資料, 語言別採 g_lang
      SELECT gbd04 INTO lc_gbd04 FROM gbd_file
       WHERE gbd01 = lc_gbd01 AND gbd02 = mc_prog AND gbd03 = g_lang
      # 2004/06/10 gbd_file 資料結構改變
      IF STATUS = 100 THEN
         SELECT gbd04 INTO lc_gbd04 FROM gbd_file
          WHERE gbd01 = lc_gbd01 AND gbd02 = "standard" AND gbd03 = g_lang
         IF STATUS OR cl_null(lc_gbd04) THEN
            LET lc_gbd04=lc_gbd01
         END IF
      END IF
 
      LET ls_return_act = ls_return_act.append(lc_gbd04 CLIPPED)
      CASE mc_show_method
        WHEN "0"   # Enter Cut
           LET ls_return_act = ls_return_act.append(ASCII 10)
        WHEN "1"   # 2 Spaces Cut
           LET ls_return_act = ls_return_act.append(2 SPACES)
      END CASE
   END WHILE
 
   # 2004/04/24 如果是單身權限說明顯示  則在單身顯示後再來說明細項
   LET li_count=0
   LET lc_gbd04=""
   SELECT count(*) INTO li_count FROM gap_file 
    WHERE gap01=mc_prog AND gap04="Y"
   IF li_count >= 1 THEN
 
      LET ls_sql=" SELECT gae04 FROM gae_file ",
                  " WHERE gae01='s_act_detail' AND gae02=? AND gae03=? "
      PREPARE s_detail_pre FROM ls_sql
      LET lc_gae02="detail_",mc_detail
      EXECUTE s_detail_pre USING lc_gae02, g_lang INTO lc_gbd04
 
      LET ls_return_act = ls_return_act.append(lc_gbd04 CLIPPED)
      FREE s_detail_pre
   END IF
 
   RETURN ls_return_act
 
END FUNCTION
 
