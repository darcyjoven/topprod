# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: p_preview.4gl
# Descriptions...: 檢視per,並將畫面上的Description更新到gae_file內.
# Date & Author..: 2003/07/29 by Hiko
# Memo...........: 1. 此程式須與r.gf配合使用.
#                  2. 如果希望能夠自動關閉畫面,則要呼叫p_preview_close_win().
# Modify.........: 04/03/06 多語言檔gae_file將不同語言拆開成不同筆資料
#                           並將設定檔拆到gav_file, 故於update,insert修改
# Modify.........: 04/06/30 刪除gae_file,gav_file中不在畫面上的欄位
# Modify.........: 04/08/11 增加gae11 客製註記，刪除資料依據客製或非客
#                           製刪除資料
# Modify.........: No.MOD-4A0089 04/10/06 By alex 客製per檔時, 若為原有程式則將內 有欄位敘述搬到客製資料內
# Modify.........: No.MOD-4B0031 04/11/03 By alex 改變是否要開窗的作法
# Modify.........: No.FUN-4B0041 04/11/10 By alex 改變抓檔路徑, COMMENTS, 自動補資料
# Modify.........: No.MOD-4C0081 04/12/14 By alex 增加gav09欄位
# Modify.........: No.MOD-4C0124 04/12/21 By alex 增加gav10欄位, 畫面若有NOT NULL,REQUIRED的設定者就為必要欄位
# Modify.........: No.MOD-510182 05/01/31 By alex 修改TableColumn comment節點
# Modify.........: No.FUN-520015 05/02/16 By alex 修改為只有 comments 也可以自動抓入
# Modify.........: No.FUN-520002 05/07/21 By saki 自訂欄位預設不可顯示
# Modify.........: No.FUN-550115 05/06/10 By alex 修改抓取資料來源,新增 gae_file pkg
# Modify.........: No.FUN-590075 05/09/25 By alex add Modify Date about gae10
# Modify.........: No.TQC-590006 05/09/27 By alex TOP66無此問題
# Modify.........: No.MOD-590432 05/09/27 By alex 修改 cgxx 模組判斷方式
# Modify.........: No.FUN-5A0002 05/10/17 By alex Modify some Restricted id for system
# Modify.........: No.TQC-5A0068 05/10/20 By alex 單身允許使用RadioGroup(橫的)
# Modify.........: No.MOD-590390 05/10/20 By alex 限制CheckBox只抓TEXT屬性,放棄LABEL
# Modify.........: No.TQC-5C0084 05/12/19 By saki 增加ain模組後要改面module的處理
# Modify.........: No.FUN-5C0052 05/12/23 By alex 補完ain模組後要改面module的處理
# Modify.........: No.FUN-610065 06/01/13 By saki 若畫面有自訂欄位則增加設定到gbr_file，做欄位自動控管
# Modify.........: No.FUN-630089 06/03/29 By saki 將畫面上例如Matrix的欄位加入到gav_file中
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-570225 06/11/02 By saki 以udmtree相關開頭的per檔也可r.gf
# Modify.........: No.FUN-710055 07/01/23 By saki 自定義功能 抓取設定
# Modify.........: No.FUN-740186 07/04/26 By alexstar r.gf在搜尋資料時會造成key值重複的狀況
# Modify.........: No.FUN-760049 07/06/20 By saki 行業別代碼更動
# Modify.........: No.FUN-790045 07/11/06 By saki r.gf insert gav資料時, 設定為不可視
# Modify.........: No.FUN-7C0042 07/12/13 By alex 將英文部份異動預設變更為 不異動
# Modify.........: No.FUN-7B0081 08/01/09 By alex lc_comment由gae05移至gbs06
# Modify.........: No.FUN-840011 08/04/02 By saki 自定義欄位預設為可視但不可輸入, 要使用時開啟可輸入欄位
# Modify.........: No.FUN-840199 08/05/02 By saki Matrix自動抓取Label,進入p_perlang維護
# Modify.........: No.FUN-950073 09/05/21 By saki 行業別欄位by行業別資料設定為可視或不可視
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-990052 09/09/24 By Hiko 修改自定義欄位調整後,被r.gf還原的問題
# Modify.........: No.TQC-9C0063 09/12/09 by saki r.gf回復畫面原始設計時, 所有行業別都需處理
# Modify.........: No:TQC-9C0176 09/12/30 By saki 第一次新增gav_file的時候, 就更新必要欄位的值
# Modify.........: No.TQC-AC0025 10/12/02 By keivn 以gridwidth優先
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE gc_frm_name       LIKE gae_file.gae01
DEFINE g_form            DYNAMIC ARRAY OF RECORD
          field_name     LIKE type_file.chr20         #FUN-680135 VARCHAR(20)
                         END RECORD
DEFINE g_cnt             LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE g_cust_flag       LIKE type_file.chr1          # 客製註記  #No.FUN-680135 VARCHAR(1)
DEFINE g_auto_close_win  LIKE type_file.chr1          #FUN-680135 VARCHAR(1)
DEFINE g_syskeep         LIKE type_file.num5          #FUN-680135 SMALLINT  #FUN-5A0002
DEFINE g_gav_cnt         LIKE type_file.num5          #No.FUN-710055
DEFINE g_item_flag       LIKE type_file.num5          #No.FUN-710055
DEFINE g_gav11           DYNAMIC ARRAY OF LIKE gav_file.gav11  #No.FUN-710055
DEFINE g_tabIndex_max    LIKE gav_file.gav16          #No.FUN-710055
DEFINE g_std_id          LIKE smb_file.smb01          #No.FUN-710055
DEFINE g_upd_auto        LIKE type_file.chr1          #FUN-7C0042
DEFINE g_smb01           DYNAMIC ARRAY OF LIKE smb_file.smb01  #No.FUN-950073
 
MAIN
  DEFINE ls_frm_name STRING
  DEFINE ls_module   STRING
  DEFINE ls_checking STRING
  DEFINE ls_frm_path STRING
  DEFINE ls_cmd      STRING
  DEFINE ls_cust     STRING
  DEFINE lc_flag     STRING
  DEFINE lc_gao01    LIKE gao_file.gao01
  DEFINE li_n        LIKE type_file.num5    #FUN-680135 SMALLINT
  DEFINE li_error    LIKE type_file.num5    #FUN-680135 SMALLINT
  DEFINE lc_gax02    LIKE gax_file.gax02    #FUN-5C0052
  DEFINE lc_zz011    LIKE zz_file.zz011     #FUN-5C0052
  DEFINE ls_sql      STRING                 #No.FUN-710055
  DEFINE lc_gav01    LIKE gav_file.gav01    #No.FUN-710055
  DEFINE lc_gav11    LIKE gav_file.gav11    #No.FUN-710055
  DEFINE l_gav_cnt   SMALLINT
 
  LET ls_frm_name       = ARG_VAL(1)
  LET g_lang            = ARG_VAL(2)
  LET lc_flag           = UPSHIFT(ARG_VAL(3))
  LET g_upd_auto        = UPSHIFT(ARG_VAL(4))  #No.FUN-7C0042
  LET g_auto_close_win  = UPSHIFT(ARG_VAL(5))  #No.FUN-710055
 
  CLOSE WINDOW screen
 
  WHENEVER ERROR CALL cl_err_msg_log           #No.FUN-710055
 
  IF cl_null(g_auto_close_win) OR g_auto_close_win<>"N" THEN
     LET g_auto_close_win = "Y"
  END IF
 
  IF cl_null(g_auto_close_win) OR g_auto_close_win<>"Y" THEN
     LET g_auto_close_win = "N"             #Default N FUN-7C0042
  END IF
 
  IF cl_null(lc_flag) OR lc_flag NOT MATCHES "[CP]" THEN
     CALL p_preview_error_msg()
     EXIT PROGRAM
  END IF
 
# #FUN-5A0002
  SELECT count(*) INTO li_n FROM gay_file
   WHERE gay01 = g_lang
  IF li_n <= 0 OR STATUS THEN
     CALL p_preview_error_msg()
     EXIT PROGRAM
  END IF
 
  # 2004/08/11 by saki : 確認客製符號正確
  CASE lc_flag
     WHEN "C" 
        LET g_cust_flag = "Y"
     WHEN "P" 
        LET g_cust_flag = "N"
     OTHERWISE
        CALL p_preview_error_msg()
        EXIT PROGRAM
  END CASE
 
  #Sys
  SELECT count(*) INTO li_n FROM gay_file WHERE gay01='1'
  IF li_n >= 1 THEN
     LET g_syskeep = 0
  ELSE
     LET g_syskeep = 100
  END IF
 
  # 2004/11/10 改寫系統判斷式
  LET ls_checking = ls_frm_name.toLowerCase()
  LET li_error = FALSE
  CASE
     # 1.當 frm_name 以 a or g 開頭時, 必為標準 package
     WHEN ls_checking.subString(1,1)="a" OR ls_checking.subString(1,1)="g"
        FOR li_n=3 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(1,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
        IF g_cust_flag = "Y" AND NOT li_error THEN
#          #MOD-590432
           IF ls_checking.subString(1,1)="a" THEN
              LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
           ELSE
              LET ls_module = "c" || ls_module.subString(1,ls_module.getLength())
           END IF
##         ##MOD-590432
        END IF
 
     # 2.當 frm_name 以 sa or sg 開頭時, 必為標準 package
     WHEN ls_checking.subString(1,2)="sa" OR ls_checking.subString(1,2)="sg"
        FOR li_n=4 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(2,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
        IF g_cust_flag = "Y" AND NOT li_error THEN
           LET ls_module = "c" || ls_module.subString(2,ls_module.getLength())
        END IF
 
     # 3.當 frm_name 以 sc 開頭時, 必為客製模組
     WHEN ls_checking.subString(1,2)="sc" 
        LET g_cust_flag = "Y"
        FOR li_n=4 TO ls_checking.getLength()
           LET ls_module = ls_checking.subString(2,li_n)
           LET lc_gao01 = UPSHIFT(ls_module.trim())
           SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
           IF NOT SQLCA.SQLCODE THEN
              LET li_error=FALSE
              EXIT FOR
           ELSE
              LET li_error=TRUE
           END IF
        END FOR
 
     # 4.當 frm_name 以 p_ 開頭時, 必為 azz or czz
     WHEN ls_checking.subString(1,2)="p_" OR ls_checking.trim()="udm_tree" OR
          ls_checking.subString(1,8)="udm_tree" OR ls_checking.subString(1,7)="udmtree"   #No.FUN-570225
        IF g_cust_flag = "Y" THEN
           LET ls_module = "czz"
        ELSE
           #No.TQC-5C0084 --start--
           IF ls_checking = "p_zl" OR ls_checking = "p_syc" OR
              ls_checking = "p_zln" THEN
              LET ls_module = "ain"
           ELSE
              LET lc_gax02 = ls_checking.trim()                #FUN-5C0052
              SELECT zz011 INTO lc_zz011 FROM zz_file,gax_file
               WHERE gax02 = lc_gax02 AND gax01 = zz01
              IF DOWNSHIFT(lc_zz011) = "ain" THEN
                 LET ls_module = "ain"
              ELSE
                 LET ls_module = "azz"
              END IF
           END IF
           #No.TQC-5C0084 ---end---
        END IF
 
     # 5.當 frm_name 以 s_ 開頭時, 必為 sub or csub
     WHEN ls_checking.subString(1,2)="s_" 
        IF g_cust_flag = "Y" THEN
           LET ls_module = "csub"
        ELSE
           LET ls_module = "sub"
        END IF
 
     # 6.當 frm_name 以 q_ 開頭時, 必為 qry or cqry
     WHEN ls_checking.subString(1,2)="q_" 
        IF g_cust_flag = "Y" THEN
           LET ls_module = "cqry"
        ELSE
           LET ls_module = "qry"
        END IF
 
     # 3.當 frm_name 以 cl_or ccl_開頭時, 必為 lib or clib
     # 4.當 frm_name 以 cp_ 開頭時, 必為 czz
     # 5.當 frm_name 以 cs_ 開頭時, 必為 csub
     # 6.當 frm_name 以 cq_ 開頭時, 必為 cqry
     # 7.當 frm_name 以 c  or cg  開頭時,但非為 cl_或ccl_ 必為客製模組
     WHEN ls_checking.subString(1,1)="c" 
 
        CASE
           WHEN ls_checking.subString(2,3)="l_"
              IF g_cust_flag = "Y" THEN
                 LET ls_module = "clib"
              ELSE
                 LET ls_module = "lib"
              END IF
           WHEN ls_checking.subString(2,4)="cl_"
              LET g_cust_flag = "Y"
              LET ls_module = "clib"
           WHEN ls_checking.subString(2,3)="p_"
              LET g_cust_flag = "Y"
              LET ls_module = "czz"
           WHEN ls_checking.subString(2,3)="q_"
              LET g_cust_flag = "Y"
              LET ls_module = "cqry"
           WHEN ls_checking.subString(2,3)="s_"
              LET g_cust_flag = "Y"
              LET ls_module = "csub"
           OTHERWISE
              LET g_cust_flag = "Y"
              FOR li_n=3 TO ls_checking.getLength()
                 LET ls_module = ls_checking.subString(1,li_n)
                 LET lc_gao01 = UPSHIFT(ls_module.trim())
                 SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
                 IF NOT SQLCA.SQLCODE THEN
                    LET li_error = FALSE
                    EXIT FOR
                 ELSE
                    LET li_error = TRUE
                 END IF
              END FOR
        END CASE
 
 
     OTHERWISE
        CALL p_preview_error_msg()
        EXIT PROGRAM
 
  END CASE
 
  IF li_error THEN
     DISPLAY " "
     DISPLAY " WARNING!!, ",ls_module.trim()," must be satisfied by NAMEING RULES !!"
     DISPLAY " "
     CALL p_preview_error_msg()
     EXIT PROGRAM
  END IF
 
  IF g_cust_flag = "Y" THEN
     LET ls_frm_path = "../topcust/" || ls_module || "/42f/" || ls_frm_name
  ELSE
     LET ls_frm_path = ls_module || "/42f/" || ls_frm_name
  END IF
 
  DISPLAY "ls_frm_path=" ,ls_frm_path
 
  OPEN WINDOW w_curr WITH FORM ls_frm_path
 
  LET gc_frm_name = ls_frm_name
  CALL g_form.clear()
  LET g_cnt = 1
 
  #No.FUN-710055 --start--
  #一般行業別代碼
# SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"   #No.FUN-760049
  LET g_std_id = "std"       #No.FUN-760049
 
  DECLARE gavcnt_curs CURSOR FOR
   SELECT UNIQUE gav01,gav11 FROM gav_file WHERE gav01=gc_frm_name AND gav08=g_cust_flag
  FOREACH gavcnt_curs INTO lc_gav01,lc_gav11
     LET g_gav_cnt = g_gav_cnt + 1
     LET g_gav11[g_gav_cnt]=lc_gav11
  END FOREACH
  IF g_gav11.getLength() = 0 THEN
     LET g_gav11[1]=g_std_id
  END IF
  #No.FUN-710055 ---end---
 
  #No.FUN-950073 --start--
  DECLARE smb_curs CURSOR FOR
     SELECT UNIQUE smb01 FROM smb_file
  LET li_n = 1
  FOREACH smb_curs INTO g_smb01[li_n]
     LET li_n = li_n + 1
  END FOREACH
  CALL g_smb01.deleteElement(li_n)
  #No.FUN-950073 ---end---
 
  CALL p_preview_node_list("Page")
  CALL p_preview_node_list("Group")
  CALL p_preview_node_list("FormField")
  CALL p_preview_node_list("Matrix")      # 2004/07/19 saki 屬性Matrix沒有加入
  CALL p_preview_node_list("Label")
  CALL p_preview_node_list("Button")
  CALL p_preview_node_list("TableColumn")
 
  SELECT COUNT(*) INTO l_gav_cnt FROM gav_file WHERE gav01=g_prog #CHI-990052
  IF g_upd_auto='Y' OR l_gav_cnt=0 THEN #CHI-990052
     # 2004/12/22 by saki BugNo.MOD-4C0124
     CALL p_preview_update_gav()
  END IF
 
  # 2004/07/09 應加上現行有幾個語言別的指示
  DECLARE p_preview_out_lang CURSOR FOR
     SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
 
# IF g_lang <> "1" THEN    #FUN-7C0042
     LET g_prog = "p_preview_form"
     Display 'Using ',g_lang,' TO Display ',gc_frm_name
     CALL cl_ui_locale(gc_frm_name)
# END IF
 
  # 2004/06/30 by saki : 刪除不在畫面中的欄位
  CALL p_preview_del_node()
 
   # MOD-4A0089
  IF g_cust_flag = "Y" THEN
     CALL p_preview_cust_insert()
  END IF
 
  IF g_auto_close_win ="Y" THEN
 
     MENU ""
      ON ACTION exit
         EXIT MENU
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON IDLE 180
         EXIT MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         EXIT MENU
 
     END MENU
  END IF
 
  CLOSE WINDOW w_curr
END MAIN
 
 
FUNCTION p_preview_error_msg()
 
     DISPLAY " "
     DISPLAY "Usage:r.gf form_name lang_flag cust_flag [upd_flag] [show_flag]"
     DISPLAY " "
     DISPLAY "Required: "
     DISPLAY " "
     DISPLAY "lang_flag   Defined Language Type    (Referance: p_lang ) "
     DISPLAY "cust_flag   P/p:Standard Package     C/c:Customerlized Form"
     DISPLAY " "
     DISPLAY " "
     DISPLAY "Optional: "
     DISPLAY " "
     DISPLAY "upd_flag    Y/y:Modify By 4fd File   N/n:Keep If Exists (default)"
     DISPLAY "open_form   Y/y:Keep Open (default)  N/n:Auto Close Window"
     DISPLAY " "
     DISPLAY "Ex. r.gf aooi010 0 p     -> Open Package Form to Preview"
     DISPLAY "    r.gf cooi010 0 c     -> Open Customerlized Form to Preview"
     DISPLAY "    r.gf aooi010 0 p y   -> Preview & Modify By 4fd "                           #No.FUN-710055
     DISPLAY "    r.gf aooi010 0 p y n -> No Preview Window, Modify By 4fd"                           #No.FUN-710055
     DISPLAY " "
 
     RETURN
 
END FUNCTION
 
 
# Descriptions...: 設定為自動關閉畫面.
# Date & Author..: 03/07/29 by Hiko
# Input Parameter: none
 
FUNCTION p_preview_close_win()
  LET g_auto_close_win = "N"
END FUNCTION
 
 
# Descriptions...: 準備要多語言轉換的元件節點.
# Date & Author..: 03/07/29 by Hiko
# Input Parameter: ps_tag_name STRING TAG名稱
 
FUNCTION p_preview_node_list(ps_tag_name)
  DEFINE ps_tag_name STRING
  DEFINE lnode_root om.DomNode,
         llst_items om.NodeList,
         li_i LIKE type_file.num5,    #FUN-680135 SMALLINT
         lnode_item om.DomNode,
         ls_item_name STRING
 
  LET lnode_root = ui.Interface.getRootNode()
  LET llst_items = lnode_root.selectByTagName(ps_tag_name)
 
  FOR li_i = 1 to llst_items.getLength()
      LET lnode_item = llst_items.item(li_i)
      LET ls_item_name = lnode_item.getAttribute("colName")
  
      IF (ls_item_name IS NULL) THEN
         LET ls_item_name = lnode_item.getAttribute("name")
  
         IF (ls_item_name IS NULL) THEN
            CONTINUE FOR
         END IF
      END IF
 
      CALL p_preview_update_by_name(lnode_item, ps_tag_name, ls_item_name)
  END FOR
END FUNCTION
 
# Descriptions...: 更新多語言的英文欄位說明.
# Date & Author..: 03/07/29 by Hiko
# Input Parameter: pnode_target om.DomNode 欲更新英文欄位說明之節點
#                  ps_tag_name STRING TAG名稱
#                  pc_field_name VARCHAR(20) 欄位名稱
# Modify.........: No.FUN-4B0041 04/11/16 By alex 重設多語言元件抓取資料
# Modify.........: No.FUN-520015 05/02/16 By alex 增加 FormField 中只有 Comments 抓取
 
FUNCTION p_preview_update_by_name(pnode_target, ps_tag_name, pc_field_name)
  DEFINE pnode_target om.DomNode,
         ps_tag_name STRING,
         pc_field_name LIKE gae_file.gae02
  DEFINE ls_field_name STRING
  DEFINE li_data_exist RECORD
            li_gav     LIKE type_file.num5,    #FUN-680135 SMALLINT
            ls_lang    STRING,
            li_lang1   LIKE type_file.num5     #FUN-680135 SMALLINT
                       END RECORD
  DEFINE lnode_pre,lnode_child om.DomNode,
         ls_pre_tag,ls_child_tag STRING
  DEFINE llst_items om.NodeList
  DEFINE lnode_item om.DomNode
  DEFINE li_i       LIKE type_file.num5    #FUN-680135 SMALLINT
  DEFINE ls_sql     STRING
  DEFINE lc_gay01   LIKE gay_file.gay01
 
  # FUN-4B0041 2004/11/16 於此函式中確定原來的資料是否已存在, 如果已存在, 等會
  #            在下面接續的函式就將以 UPDATE處理, 不存在者由 INSERT處理
   # MOD-4A0089 增加客製碼
 
  #No.FUN-710055 --mark-- 移動位置
# # 語言別 "1"為英文, 是出發的基底, 所有的資料以英文為出發點
# SELECT COUNT(*) INTO li_data_exist.li_lang1 FROM gae_file
#  WHERE gae01=gc_frm_name AND gae02=pc_field_name AND gae03='1' AND gae11 = g_cust_flag
 
# # gav_file為元件基本設定及權限資料, 一樣留一個特殊傳值欄位處理
# SELECT COUNT(*) INTO li_data_exist.li_gav FROM gav_file
#  WHERE gav01=gc_frm_name AND gav02=pc_field_name AND gav08 = g_cust_flag
 
# # 2004/11/16 FUN-4B0041
# #            語言別在 1.50.01 版起將採動態設定, 不一定為0123...也不一定只
# #            能設定十組, 於此改採動態抓取, 另, 下方沒傳 gc_frm_name, 勿搬
# LET ls_sql=" SELECT COUNT(*) FROM gae_file WHERE gae01=? AND gae02=? ",
#               " AND gae03=? AND gae11=? "
# PREPARE p_perview_ubn_pre1 FROM ls_sql
# LET ls_sql = " SELECT DISTINCT gay01 FROM gay_file ",
#               " ORDER BY gay01"
# PREPARE p_perview_ubn_pre2 FROM ls_sql
# DECLARE p_perview_ubn_cs CURSOR FOR p_perview_ubn_pre2
# LET li_i=0 LET li_data_exist.ls_lang=""
# FOREACH p_perview_ubn_cs INTO lc_gay01
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#       EXIT FOREACH
#    ELSE
#       EXECUTE p_perview_ubn_pre1
#         USING gc_frm_name,pc_field_name,lc_gay01,g_cust_flag
#          INTO li_i
#       LET li_data_exist.ls_lang=li_data_exist.ls_lang.trim(),lc_gay01 CLIPPED,"=",li_i,","
#    END IF
# END FOREACH
# LET li_data_exist.ls_lang=li_data_exist.ls_lang.trim()
# LET li_data_exist.ls_lang=li_data_exist.ls_lang.subString(1,(li_data_exist.ls_lang.getLength()-1))
# # FUN-4B0041 ENDING
  #No.FUN-710055 ---end---
 
  CASE
    WHEN ps_tag_name.equals("Label")
      LET ls_field_name = pc_field_name CLIPPED
      IF (ls_field_name.subString(1, 5) = "dummy") THEN
         CALL p_preview_update_to_db(li_data_exist.*,pnode_target,pnode_target,pc_field_name)
      END IF
 
    WHEN ps_tag_name.equals("FormField")
      LET lnode_child = pnode_target.getFirstChild()
      # 轉換欄位所對應的Label元件.
 
      LET ls_child_tag = lnode_child.getTagName()   #MOD-590390
      IF NOT ls_child_tag.equals("CheckBox") THEN
         LET lnode_pre = p_preview_get_change_text_node(pnode_target)
      END IF
  
      LET li_i = 0
      IF (lnode_pre IS NOT NULL)  THEN
         LET ls_pre_tag = lnode_pre.getTagName()
         IF ls_pre_tag.equals("Label") THEN
            CALL p_preview_update_to_db(li_data_exist.*,lnode_pre,lnode_child,pc_field_name)
            LET li_i = 1
         END IF
      END IF
  
      IF li_i = 0 THEN
         #No.FUN-710055 --mark---
#        # FUN-520015 檢查若該欄位有 COMMENTS 也要寫入 db  #借ls_field_name來用
#        LET ls_field_name = lnode_child.getAttribute("comment")
#        LET ls_field_name = ls_field_name.trim()
#        IF ls_field_name.getLength() > 0 THEN
#           CALL p_preview_update_to_db(li_data_exist.*,lnode_child,lnode_child,pc_field_name)
#        END IF
         #No.FUN-710055 --mark---
         #No.FUN-710055 --start--
         CALL p_preview_update_to_db(li_data_exist.*,lnode_child,lnode_child,pc_field_name)
         LET li_i = 1   #FUN-740186
         #No.FUN-710055 ---end---
      END IF
     
      # 轉換欄位所對應的一般元件.
      LET ls_child_tag = lnode_child.getTagName()
      IF (ls_child_tag.equals("ComboBox") OR
          ls_child_tag.equals("RadioGroup")) THEN
         LET llst_items = lnode_child.selectbyTagName("Item")
 
         FOR li_i = 1 TO llst_items.getLength()
             LET lnode_item = llst_items.item(li_i)
             CALL p_preview_update_by_name(lnode_item, "Item", pc_field_name CLIPPED || "_" || lnode_item.getAttribute("name"))
         END FOR
      ELSE
         IF (ls_child_tag.equals("CheckBox")) AND li_i = 0 THEN   #FUN-740186 add "AND li_i=0"HEN
            CALL p_preview_update_to_db(li_data_exist.*,lnode_child,lnode_child,pc_field_name)
         END IF
      END IF
 
    # 2004/07/19 by saki : 屬性Matrix沒有加入
    WHEN ps_tag_name.equals("Matrix")
      #No.FUN-630089 --start--  #No.FUN-840199 --unmark start--
      # 轉換欄位所對應的Label元件.
#     LET lnode_pre = p_preview_get_change_text_node(pnode_target)
# 
#     IF (lnode_pre IS NOT NULL) THEN
#        LET ls_pre_tag = lnode_pre.getTagName()
# 
#        IF (ls_pre_tag.equals("Label")) THEN
#           CALL p_preview_update_to_db(li_data_exist.*,lnode_pre,pnode_target,pc_field_name)
#        END IF
#     END IF
      #No.FUN-630089 ---end---  #No.FUN-840199 ---unmark end---
  
      # 轉換欄位所對應的一般元件.
      LET lnode_child = pnode_target.getFirstChild()
      LET ls_child_tag = lnode_child.getTagName()
      IF (ls_child_tag.equals("ComboBox") OR
          ls_child_tag.equals("RadioGroup")) THEN
         LET llst_items = lnode_child.selectbyTagName("Item")
 
         FOR li_i = 1 TO llst_items.getLength()
             LET lnode_item = llst_items.item(li_i)
             CALL p_preview_update_by_name(lnode_item,"Item",pc_field_name CLIPPED || "_" || lnode_item.getAttribute("name"))
         END FOR
      ELSE
#        IF (ls_child_tag.equals("CheckBox")) THEN   #No.FUN-630089
            CALL p_preview_update_to_db(li_data_exist.*,lnode_child,lnode_child,pc_field_name)
#        END IF                                      #No.FUN-630089
      END IF
 
    WHEN ps_tag_name.equals("Page") OR
         ps_tag_name.equals("Group") OR
#        ps_tag_name.equals("CheckBox") OR
         ps_tag_name.equals("Button")
      CALL p_preview_update_to_db(li_data_exist.*,pnode_target,pnode_target,pc_field_name)
 
    WHEN ps_tag_name.equals("Item")
      #No.FUN-710055 --start--
#     LET li_data_exist.li_gav = 100 #不願意將Item新增到gav
      LET g_item_flag = TRUE
      #No.FUN-710055 ---end---
      CALL p_preview_update_to_db(li_data_exist.*,pnode_target,pnode_target,pc_field_name)
      LET g_item_flag = FALSE    #No.FUN-710055
 
    WHEN ps_tag_name.equals("TableColumn")
       LET lnode_child = pnode_target.getFirstChild()          # MOD-510182
      CALL p_preview_update_to_db(li_data_exist.*,pnode_target,lnode_child,pc_field_name)
 
      LET ls_child_tag = lnode_child.getTagName()
 
      IF (ls_child_tag.equals("ComboBox") OR
          ls_child_tag.equals("RadioGroup")) THEN              #TQC-5A0068
         LET llst_items = lnode_child.selectbyTagName("Item")
 
         FOR li_i = 1 TO llst_items.getLength()
             LET lnode_item = llst_items.item(li_i)
             CALL p_preview_update_by_name(lnode_item,"Item",pc_field_name CLIPPED || "_" || lnode_item.getAttribute("name"))
         END FOR
      END IF
  END CASE
END FUNCTION
 
FUNCTION p_preview_get_change_text_node(pnode_target)
   DEFINE   pnode_target   om.DomNode
   DEFINE   lnode_pre       om.DomNode,
            ls_pre_tag      STRING,
            ls_pre_text     STRING,
            li_bind_label   LIKE type_file.num5    #FUN-680135 SMALLINT
 
 
   LET lnode_pre = pnode_target.getPrevious()
 
   IF (lnode_pre IS NOT NULL) THEN
      LET ls_pre_tag = lnode_pre.getTagName()
      # 欄位所對應的Label元件.
      IF (ls_pre_tag.equals("Label") AND
          cl_null(lnode_pre.getAttribute("name"))) THEN
          LET ls_pre_text = lnode_pre.getAttribute("text")
          LET ls_pre_text = ls_pre_text.trim()
 
           IF (ls_pre_text.getLength() = 0) THEN             # MOD-4C0175
             CALL p_preview_get_change_text_node(lnode_pre) RETURNING lnode_pre
          END IF
      END IF
   END IF
 
   RETURN lnode_pre
END FUNCTION
 
# Descriptions...: 更新多語言的英文欄位說明至資料庫.
# Date & Author..: 03/07/29 by Hiko
# Input Parameter: pnode_target  om.DomNode 欲更新欄位英文text lebel之節點
#                  pnode_comment om.DomNode 欲更新欄位英文comment之節點
#                  pc_field_name VARCHAR(20)   欄位名稱
# Modify.........: No.FUN-4B0041 04/11/16 alex 新增依照語言別選項併同gaq_file資料
#                            放入 gae_file, 傳入comment節點
# Modify.........: No.FUN-520015 05/02/16 alex 新增抓取只有 comments 的資料
 
FUNCTION p_preview_update_to_db(pi_data_exist,pnode_target,pnode_comment,pc_field_name)
 
  DEFINE pi_data_exist  RECORD
              li_gav     LIKE type_file.num5,    #FUN-680135 SMALLINT
              ls_lang    STRING,
              li_lang1   LIKE type_file.num5     #FUN-680135 SMALLINT
                     END RECORD,
         pnode_target    om.DomNode,
         pnode_comment   om.DomNode,
         pc_field_name   LIKE type_file.chr20    #FUN-680135 VARCHAR(20)
  DEFINE ls_desc         STRING 
  DEFINE ls_comment      STRING
  DEFINE lc_desc         LIKE gae_file.gae04
  DEFINE lc_comment      LIKE gbs_file.gbs06     #FUN-7B0081 gae_file.gae05
  DEFINE lc_gbd03        LIKE gbd_file.gbd03
  DEFINE lst_count       base.StringTokenizer
  DEFINE ls_count        STRING
  DEFINE lc_gay01        LIKE gay_file.gay01
  DEFINE lc_gaq03        LIKE gaq_file.gaq03
  DEFINE li_count        LIKE type_file.chr20    #FUN-680135 VARCHAR(20)
  DEFINE lc_ze03         LIKE ze_file.ze03       #No.FUN-520002
  DEFINE li_chk          LIKE type_file.num5     #FUN-680135 SMALLINT  #FUN-550115
  DEFINE lc_chk          LIKE type_file.chr1     #FUN-680135 VARCHAR(1)   #FUN-550115
  DEFINE lr_gae          RECORD LIKE gae_file.*  #FUN-550115
  DEFINE li_cnt          LIKE type_file.chr1     #FUN-680135 VARCHAR(1)   #FUN-610065
  #No.FUN-710055 --start--
  DEFINE li_i            LIKE type_file.num5
  DEFINE lnode_parent    om.DomNode
  DEFINE lnode_item      om.DomNode
  DEFINE lc_enable       LIKE gav_file.gav03
  DEFINE lc_entry        LIKE gav_file.gav04
  DEFINE li_width        LIKE gav_file.gav12
  DEFINE lc_pagename     LIKE gav_file.gav13
  DEFINE li_posX         LIKE gav_file.gav14
  DEFINE li_posY         LIKE gav_file.gav15
  DEFINE li_tabIndex     LIKE gav_file.gav16
  DEFINE lc_default      LIKE gav_file.gav17
  DEFINE lc_include      LIKE gav_file.gav18
  DEFINE li_posX_label   LIKE gav_file.gav34
  DEFINE li_label_flag   LIKE type_file.num5
  DEFINE ls_sql          STRING
  #No.FUN-710055 ---end---
  DEFINE lc_gaq06        LIKE gaq_file.gaq06    #欄位用途
  DEFINE ls_industry     STRING                 #No.FUN-950073
  DEFINE li_j            LIKE type_file.num5    #No.FUN-950073
  DEFINE ls_match        STRING                 #No.FUN-950073
  #No:TQC-9C0176 --start--
  DEFINE ls_notnull      STRING
  DEFINE ls_required     STRING
  DEFINE lc_required     LIKE gav_file.gav10
  #No:TQC-9C0176 ---end---
 
  LET ls_desc = pnode_target.getAttribute("text")
  LET ls_comment = pnode_comment.getAttribute("comment")
 
  #No.FUN-710055 --start--
  #ID相等,表示傳進來的節點為Label(個別),CheckBox元件,Page,Group,Button,Item,RadioGroup
  IF pnode_target.getId() = pnode_comment.getId() THEN
     IF pnode_target.getTagName() = "Label" OR pnode_target.getTagName() = "Button" THEN
        LET li_width  = pnode_target.getAttribute("width")
        LET li_posX   = pnode_target.getAttribute("posX")
        LET li_posY   = pnode_target.getAttribute("posY")
        LET lc_enable = pnode_target.getAttribute("hidden")
        LET lc_entry  = pnode_target.getAttribute("noEntry")
     END IF
     IF pnode_target.getTagName() = "CheckBox" THEN
        LET li_width = pnode_target.getAttribute("width")
        LET li_posX  = pnode_target.getAttribute("posX")
        LET li_posY  = pnode_target.getAttribute("posY")
        LET lnode_item = pnode_target.getParent()
        IF lnode_item IS NOT NULL THEN
           IF lnode_item.getTagname() = "FormField" OR lnode_item.getTagName() = "TableColumn" THEN
              LET li_tabIndex = lnode_item.getAttribute("tabIndex")
              IF li_tabIndex > g_tabIndex_max THEN
                 LET g_tabIndex_max = li_tabIndex
              END IF
              LET lc_default = lnode_item.getAttribute("defaultValue")
              LET lc_include = lnode_item.getAttribute("include")
              LET lc_enable  = lnode_item.getAttribute("hidden")
              LET lc_entry   = lnode_item.getAttribute("noEntry")
           END IF
        END IF
     END IF
     #No.FUN-950073 --start-- 也有可能是沒有Label的FormField
     LET lnode_parent = pnode_comment.getParent()
     IF lnode_parent.getTagName() = "FormField" THEN
        LET li_width  = pnode_comment.getAttribute("width")
        LET li_posX   = pnode_comment.getAttribute("posX")
        LET li_posY   = pnode_comment.getAttribute("posY")
        LET lc_enable = lnode_parent.getAttribute("hidden")
        LET lc_entry  = lnode_parent.getAttribute("noEntry")
     END IF
     #No.FUN-950073 ---end---
     #No:TQC-9C0176 --start--
     LET ls_notnull = lnode_parent.getAttribute("notNull")
     LET ls_required = lnode_parent.getAttribute("required")
     IF ((ls_notnull IS NOT NULL) AND (ls_notnull = "1")) OR 
        ((ls_required IS NOT NULL) AND (ls_required = "1")) THEN
        LET lc_required = "Y"
     ELSE
        LET lc_required = "N"
     END IF
     #No:TQC-9C0176 ---end---
  #ID不相等,表示為FormField或TableColumn
  ELSE
     LET li_label_flag = FALSE
     IF pnode_target.getTagName() = "Label" THEN
        LET lnode_item = pnode_target.getNext()
        LET li_label_flag = TRUE
     ELSE
        LET lnode_item = pnode_target
     END IF
     IF lnode_item IS NOT NULL THEN
        LET li_width = pnode_comment.getAttribute("width")
        IF lnode_item.getTagName() = "FormField" THEN
           LET li_posX  = pnode_comment.getAttribute("posX")
           LET li_posY  = pnode_comment.getAttribute("posY")
           IF li_label_flag THEN
              LET li_posX_label = pnode_target.getAttribute("posX")
           END IF
        END IF
        LET li_tabIndex = lnode_item.getAttribute("tabIndex")
        IF li_tabIndex > g_tabIndex_max THEN
           LET g_tabIndex_max = li_tabIndex
        END IF
        LET lc_default = lnode_item.getAttribute("defaultValue")
        LET lc_include = lnode_item.getAttribute("include")
        LET lc_enable  = lnode_item.getAttribute("hidden")
        LET lc_entry   = lnode_item.getAttribute("noEntry")
        #No:TQC-9C0176 --start--
        LET ls_notnull = lnode_item.getAttribute("notNull")
        LET ls_required = lnode_item.getAttribute("required")
        IF ((ls_notnull IS NOT NULL) AND (ls_notnull = "1")) OR 
           ((ls_required IS NOT NULL) AND (ls_required = "1")) THEN
           LET lc_required = "Y"
        ELSE
           LET lc_required = "N"
        END IF
        #No:TQC-9C0176 ---end---
     END IF
  END IF
  IF pnode_target.getTagName() != "Page" AND pnode_target.getTagName() != "Group" AND
     pnode_target.getTagName() != "TableColumn" THEN
     LET lc_pagename = NULL
     LET lnode_parent = pnode_target.getParent()
     WHILE lnode_parent IS NOT NULL
        IF lnode_parent.getTagName() = "Page" OR lnode_parent.getTagName() = "Group" THEN
           LET lc_pagename = lnode_parent.getAttribute("name")
           EXIT WHILE
        ELSE
           LET lnode_parent = lnode_parent.getParent()
        END IF
     END WHILE
  END IF
  #No.FUN-710055 ---end---
 
  # 2004/03/06 調整多語言架構, 只修正/新增英文資料  FUN-520015 更新 comment
  IF (NOT ls_desc.equals("") OR NOT ls_comment.equals("")) THEN
     # 2004/06/30 by saki : 將目前畫面上的欄位存到array準備和gae_file,gav_file比對
     LET g_form[g_cnt].field_name = pc_field_name
     LET g_cnt = g_cnt + 1
 
     LET lc_desc = ls_desc.trim()
     LET lc_comment = ls_comment.trim()
 
 
     #No.FUN-710055 --start--
     FOR li_i = 1 TO g_gav11.getLength()
         # 語言別 "1"為英文, 是出發的基底, 所有的資料以英文為出發點
         SELECT COUNT(*) INTO pi_data_exist.li_lang1 FROM gae_file
          WHERE gae01=gc_frm_name AND gae02=pc_field_name AND gae03='1'
            AND gae11 = g_cust_flag AND gae12 = g_gav11[li_i]
 
         LET ls_sql=" SELECT COUNT(*) FROM gae_file WHERE gae01=? AND gae02=? ",
                       " AND gae03=? AND gae11=? AND gae12=?"
         PREPARE p_perview_ubn_pre1 FROM ls_sql
         LET ls_sql = " SELECT DISTINCT gay01 FROM gay_file ",
                       " ORDER BY gay01"
         PREPARE p_perview_ubn_pre2 FROM ls_sql
         DECLARE p_perview_ubn_cs CURSOR FOR p_perview_ubn_pre2
         LET li_cnt=0 LET pi_data_exist.ls_lang=""
         FOREACH p_perview_ubn_cs INTO lc_gay01
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
               EXIT FOREACH
            ELSE
               EXECUTE p_perview_ubn_pre1
                 USING gc_frm_name,pc_field_name,lc_gay01,g_cust_flag,g_gav11[li_i]
                  INTO li_cnt
               LET pi_data_exist.ls_lang=pi_data_exist.ls_lang.trim(),lc_gay01 CLIPPED,"=",li_cnt,","
            END IF
         END FOREACH
         LET pi_data_exist.ls_lang=pi_data_exist.ls_lang.trim()
         LET pi_data_exist.ls_lang=pi_data_exist.ls_lang.subString(1,(pi_data_exist.ls_lang.getLength()-1))
 
         # 2004/03/06 多語言分別判定, li_lang1 英文,現行per為英文,以此為準
          # MOD-4A0089 insert,update 客製碼加入
         IF (pi_data_exist.li_lang1) THEN
            IF g_upd_auto = "Y" THEN #FUN-7C0042
               UPDATE gae_file                                      #FUN-590075
                  SET gae04=lc_desc,gae10=TODAY  #gae05=lc_comment, #FUN-7B0081
                WHERE gae01=gc_frm_name AND gae02=pc_field_name
                  AND gae03='1' AND gae11 = g_cust_flag AND gae12 = g_gav11[li_i]
               IF NOT cl_null(lc_comment) THEN
                  CALL p_preview_gbs06(6,lc_comment,NULL,
                                       gc_frm_name,pc_field_name,'1',g_cust_flag,g_gav11[li_i])
               END IF
            END IF
 
# 2004/08/10 saki
#           UPDATE gae_file SET gae04=lc_desc, gae10=TODAY
#            WHERE gae01=gc_frm_name AND gae02=pc_field_name
#              AND gae03='1' AND gae11 = g_cust_flag
 
         ELSE
            IF NOT cl_null(pc_field_name) THEN
               #No.FUN-520002 --start--
#              IF (pc_field_name != "userdefined_field") THEN   #No.FUN-610065
                  IF NOT g_syskeep THEN
                     INSERT INTO gae_file
                              (gae01,gae02,gae03,gae04,    #gae05, #FUN-7B0081
                               gae07,gae08,gae10,gae11,gae12)   #No.FUN-710055
                        VALUES(gc_frm_name,pc_field_name,"1",lc_desc,#lc_comment,
                               "N","N",TODAY,g_cust_flag,g_gav11[li_i])  #No.FUN-710055
                     IF NOT cl_null(lc_comment) THEN
                        CALL p_preview_gbs06(6,lc_comment,NULL,
                                       gc_frm_name,pc_field_name,'1',g_cust_flag,g_gav11[li_i])
                     END IF
                  END IF
#              END IF                                           #No.FUN-610065
               #No.FUN-520002 ---end---
            ELSE
               CALL cl_err('Field Name NULL','!',1)
               RETURN   #都已經錯了, 後面的就不做了
            END IF                            
         END IF
 
#        2004/11/16 FUN-4B0041 分析上個函式傳入的個數值, 挑去英文部份, 若已有
#                   資料存在則不予處理, 若沒有資料存在, 則抓取 gaq_file中欄位
#                   ID相符的同語言欄位說明置入, 若欄位說明不存在則插入一空值
 
         LET lst_count=base.StringTokenizer.create(pi_data_exist.ls_lang.trim(), ",")
         WHILE lst_count.hasMoreTokens()
            LET ls_count = lst_count.nextToken()
            LET ls_count = ls_count.trim()
            LET lc_gay01 = ls_count.subString(1,(ls_count.getIndexOf("=",1)-1))
            LET li_count = ls_count.subString((ls_count.getIndexOf("=",1)+1),ls_count.getLength())
 
            #No.FUN-520002 --start--
            IF lc_gay01 <> "1" AND li_count = 0 THEN
               IF (pc_field_name = "userdefined_field") THEN
                  LET lc_ze03 = ""
                  SELECT ze03 INTO lc_ze03 FROM ze_file WHERE ze01 = "azz-723" AND ze02 = lc_gay01
                  INSERT INTO gae_file (gae01,gae02,gae03,gae04,
                                        gae07,gae08,gae10,gae11,gae12)  #No.FUN-710055
                  VALUES(gc_frm_name,pc_field_name,lc_gay01,lc_ze03,
                         "N","N",TODAY,g_cust_flag,g_gav11[li_i])                #No.FUN-710055
               ELSE
                  LET lc_gaq03 = ""
#                 #FUN-550115 若存在客製資料,則以客製為優先抓取目標
                  LET lc_chk = "N"
                  IF g_cust_flag = "Y" THEN
                     SELECT count(*) INTO li_chk FROM gae_file
                      WHERE gae01=gc_frm_name AND gae02=pc_field_name
                        AND gae03=lc_gay01    AND gae11="N"
                     IF li_chk = 1 THEN
                        SELECT * INTO lr_gae.* FROM gae_file
                         WHERE gae01=gc_frm_name AND gae02=pc_field_name
                           AND gae03=lc_gay01    AND gae11="N"
                        #FUN-7B0081
                        SELECT gbs06,gbs07 INTO lr_gae.gae05,lr_gae.gae06
                          FROM gbs_file
                         WHERE gbs01=gc_frm_name AND gbs02=pc_field_name
                           AND gbs03=lc_gay01    AND gbs04="N"
                           AND gbs05=g_gav11[li_i]
                        LET lc_chk = "Y"
                     END IF
                  END IF
                  IF lc_chk = "N" THEN
                     SELECT gaq03 INTO lc_gaq03 FROM gaq_file
                      WHERE gaq01=pc_field_name AND gaq02=lc_gay01
                     INITIALIZE lr_gae.* TO NULL
                     LET lr_gae.gae04 = lc_gaq03
                  END IF
                                            #FUN-550115            #FUN-7B0081
                  INSERT INTO gae_file (gae01,gae02,gae03,gae04,   #gae05,gae06,
                                        gae07,gae08,gae10,gae11,gae12)  #No.FUN-710055
                  VALUES(gc_frm_name,pc_field_name,lc_gay01,       #lc_gaq03,
                         lr_gae.gae04,
                        #lr_gae.gae05,lr_gae.gae06,   #FUN-550115  #FUN-7B0081
                         "N","N",TODAY,g_cust_flag,g_gav11[li_i])
                  IF NOT cl_null(lr_gae.gae05) OR NOT cl_null(lr_gae.gae06) THEN
                     CALL p_preview_gbs06(0,lr_gae.gae05,lr_gae.gae06,
                                          gc_frm_name,pc_field_name,lc_gay01,
                                          g_cust_flag,g_gav11[li_i])
                  END IF
               END IF
            END IF
            #No.FUN-520002 ---end---
         END WHILE
 
#        IF NOT (pi_data_exist.li_lang0) AND NOT cl_null(pc_field_name) THEN
#           INSERT INTO gae_file
#                      (gae01,gae02,gae03,gae07,gae08,gae10,gae11,gae12)   #No.FUN-710055
#                VALUES(gc_frm_name,pc_field_name,"0","N","N",TODAY,g_cust_flag,g_gav11[li_i])  #No.FUN-710055
#        END IF
     END FOR
     #No.FUN-710055 ---end---
 
     IF cl_null(lc_enable) OR lc_enable != "1" THEN
        LET lc_enable = "Y"
     ELSE
        LET lc_enable = "N"
     END IF
 
     #No.FUN-790045 --start--
     SELECT gaq06 INTO lc_gaq06 FROM gaq_file WHERE gaq01=pc_field_name AND gaq02='0'
     IF NOT cl_null(lc_gaq06) AND lc_gaq06 = "3" THEN
        LET lc_enable = "N"
     END IF
     #No.FUN-790045 ---end---
 
     IF cl_null(lc_entry) OR lc_entry != "1" THEN
        LET lc_entry = "Y"
     ELSE
        LET lc_entry = "N"
     END IF
     # 2004/03/06 拆table的gav, li_gav拒讓 item 類進入
     #No.FUN-710055 --start--
     FOR li_i = 1 TO g_gav11.getLength()
         # gav_file為元件基本設定及權限資料, 一樣留一個特殊傳值欄位處理
         SELECT COUNT(*) INTO pi_data_exist.li_gav FROM gav_file
          WHERE gav01=gc_frm_name AND gav02=pc_field_name AND gav08 = g_cust_flag AND gav11 = g_gav11[li_i]
 
         IF NOT (pi_data_exist.li_gav) AND NOT g_item_flag AND
            NOT cl_null(pc_field_name) THEN
            #No.FUN-520002 --start--
            IF (pc_field_name MATCHES "???ud[01][0-9]") OR (pc_field_name MATCHES "????ud[01][0-9]") THEN
               #No.FUN-840011 --start--
               LET lc_enable = "Y"
               LET lc_entry = "N"
               #No.FUN-840011 ---end---
               IF g_gav11[li_i] = g_std_id THEN
                  INSERT INTO gav_file
                             (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                       VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,li_tabIndex,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N-> lc_required
               ELSE
                  INSERT INTO gav_file
                             (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                       VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,g_tabIndex_max+1,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N->lc_required
               END IF
               #No.FUN-610065 --start--
               SELECT COUNT(*) INTO li_cnt FROM gbr_file
                WHERE gbr01=gc_frm_name AND gbr02=pc_field_name AND gbr03=g_cust_flag
               IF li_cnt <= 0 THEN
                  INSERT INTO gbr_file
                             (gbr01,gbr02,gbr03,gbr04,gbr05,gbr06,gbr07,gbr08)
                       VALUES(gc_frm_name,pc_field_name,g_cust_flag,"","N","","","")
               END IF
               #No.FUN-610065 ---end---
            ELSE
               IF g_gav11[li_i] = g_std_id THEN
                  #No.FUN-950073 --start--
                  FOR li_j = 1 TO g_smb01.getLength()
                      IF g_smb01[li_j] = g_std_id THEN
                         CONTINUE FOR
                      END IF
                      LET ls_match = "*i",g_smb01[li_j] CLIPPED,"*"
                      IF pc_field_name MATCHES ls_match THEN
                         LET lc_enable = "N"
                      END IF
                  END FOR
                  #No.FUN-950073 ---end---
                  INSERT INTO gav_file
                             (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                       VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,li_tabIndex,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N->lc_required
               ELSE
                  #No.FUN-950073 --start--
                  FOR li_j = 1 TO g_smb01.getLength()
                      IF g_smb01[li_j] = g_std_id THEN
                         CONTINUE FOR
                      END IF
                      LET ls_match = "*i",g_smb01[li_j] CLIPPED,"*"
                      IF pc_field_name MATCHES ls_match THEN
                         IF g_smb01[li_j] = g_gav11[li_i] THEN
                            LET lc_enable = "Y"
                         ELSE
                            LET lc_enable = "N"
                         END IF
                      END IF
                  END FOR
                  #No.FUN-950073 ---end---
                  INSERT INTO gav_file
                             (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                       VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,g_tabIndex_max+1,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N->lc_required
               END IF
            END IF
            #No.FUN-520002 ---end---
         #No.FUN-610065 --start-- 補gbr_file沒有已經增加的自訂欄位
         ELSE
            IF (pc_field_name MATCHES "???ud[01][0-9]") OR (pc_field_name MATCHES "????ud[01][0-9]") THEN
               SELECT COUNT(*) INTO li_cnt FROM gbr_file
                WHERE gbr01=gc_frm_name AND gbr02=pc_field_name AND gbr03=g_cust_flag
               IF li_cnt <= 0 THEN
                  INSERT INTO gbr_file
                             (gbr01,gbr02,gbr03,gbr04,gbr05,gbr06,gbr07,gbr08)
                       VALUES(gc_frm_name,pc_field_name,g_cust_flag,"","N","","","")
               END IF
            END IF
         #No.FUN-610065 ---end---
         END IF                                                 # MOD-4C0124
     END FOR
     #No.FUN-710055 ---end---
  #No.FUN-630089 --start--
  ELSE
     #No.FUN-790045 --start--
     SELECT gaq06 INTO lc_gaq06 FROM gaq_file WHERE gaq01=pc_field_name AND gaq02='0'
     IF NOT cl_null(lc_gaq06) AND lc_gaq06 = "3" THEN
        LET lc_enable = "N"
     END IF
     #No.FUN-790045 ---end---
 
     #No.FUN-950073 --start--
     IF cl_null(lc_enable) OR lc_enable != "1" THEN
        LET lc_enable = "Y"
     ELSE
        LET lc_enable = "N"
     END IF
     IF cl_null(lc_entry) OR lc_entry != "1" THEN
        LET lc_entry = "Y"
     ELSE
        LET lc_entry = "N"
     END IF
     #No.FUN-950073 ---end---
 
     #No.FUN-710055 --start--
     FOR li_i = 1 TO g_gav11.getLength()
         LET g_form[g_cnt].field_name = pc_field_name
         LET g_cnt = g_cnt + 1
         IF NOT (pi_data_exist.li_gav) AND NOT g_item_flag AND 
            NOT cl_null(pc_field_name) THEN
            IF g_gav11[li_i] = g_std_id THEN
               #No.FUN-950073 --start--
               FOR li_j = 1 TO g_smb01.getLength()
                   IF g_smb01[li_j] = g_std_id THEN
                      CONTINUE FOR
                   END IF
                   LET ls_match = "*i",g_smb01[li_j] CLIPPED,"*"
                   IF pc_field_name MATCHES ls_match THEN
                      LET lc_enable = "N"
                   END IF
               END FOR
               #No.FUN-950073 ---end---
               INSERT INTO gav_file
                          (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                    VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,li_tabIndex,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N->lc_required
            ELSE
               #No.FUN-950073 --start--
               FOR li_j = 1 TO g_smb01.getLength()
                   IF g_smb01[li_j] = g_std_id THEN
                      CONTINUE FOR
                   END IF
                   LET ls_match = "*i",g_smb01[li_j] CLIPPED,"*"
                   IF pc_field_name MATCHES ls_match THEN
                      IF g_smb01[li_j] = g_gav11[li_i] THEN
                         LET lc_enable = "Y"
                      ELSE
                         LET lc_enable = "N"
                      END IF
                   END IF
               END FOR
               #No.FUN-950073 ---end---
               INSERT INTO gav_file
                          (gav01,gav02,gav07,gav03,gav04,gav08,gav09,gav10,gav11,gav12,gav13,gav14,gav15,gav16,gav17,gav24,gav28,gav29,gav30,gav33,gav34,gav36,gav38)
                    VALUES(gc_frm_name,pc_field_name,"N",lc_enable,lc_entry,g_cust_flag,"N",lc_required,g_gav11[li_i],li_width,lc_pagename,li_posX,li_posY+1,g_tabIndex_max+1,lc_default,"N","1","1","1","N",li_posX_label,"N","0")   #No:TQC-9C0176 N->lc_required
            END IF
         END IF
     END FOR
     #No.FUN-710055 ---end---
  #No.FUN-630089 ---end---
  END IF
END FUNCTION
 
# Descriptions...: 更新必要欄位資訊到gav_file
# Date & Author..: 04/12/22 by saki
 
FUNCTION p_preview_update_gav()
   DEFINE lnode_root    om.DomNode,
          llst_items    om.NodeList,
          li_i          LIKE type_file.num5,    #FUN-680135 SMALLINT
          li_j          LIKE type_file.num5,    #FUN-680135 SMALLINT
          lnode_item    om.DomNode,
          ls_item_name  STRING
   DEFINE ls_tag_name   DYNAMIC ARRAY OF STRING
   DEFINE ls_notnull    STRING
   DEFINE ls_required   STRING
   DEFINE ls_gav02      LIKE gav_file.gav02
   #No.FUN-710055 --start--
   DEFINE lnode_child   om.DomNode
   DEFINE lnode_parent  om.DomNode
   DEFINE lnode_pre     om.DomNode
   DEFINE li_width      LIKE gav_file.gav12
   DEFINE lc_pagename   LIKE gav_file.gav13
   DEFINE li_posX       LIKE gav_file.gav14
   DEFINE li_posY       LIKE gav_file.gav15
   DEFINE li_tabIndex   LIKE gav_file.gav16
   DEFINE lc_default    LIKE gav_file.gav17
   DEFINE lc_include    LIKE gav_file.gav18
   DEFINE li_posX_label LIKE gav_file.gav34
   #No.FUN-710055 ---end---
 
 
   LET ls_tag_name[1] = "FormField"
   LET ls_tag_name[2] = "TableColumn"
   LET ls_tag_name[3] = "Page"
   LET ls_tag_name[4] = "Group"
   LET ls_tag_name[5] = "Matrix"
   LET ls_tag_name[6] = "Label"
   LET ls_tag_name[7] = "Button"
 
   FOR li_j = 1 TO ls_tag_name.getLength()
       LET lnode_root = ui.Interface.getRootNode()
       LET llst_items = lnode_root.selectByTagName(ls_tag_name[li_j])
 
       FOR li_i = 1 to llst_items.getLength()
           LET lnode_item = llst_items.item(li_i)
           LET ls_item_name = lnode_item.getAttribute("colName")
       
           IF (ls_item_name IS NULL) THEN
              LET ls_item_name = lnode_item.getAttribute("name")
       
              IF (ls_item_name IS NULL) THEN
                 CONTINUE FOR
              END IF
           END IF
 
           #No.FUN-710055 --start--
           LET li_width      = NULL
           LET lc_pagename   = NULL
           LET li_posX       = NULL
           LET li_posY       = NULL
           LET li_tabIndex   = NULL
           LET lc_default    = NULL
           LET lc_include    = NULL
           LET li_posX_label = NULL
 
           LET ls_notnull = lnode_item.getAttribute("notNull")
           LET ls_required = lnode_item.getAttribute("required")
           LET ls_gav02 = ls_item_name
           IF ((ls_notnull IS NOT NULL) AND (ls_notnull = "1")) OR 
              ((ls_required IS NOT NULL) AND (ls_required = "1")) THEN
              UPDATE gav_file SET gav10 = "Y" 
               WHERE gav01 = gc_frm_name AND gav02 = ls_gav02 AND gav08 = g_cust_flag
              IF SQLCA.sqlcode THEN
                 DISPLAY 'update error : ',ls_gav02
              END IF
           ELSE
              UPDATE gav_file SET gav10 = "N" 
               WHERE gav01 = gc_frm_name AND gav02 = ls_gav02 AND gav08 = g_cust_flag
              IF SQLCA.sqlcode THEN
                 DISPLAY 'update error : ',ls_gav02
              END IF
           END IF
 
           #No.FUN-710055 --start--
           CASE
              WHEN li_j = 1 OR li_j = 2
                 LET li_tabIndex = lnode_item.getAttribute("tabIndex")
                 LET lc_default  = lnode_item.getAttribute("defaultValue")
                 LET lc_include  = lnode_item.getAttribute("include")
                 LET lnode_pre = lnode_item.getPrevious()
                 IF lnode_pre IS NOT NULL THEN
                    IF lnode_pre.getTagName() = "Label" THEN
                       LET li_posX_label = lnode_pre.getAttribute("posX")
                    END IF
                 END IF
                 LET lnode_child = lnode_item.getFirstChild()
                 IF lnode_child IS NOT NULL THEN
                    LET li_width = lnode_child.getAttribute("gridWidth") #TQC-AC0025
                    IF li_width IS NULL THEN
                       LET li_width = lnode_child.getAttribute("width")
                    END IF
                    LET li_posX  = lnode_child.getAttribute("posX")
                    LET li_posY  = lnode_child.getAttribute("posY")
                 END IF
              WHEN li_j = 6
                 LET ls_item_name = lnode_item.getAttribute("name")
                 IF (ls_item_name IS NOT NULL AND
                     ls_item_name.subString(1, 5) = "dummy") THEN
                    LET li_width = lnode_child.getAttribute("gridWidth") #TQC-AC0025
                    IF li_width IS NULL THEN
                       LET li_width = lnode_item.getAttribute("width")
                    END IF
                    LET li_posX  = lnode_item.getAttribute("posX")
                    LET li_posY  = lnode_item.getAttribute("posY")
                 END IF
              WHEN li_j = 7
                 LET li_width = lnode_child.getAttribute("gridWidth") #TQC-AC0025
                 IF li_width IS NULL THEN
                    LET li_width = lnode_item.getAttribute("width")
                 END IF
                 LET li_posX  = lnode_item.getAttribute("posX")
                 LET li_posY  = lnode_item.getAttribute("posY")
           END CASE
           IF li_j = 1 OR li_j = 2 OR li_j = 6 OR li_j = 7 THEN
              LET lc_pagename = NULL
              LET lnode_parent = lnode_item.getParent()
              WHILE lnode_parent IS NOT NULL
                 IF lnode_parent.getTagName() = "Page" OR lnode_parent.getTagName() = "Group" THEN
                    LET lc_pagename = lnode_parent.getAttribute("name")
                    EXIT WHILE
                 ELSE
                    LET lnode_parent = lnode_parent.getParent()
                 END IF
              END WHILE
 
              UPDATE gav_file SET gav12 = li_width,    gav13 = lc_pagename,
                                  gav14 = li_posX,     gav15 = li_posY+1 ,
                                  gav16 = li_tabIndex, gav17 = lc_default,
                                  gav18 = lc_include,  gav34 = li_posX_label
               WHERE gav01 = gc_frm_name AND gav02 = ls_gav02 AND gav08 = g_cust_flag   #AND gav11 = g_std_id  #No.TQC-9C0063 modify condition
           END IF
           #No.FUN-710055 ---end---
       END FOR
  END FOR
END FUNCTION
 
# Descriptions...: 刪除目前預覽畫面上沒有的欄位
# Date & Author..: 04/06/30 by saki
 
FUNCTION p_preview_del_node()
   DEFINE   ls_gae02       LIKE gae_file.gae02
   DEFINE   ls_gav02       LIKE gav_file.gav02
   DEFINE   ls_sql         STRING
   DEFINE   ls_sql2        STRING
   DEFINE   li_i           LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   li_del_flag    LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   lc_cust        LIKE gae_file.gae11
 
 
   # 2004/08/11 by saki : 客製與非客製需分開查看
   LET ls_sql = "SELECT UNIQUE gae02 FROM gae_file ",
                " WHERE gae01 = '",gc_frm_name,"' AND gae11 = '",g_cust_flag,"'"
   PREPARE gae_prepare FROM ls_sql
   DECLARE gae_curs CURSOR FOR gae_prepare
 
   LET ls_sql2 = "SELECT UNIQUE gav02 FROM gav_file ",  #No.FUN-710055
                 " WHERE gav01 = '",gc_frm_name,"' AND gav08 = '",g_cust_flag,"'"
   PREPARE gav_prepare FROM ls_sql2
   DECLARE gav_curs CURSOR FOR gav_prepare
 
   FOREACH gae_curs INTO ls_gae02
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET li_del_flag = TRUE
      FOR li_i = 1 TO g_form.getLength()
          # 2004/07/12 by saki : 只挑掉wintitle關鍵字
          IF (g_form[li_i].field_name = ls_gae02) OR ls_gae02 = "wintitle" THEN
             LET li_del_flag = FALSE
             EXIT FOR
          END IF
      END FOR
      IF (li_del_flag) THEN
         DELETE FROM gae_file
          WHERE gae01 = gc_frm_name AND gae02 = ls_gae02
            AND gae11 = g_cust_flag
         IF SQLCA.sqlcode THEN
            DISPLAY '"',ls_gae02,'" delete error'
         END IF
      END IF
   END FOREACH
   
   FOREACH gav_curs INTO ls_gav02
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET li_del_flag = TRUE
      FOR li_i = 1 TO g_form.getLength()
          IF g_form[li_i].field_name = ls_gav02 THEN
             LET li_del_flag = FALSE
             EXIT FOR
          END IF
      END FOR
      IF (li_del_flag) THEN
         DELETE FROM gav_file WHERE gav01 = gc_frm_name AND gav02 = ls_gav02 AND gav08 = g_cust_flag
         IF SQLCA.sqlcode THEN
            DISPLAY '"',ls_gav02,'" delete error'
         END IF
      END IF
   END FOREACH
END FUNCTION
 
# Descriptions...: 增加客製欄位其他語言敘述
# Date & Author..: 04/10/06 by saki
 
FUNCTION p_preview_cust_insert()
   DEFINE   li_cnt       LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_i         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   l_sql        STRING
   DEFINE   ls_gae02     LIKE gae_file.gae02
   DEFINE   ls_gae12     LIKE gae_file.gae12    #FUN-7B0081
   DEFINE   ls_gae04_o   LIKE gae_file.gae04
   DEFINE   ls_gae04_n   LIKE gae_file.gae04
   DEFINE   ls_gbs06_o   LIKE gbs_file.gbs06    #FUN-7B0081 gae_file.gae05
   DEFINE   ls_gbs06_n   LIKE gbs_file.gbs06    #FUN-7B0081 gae_file.gae05
   DEFINE   lr_gay01     DYNAMIC ARRAY OF RECORD
               gay01     LIKE gay_file.gay01
                         END RECORD
 
   SELECT COUNT(*) INTO li_cnt FROM gae_file
    WHERE gae01 = gc_frm_name AND gae11 = "N"
 
   IF li_cnt <= 0 THEN
      RETURN
   END IF
 
   CALL lr_gay01.clear()
   DECLARE gay01_curs CURSOR FOR
                      SELECT UNIQUE gay01 FROM gay_file
   LET li_cnt = 1
   FOREACH gay01_curs INTO lr_gay01[li_cnt].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_gay01.deleteElement(li_cnt)
 
   LET l_sql = "SELECT UNIQUE gae02,gae12 FROM gae_file", #FUN-7B0081
               " WHERE gae01 = '",gc_frm_name,"' AND gae11 = 'Y'"
   PREPARE gae02_pre FROM l_sql
   DECLARE gae02_cur CURSOR FOR gae02_pre
 
   FOREACH gae02_cur INTO ls_gae02,ls_gae12
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      FOR li_i = 1 TO lr_gay01.getLength()
          INITIALIZE ls_gae04_n TO NULL             # MOD-4A0277
          INITIALIZE ls_gae04_o TO NULL
 
          SELECT gae04 INTO ls_gae04_n FROM gae_file
           WHERE gae01 = gc_frm_name AND gae02 = ls_gae02
             AND gae03 = lr_gay01[li_i].gay01 AND gae11="Y" AND gae12=ls_gae12
 
          IF ls_gae04_n IS NULL THEN
             SELECT gae04 INTO ls_gae04_o FROM gae_file
              WHERE gae01 = gc_frm_name AND gae02 = ls_gae02
                AND gae03 = lr_gay01[li_i].gay01 AND gae11 = "N"
             UPDATE gae_file SET gae04 = ls_gae04_o
                               , gae10 = TODAY        #FUN-590075
                             WHERE gae01 = gc_frm_name
                               AND gae02 = ls_gae02
                               AND gae03 = lr_gay01[li_i].gay01
                               AND gae11 = "Y"
                               AND gae12 = ls_gae12
             IF SQLCA.sqlcode THEN
                #CALL cl_err('gae_file',SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","gae_file",gc_frm_name,ls_gae02,SQLCA.sqlcode,"","gae_file",0)    #No.FUN-660081
             END IF
          END IF
 
          INITIALIZE ls_gbs06_n TO NULL
          INITIALIZE ls_gbs06_o TO NULL
 
          SELECT gbs06 INTO ls_gbs06_n FROM gbs_file
           WHERE gbs01 = gc_frm_name          AND gbs02 = ls_gae02
             AND gbs03 = lr_gay01[li_i].gay01 AND gbs04 = "Y"
 
          IF ls_gbs06_n IS NULL THEN
             SELECT gbs06 INTO ls_gbs06_o FROM gbs_file
              WHERE gbs01 = gc_frm_name          AND gbs02 = ls_gae02
                AND gbs03 = lr_gay01[li_i].gay01 AND gbs04 = "N" AND gbs05 = ls_gae12
             UPDATE gbs_file SET gbs06 = ls_gbs06_o
                           WHERE gbs01 = gc_frm_name
                             AND gbs02 = ls_gae02
                             AND gbs03 = lr_gay01[li_i].gay01
                             AND gbs04 = "Y"
                             AND gbs05 = ls_gae12
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gbs_file",gc_frm_name,ls_gae02,SQLCA.sqlcode,"","gbs_file",0)    #No.FUN-660081
             END IF
          END IF
      END FOR
   END FOREACH
END FUNCTION
 
FUNCTION p_preview_gbs06(li_type,lc_gbs06,lc_gbs07,lc_gbs01,lc_gbs02,lc_gbs03,lc_gbs04,lc_gbs05)  #FUN-7B0081
 
   DEFINE li_type     LIKE type_file.num10
   DEFINE li_i        LIKE type_file.num10
   DEFINE lc_gbs01    LIKE gbs_file.gbs01
   DEFINE lc_gbs02    LIKE gbs_file.gbs02
   DEFINE lc_gbs03    LIKE gbs_file.gbs03
   DEFINE lc_gbs04    LIKE gbs_file.gbs04
   DEFINE lc_gbs05    LIKE gbs_file.gbs05
   DEFINE lc_gbs06    LIKE gbs_file.gbs06
   DEFINE lc_gbs07    LIKE gbs_file.gbs07
 
   SELECT count(*) INTO li_i FROM gbs_file
    WHERE gbs01=lc_gbs01 AND gbs02=lc_gbs02 AND gbs03=lc_gbs03
      AND gbs04=lc_gbs04 AND gbs05=lc_gbs05
 
   IF li_i > 0 THEN
      IF cl_null(lc_gbs06 CLIPPED) AND cl_null(lc_gbs07 CLIPPED) THEN
         DELETE FROM gbs_file
           WHERE gbs01=lc_gbs01 AND gbs02=lc_gbs02 AND gbs03=lc_gbs03
             AND gbs04=lc_gbs04 AND gbs05=lc_gbs05
         RETURN
      END IF
      CASE
         WHEN li_type=0
            UPDATE gbs_file SET gbs06=lc_gbs06,gbs07=lc_gbs07
             WHERE gbs01=lc_gbs01 AND gbs02=lc_gbs02 AND gbs03=lc_gbs03
               AND gbs04=lc_gbs04 AND gbs05=lc_gbs05
         WHEN li_type=6
            UPDATE gbs_file SET gbs06=lc_gbs06
             WHERE gbs01=lc_gbs01 AND gbs02=lc_gbs02 AND gbs03=lc_gbs03
               AND gbs04=lc_gbs04 AND gbs05=lc_gbs05
         WHEN li_type=7
            UPDATE gbs_file SET gbs07=lc_gbs07
             WHERE gbs01=lc_gbs01 AND gbs02=lc_gbs02 AND gbs03=lc_gbs03
               AND gbs04=lc_gbs04 AND gbs05=lc_gbs05
      END CASE
   ELSE
      CASE
         WHEN li_type=0
            INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs06,gbs07)
                   VALUES(lc_gbs01,lc_gbs02,lc_gbs03,lc_gbs04,lc_gbs05,
                          lc_gbs06,lc_gbs07)
         WHEN li_type=6
            INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs06)
                   VALUES(lc_gbs01,lc_gbs02,lc_gbs03,lc_gbs04,lc_gbs05,
                          lc_gbs06)
         WHEN li_type=7
            INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs07)
                   VALUES(lc_gbs01,lc_gbs02,lc_gbs03,lc_gbs04,lc_gbs05,
                          lc_gbs07)
      END CASE
   END IF
END FUNCTION
 
 
 
