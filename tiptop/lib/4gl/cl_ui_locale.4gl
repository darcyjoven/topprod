# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: cl_ui_locale.4gl
# Descriptions...: 轉換畫面語言別.
# Date & Author..: 03/06/27 by Hiko
# Usage..........: CALL cl_ui_locale(NULL)
# Modify.........: 03/10/08 Hiko 針對MI_ENRTY的部分有將程式段mark起來.
# Modify.........: 04/03/31 Brendan
# Modify.........: No.MOD-4A0261 04/10/19 saki 增加客製碼判斷
# Modify.........: No.MOD-4C0124 04/12/22 saki 修改必要欄位是否隱藏邏輯
# Modify.........: No.MOD-550039 05/05/05 alex 修正 OUTER 錯誤
# Modify.........: No.FUN-520002 05/07/21 自訂欄位功能
# Modify.........: No.MOD-590343 05/09/16 Brendan 修正抓取欄位資訊的 SQL OUTER 用法
# Modify.........: No.MOD-590433 05/09/27 alex 補上 reverse 屬性
# Modify.........: No.MOD-560058 05/10/07 hiko mark 掉 entry 部份是怕出現無窮迴圈
# Modify.........: No.FUN-560038 05/10/07 alex 加回MOD-560058並修正,僅取消gaj部份
# Modify.........: No.TQC-5A0006 05/10/20 alex 避開Button抓child
# Modify.........: No.FUN-610065 06/01/19 saki 自訂欄位修改
# Modify.........: No.FUN-630089 06/03/29 saki 將無多語言的欄位加入到gav_file中以供設定
# Modify.........: No.MOD-640496 06/04/17 saki 調整FUN-630089的功能
# Modify.........: No.TQC-650047 06/05/15 By pengu在判斷欄位是否顯示時，在判斷權限類別時須加判斷p_zxw所設定的權限類別
# Modify.........: No.TQC-660042 06/06/21 By Pengu 變數mi_mainfrm運用完後應改回FALSE。
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-6B0077 06/11/15 By saki 共用畫面時的TopMenu語言別轉換
# Modify.........: No.FUN-570225 06/12/06 By saki per內Button元件的comment設定
# Modify.........: NO.MOD-6C0003
# Modify.........: No.FUN-710055 07/01/22 By saki 自定義欄位功能-UI畫面調整
# Modify.........: No.TQC-740052 07/04/13 By saki 無畫面時，警告錯誤訊息
# Modify.........: No.FUN-710013 07/05/02 By Echo ring menu 的 button 加 show hint 顯示 button comment
# Modify.........: No.TQC-750249 07/06/06 By saki 欄位是否可輸入加入必要欄位判斷
# Modify.........: No.FUN-760049 07/06/20 By saki 行業別代碼更動
# Modify.........: No.FUN-760072 07/06/26 By saki 自動產生單身串查Button
# Modify.........: No.FUN-7B0080 07/11/14 By saki 行業別欄位架構取消，改為自定義欄位使用
# Modify.........: No.FUN-7B0081 07/11/28 By alex 移出gae05至gbs06
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0060 07/12/19 By Brendan 恢復欄位註解顯示(串 gbs06)
# Modify.........: No.FUN-770104 08/01/07 By saki 串查功能修正
# Modify.........: No.TQC-810061 08/01/25 By saki 串查功能修正 - 主程式呼叫此lib兩次時, 可能造成串查功能失效
# Modify.........: No.FUN-810089 08/02/01 By saki 行業別代碼依照g_prog抓取
# Modify.........: No.MOD-840618 08/04/23 By chenl  修改對空值判斷的語句。
# Modify.........: No.FUN-840180 08/05/23 By saki comment增加顯示欄位代碼
# Modify.........: No.TQC-910010 09/01/08 By saki 單身不可於runtime隱藏
# Modify.........: No.FUN-8C0139 09/01/17 By kevin 欄位可設成***讓user無法窺探其內容
# Modify.........: No.CHI-930026 09/03/11 By saki 若欄位前無Label則不需重新設定X軸起點
# Modify.........: No.MOD-930134 09/03/13 By Sarah 將CALL cl_field_format()段搬到cl_setLocaleText()後面
# Modify.........: No:MOD-9A0175 09/10/28 By Sarah aoos100設定key值顏色為紅色,但開啟aglt110後按新增,傳票編號欄位卻是黃色
# Modify.........: No:MOD-9B0055 09/11/09 By saki 自定義欄位會重新定義寬度, 必須要重新呼叫cl_field_format
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No.FUN-A80084 10/08/16 By tommas 抓取gaj_file時，加入行業別當key值 
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
# Modify.........: No.EXT-B60126 11/10/28 By saki 修正無法將自定義欄位換位置到多Grid的Page中
# Modify.........: No.FUN-CC0040 12/12/05 By Kevin 自動產生畫面 xml 檔案
# Modify.........: No.CHI-D30026 13/03/22 By zack 調整cl_ui_locale,抓取資料時增加判斷行業別 
# Modify.........: No.CHI-D80015 13/08/14 By ycchao 調整CHI-D30026未考慮到的部份,增加判斷行業別是否存在


DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
   DEFINE   mi_call_by_dynamic_locale   LIKE type_file.num5     #No.FUN-690005 SMALLINT
   DEFINE   mi_btn_sn                   LIKE type_file.num5     #No.FUN-710055
   DEFINE   mi_table_flag               LIKE type_file.num5     #No.FUN-770104
   DEFINE   mi_btnb_flag                LIKE type_file.num5     #No.FUN-710055 FUN-770104變GLOBAL
   #No.TQC-810061 --start--
   DEFINE   mr_btnb                     DYNAMIC ARRAY OF RECORD
               form_name                LIKE gae_file.gae01,
               table_flag               LIKE type_file.num5,
               btnb_flag                LIKE type_file.num5 
                                        END RECORD
   #No.TQC-810061 ---end---
END GLOBALS
 
DEFINE mc_frm_name         LIKE gae_file.gae01
DEFINE ms_elementList      STRING,
       ms_excludeList      STRING                #MOD-6C0003
DEFINE ms_noentry_fields   STRING                # cl_set_comp_entry判斷專用變數.
DEFINE mi_flag             LIKE type_file.num10   #No.FUN-690005  INTEGER
DEFINE mi_mainfrm          LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE mc_cust_flag        LIKE gae_file.gae11   # MOD-4A0261
DEFINE mc_cust_gav         LIKE gav_file.gav08   # MOD-550039
DEFINE ms_show_err         LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE mi_userdefined_field_flag   LIKE type_file.num5    #No.FUN-690005 SMALLINT              #No.FUN-520002 自訂欄位page是否隱藏  No.FUN-610065
DEFINE mr_del_node         DYNAMIC ARRAY OF om.DomNode    #No.FUN-710055
DEFINE mi_cnt              LIKE type_file.num5            #No.FUN-710055
DEFINE mi_btn_create_flag  LIKE type_file.num5            #No.FUN-710055
DEFINE mc_std_id           LIKE smb_file.smb01            #No.FUN-710055
DEFINE mr_cntnode          DYNAMIC ARRAY OF om.DomNode    #No.FUN-760072
DEFINE mi_open_userdefined LIKE type_file.num5            #No.FUN-7B0080
DEFINE ms_field_passwd     LIKE gaj_file.gaj12            #No.FUN-8C0139
          
 
CONSTANT MI_VISIBLE = 1,
         MI_ENTRY = 2      # 辦別所要判斷的權限設定之常數.
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 當呼叫 cl_set_locale_frm_name 後由 cl_ui_init 串入部份
# Date & Author..: 2004/07/09 By hjwang
# Input Parameter: pi_non_mainfrm SMALLINT 旗標設定
# Return code....: void
# Usage..........: CALL cl_ui_locale_mainfrm(1)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_ui_locale_mainfrm(pi_mainfrm)
 
   DEFINE pi_mainfrm   LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
   LET mi_mainfrm = pi_mainfrm
 
END FUNCTION

 
#FUN-B50102 函式說明
##################################################
# Descriptions...: 轉換語言別
# Date & Author..: 2003/06/27 By Hiko
# Input Parameter: pc_frm_name VARCHAR(10) 畫面名稱(NULL→預設名稱:g_prog)
# Return code....: none
# Usage..........: CALL cl_ui_locale("axmi224")
# Memo...........:
# Modify.........: 04/03/31 by Brendan
##################################################
FUNCTION cl_ui_locale(pc_frm_name)
  DEFINE pc_frm_name    LIKE gae_file.gae01
  DEFINE lw_window      ui.Window
  DEFINE lf_form        ui.Form
  DEFINE lnode_root     om.DomNode
  DEFINE lnode_frm      om.DomNode
  DEFINE li_gae_count   LIKE type_file.num5    #No.FUN-690005 SMALLINT
  DEFINE lc_title       LIKE gae_file.gae04
  DEFINE l_start        DATETIME HOUR TO FRACTION(5),
         l_end          DATETIME HOUR TO FRACTION(5)
  DEFINE l_interval     INTERVAL SECOND TO FRACTION(5)
  DEFINE ls_formName    STRING
  DEFINE li_idx         LIKE type_file.num10   #No.FUN-690005 INTEGER
  DEFINE lnode_parent   om.DomNode             #No.FUN-710055
  DEFINE li_cnt         LIKE type_file.num5    #No.FUN-710055
  DEFINE ls_prog        STRING                 #No.FUN-810089
  DEFINE li_dash_inx    SMALLINT               #No.FUN-810089
   DEFINE   lnode_button    om.DomNode
   DEFINE   ls_btn_name     STRING
   DEFINE   ls_btn_hidden   STRING
   DEFINE   ls_btn_unhidden STRING   #No:FUN-A10059
  DEFINE   ln_root      om.DomNode   #FUN-CC0040
  DEFINE   ls_fname     STRING       #FUN-CC0040
 
  WHENEVER ERROR CALL cl_err_msg_log
 
--Getting node of UI & Form, for later job ...
  LET lnode_root = ui.Interface.getRootNode()
  LET lw_window = ui.Window.getCurrent()
  LET lf_form = lw_window.getForm()
  IF lf_form IS NULL THEN
     #No.TQC-740052 --start--
#    RETURN
     CALL cl_err("","lib-361",1)
     EXIT PROGRAM
     #No.TQC-740052 ---end---
  END IF
  LET lnode_frm = lf_form.getNode()
--#
 
  LET mi_flag = FALSE
  IF (cl_null(pc_frm_name)) THEN
     --Condition: same program id with different opened form
     LET ls_formName = lnode_frm.getAttribute("name")
     LET li_idx = ls_formName.getIndexOf(".tmp", 1)   #FUN-A10029
     IF li_idx != 0 THEN
        LET ls_formName = ls_formName.subString(1, li_idx - 1)
     END IF
     LET li_idx = ls_formName.getIndexOf("T", 1)
     IF li_idx != 0 THEN
        LET ls_formName = ls_formName.subString(1, li_idx - 1)
     END IF
     IF ls_formName = g_prog CLIPPED THEN
        LET mc_frm_name = g_prog CLIPPED
     ELSE
        LET mc_frm_name = ls_formName
     END IF
     --#
  ELSE
     LET mc_frm_name = pc_frm_name
     IF mi_mainfrm IS NULL OR mi_mainfrm != 1 THEN
        LET mi_flag = TRUE
    #-------------No.TQC-660042 modify
     ELSE
        LET mi_mainfrm = FALSE
    #-------------No.TQC-660042 end
     END IF
  END IF
 
  LET l_start = CURRENT HOUR TO FRACTION(5)
 
  # 2004/04/24 將 4ad 拆成標準和各程式均有部份處理, 特殊部份於此讀入
  IF ( g_prog <> mc_frm_name ) AND ( mi_flag ) THEN
     CALL cl_load_act_list(NULL)
  END IF
 
  # 2003/07/01 by Hiko : 如果資料庫內沒有此程式的字典檔,則不要做任何事.
  # 2004/03/06 by hjwang:新增語言別
  SELECT COUNT(*) INTO li_gae_count FROM gae_file
   WHERE gae01 = mc_frm_name AND gae03 = g_lang
 
  IF SQLCA.SQLCODE OR ( li_gae_count = 0 ) THEN
     RETURN
  END IF
 #-------------No.CHI-D30026 modify
  LET mc_std_id = "std"
  IF NOT g_action_choice.equals("preview") then
   LET ls_prog = g_prog
   IF ls_prog.getIndexOf("_",1) THEN
        WHILE ls_prog.getIndexOf("_",li_dash_inx+1)
           LET li_dash_inx = ls_prog.getIndexOf("_",li_dash_inx+1)
        END WHILE
        LET g_ui_setting = ls_prog.subString(li_dash_inx+1,ls_prog.getLength())
        # add by No.CHI-D80015 --start
        SELECT COUNT(*) INTO li_cnt FROM smb_file WHERE smb01=g_ui_setting           #尋找有無此行業別
        IF li_cnt = 0 THEN
           LET g_ui_setting=mc_std_id
        END IF
        # add by No.CHI-D80015 --end
   ELSE
       LET g_ui_setting=mc_std_id
   END IF
  END IF
 #-------------No.CHI-D30026 end
   # MOD-550039 by saki : 若有客製碼為Y的資料則優先抓取
  SELECT COUNT(*) INTO li_gae_count FROM gav_file
  # WHERE gav01 = mc_frm_name AND gav08 = 'Y'                       #mark CHI-D30026   
  WHERE gav01 = mc_frm_name AND gav08 = 'Y' and gav11=g_ui_setting  #CHI-D30026
  IF li_gae_count > 0 THEN
     LET mc_cust_gav  = "Y"
  ELSE
     LET mc_cust_gav  = "N"
  END IF
 
   # MOD-4A0261 by saki : 若有客製碼為Y的資料則優先抓取
  SELECT COUNT(*) INTO li_gae_count FROM gae_file
   #WHERE gae01 = mc_frm_name AND gae03 = g_lang AND gae11 = 'Y'                       #mark CHI-D30026
   WHERE gae01 = mc_frm_name AND gae03 = g_lang AND gae11 = 'Y' and gae12=g_ui_setting #CHI-D30026
  IF li_gae_count > 0 THEN
     LET mc_cust_flag = "Y"
  ELSE
     LET mc_cust_flag = "N"
  END IF
 
  #No.FUN-810089 --modify start--
  #一般行業別代碼
  #LET mc_std_id = "std"                #No.FUN-760049  #No.FUN-810089 #CHI-D30026 移動位置
 
  #No.FUN-710055 --start-- 新增key -gav11 行業別自訂畫面
  IF g_action_choice = "preview" THEN
     DISPLAY "g_ui_setting : ",g_ui_setting
  ELSE
#    LET g_ui_setting = g_sma.sma124
    #No.CHI-D30026 --start--
    # LET ls_prog = g_prog
    # IF ls_prog.getIndexOf("_",1) THEN                                                                                
    #    WHILE ls_prog.getIndexOf("_",li_dash_inx+1)                                   
    #       LET li_dash_inx = ls_prog.getIndexOf("_",li_dash_inx+1)                  
    #    END WHILE                                                                    
    #No.CHI-D30026 --end--
        LET g_ui_setting = ls_prog.subString(li_dash_inx+1,ls_prog.getLength())
        SELECT COUNT(*) INTO li_cnt FROM smb_file WHERE smb01=g_ui_setting           #尋找有無此行業別
        IF li_cnt > 0 THEN
           SELECT COUNT(*) INTO li_cnt FROM gav_file
            WHERE gav01 = mc_frm_name AND gav_file.gav08 = mc_cust_gav AND gav_file.gav11 = g_ui_setting   #p_per
           IF li_cnt <= 0 THEN
              LET g_ui_setting = mc_std_id
           ELSE
              SELECT COUNT(*) INTO li_cnt FROM gae_file
               WHERE gae01 = mc_frm_name AND gae03 = g_lang AND gae11 = mc_cust_flag AND gae12 = g_ui_setting  #p_perlang
              IF li_cnt <= 0 THEN
                 LET g_ui_setting = mc_std_id
              END IF
           END IF
        ELSE
           LET g_ui_setting = mc_std_id
        END IF
    #No.CHI-D30026 --start--  
    # ELSE                                                                          
    #    LET g_ui_setting = mc_std_id                                                 
    # END IF                                                                       
    #No.CHI-D30026 --end--
 
    DISPLAY "g_ui_setting : ",g_ui_setting
  END IF
# SELECT COUNT(*) INTO li_cnt FROM gav_file
#  WHERE gav01 = mc_frm_name AND gav_file.gav08 = mc_cust_gav AND gav_file.gav11 = g_ui_setting
# IF li_cnt <= 0 THEN
#    LET g_ui_setting = mc_std_id
# ELSE
#    SELECT COUNT(*) INTO li_cnt FROM gae_file
#     WHERE gae01 = mc_frm_name AND gae03 = g_lang AND gae11 = mc_cust_flag AND gae12 = g_ui_setting
#    IF li_cnt <= 0 THEN
#       LET g_ui_setting = mc_std_id
#    END IF
# END IF
  #No.FUN-710055 ---end---
  #No.FUN-810089 ---modify end---
 
--Setting window title of sub form
  IF ( g_prog <> mc_frm_name ) AND ( mi_flag ) THEN
     SELECT gae04 INTO lc_title FROM gae_file
      WHERE gae01 = mc_frm_name AND gae02 = 'wintitle'
         AND gae03 = g_lang AND gae11 = mc_cust_flag AND gae12 = g_ui_setting           # MOD-4A0261   #No.FUN-710055
 
     IF ( NOT SQLCA.SQLCODE) AND ( NOT cl_null(lc_title) ) THEN
        CALL lw_window.setText(lc_title CLIPPED)
     END IF
  END IF
--#
 
--Mapping text of element correspond to selected locale
 
--Setting text of this form
  SELECT gae04 INTO lc_title FROM gae_file
   WHERE gae01 = mc_frm_name AND gae02 = mc_frm_name
     AND gae03 = g_lang AND gae11 = mc_cust_flag AND gae12 = g_ui_setting   #No.FUN-710055
 
  IF ( NOT SQLCA.SQLCODE ) AND ( NOT cl_null(lc_title) ) THEN
     CALL cl_set_attribute("text", lnode_frm, lc_title)
  END IF
--#
 
--Setting text of 'TopMenuGroup' node
  CALL cl_setTopMenuGroupText(lnode_root, lnode_frm)
--#
 
--List of Elements that need to set text
  LET ms_elementList = "Page, Group, Label, FormField, Matrix, Button, TableColumn"
  LET ms_excludeList = "Page, Group, Label, TableColumn"
--#
 
  #No.FUN-710055 --start--
  LET mi_userdefined_field_flag = FALSE
  LET mi_cnt = 1
  CALL mr_del_node.clear()
  LET mi_btn_sn = 1
  LET mi_btnb_flag = FALSE
  #No.FUN-710055 ---end---
 
  #No.FUN-7B0080 --start--
  #檢查此畫面是否開啟自定義欄位功能
  SELECT COUNT(*) INTO li_cnt FROM gav_file
   WHERE gav01 = mc_frm_name AND gav_file.gav08 = mc_cust_gav AND gav_file.gav11 = g_ui_setting
     AND gav02 = "userdefined_field" AND gav03 = "Y"
  IF li_cnt > 0 THEN
     SELECT COUNT(*) INTO li_cnt FROM gav_file, gaq_file
      WHERE gav01 = mc_frm_name AND gav_file.gav08 = mc_cust_gav AND gav_file.gav11 = g_ui_setting
        AND gav02 = gaq01 AND gaq02 = g_lang AND gav03 = "Y" AND gaq06 = "3"
     IF li_cnt > 0 THEN
        LET mi_open_userdefined = TRUE
     END IF
  END IF
  #No.FUN-7B0080 ---end---
 
 #str MOD-9A0175 mod
  IF NOT mi_call_by_dynamic_locale THEN
     CALL cl_correctElementAttribute(lnode_frm)
  END IF
 #end MOD-9A0175 mod

  CALL cl_setLocaleText(lnode_frm)
 
  #str MOD-930134 mod
  #將此段落從前面搬下來
--Tuning some attributes of form field at first time
  IF NOT mi_call_by_dynamic_locale OR mi_open_userdefined THEN   #No:MOD-9B0055
     CALL cl_field_format(g_aza.aza17, mc_frm_name)
    #CALL cl_correctElementAttribute(lnode_frm)   #MOD-9A0175 mark
     LET mi_call_by_dynamic_locale = FALSE
  END IF
--#
  #end MOD-930134 mod
 
  #No.FUN-710055 --start--
  FOR mi_cnt = 1 TO mr_del_node.getLength()
      LET lnode_parent = mr_del_node[mi_cnt].getParent()
      CALL lnode_parent.removeChild(mr_del_node[mi_cnt])
  END FOR
  #No.FUN-710055 ---end---
 
  #No.FUN-520002 --start-- No.FUN-610065
  IF (NOT mi_userdefined_field_flag) THEN
     CALL cl_set_comp_visible("userdefined_field",FALSE)
  END IF
  #No.FUN-520002 ---end--- No.FUN-610065
 
  #No.FUN-710055 --start--  No.FUN-760072 modify
  IF (mi_btnb_flag) THEN
     CALL cl_detail_setButton()
#    CALL cl_set_comp_visible("btnb",FALSE)
#    CALL cl_set_act_visible("btn_detail",TRUE)         #No.FUN-770104
# ELSE
#    CALL cl_set_act_visible("btn_detail",FALSE)        #No.FUN-770104
  END IF
  LET mi_btn_create_flag = TRUE
  #No.FUN-710055 ---end---
--#
 
  #No.TQC-810061 --start-- 記錄此form的單身串查Button狀態
  LET li_cnt = mr_btnb.getLength() + 1
  LET mr_btnb[li_cnt].form_name = mc_frm_name
  LET mr_btnb[li_cnt].table_flag = mi_table_flag
  LET mr_btnb[li_cnt].btnb_flag = mi_btnb_flag
  #No.TQC-810061 ---end---

  CALL cl_set_action_comment(lnode_frm)                 #FUN-710013
 
  LET l_end = CURRENT HOUR TO FRACTION(5)
 
  LET l_interval = l_end - l_start
  DISPLAY "INFO: Locale feature use " || l_interval || " seconds."

  #FUN-CC0040 start
  IF FGL_GETENV("FORM_XML") = "Y" THEN
      LET ln_root = ui.Interface.getRootNode()
      LET ls_fname = FGL_GETENV("TEMPDIR"), "/", g_prog CLIPPED, ".xml"
      CALL ln_root.writeXml(ls_fname)
      DISPLAY "============================================="
      DISPLAY g_prog ," form xml: " ,ls_fname
      DISPLAY "============================================="
   END IF
  #FUN-CC0040 start
END FUNCTION

 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Mapping text of 'TopMenuGroup' correspond to selected locale
# Date & Author..: 2004/04/02 By Brendan
# Input Parameter: pnode_root om.DomNode   Root Node
#                  pnode_frm  om.DomNode   Form Node
# Return code....: none
# Usage..........: CALL cl_setTopMenuGroupText(lnode_root, lnode_frm)
# Memo...........: might have some problem in the future...
# Modify.........: 
##################################################
FUNCTION cl_setTopMenuGroupText(pnode_root, pnode_frm)
  DEFINE pnode_root     om.DomNode,
         pnode_frm      om.DomNode
  DEFINE llist_item     om.NodeList
  DEFINE li_i           LIKE type_file.num10,   #No.FUN-690005 INTEGER
         li_cnt         LIKE type_file.num10    #No.FUN-690005 INTEGER
  DEFINE lc_text        LIKE gae_file.gae04
  DEFINE la_topMenu     DYNAMIC ARRAY OF RECORD
                           seq    LIKE gae_file.gae02,
                           item   om.DomNode
                        END RECORD
  DEFINE lc_cust_flag   LIKE gae_file.gae11
 
 
  #No.TQC-6B0077 ---mark--
# IF ( mc_frm_name CLIPPED != g_prog CLIPPED ) AND ( mi_flag ) THEN
#    RETURN
# END IF
  #No.TQC-6B0077 ---end---
 
  LET li_cnt = 1
 
--Process root node
  LET llist_item = pnode_root.selectByPath("/UserInterface/TopMenu/TopMenuGroup")
  FOR li_i = 1 TO llist_item.getLength()
      LET la_topMenu[li_cnt].seq = li_cnt
      LET la_topMenu[li_cnt].item = llist_item.item(li_i)
      LET li_cnt = li_cnt + 1
  END FOR
--#
 
--Process form node
  LET llist_item = pnode_frm.selectByPath("/Form/TopMenu/TopMenuGroup")
  FOR li_i = 1 TO llist_item.getLength()
      LET la_topMenu[li_cnt].seq = li_cnt
      LET la_topMenu[li_cnt].item = llist_item.item(li_i)
      LET li_cnt = li_cnt + 1
  END FOR
--#
  
   #MOD-4B0129
  LET li_i = 0
  SELECT COUNT(*) INTO li_i FROM gae_file
   WHERE gae01 = 'TopMenuGroup' AND gae03 = g_lang AND gae11 = "Y" AND gae12 = mc_std_id       #No.FUN-710055
  IF li_i = 0 THEN
     LET lc_cust_flag="N"
  ELSE
     LET lc_cust_flag="Y"
  END IF
 
  FOR li_i = 1 TO li_cnt - 1
      SELECT gae04 INTO lc_text FROM gae_file
       WHERE gae01 = 'TopMenuGroup' AND gae02 = la_topMenu[li_i].seq
          AND gae03 = g_lang AND gae11 = lc_cust_flag AND gae12 = mc_std_id      #No.FUN-710055
 
      IF ( NOT SQLCA.SQLCODE ) AND ( NOT cl_null(lc_text) ) THEN
         CALL cl_set_attribute("text", la_topMenu[li_i].item, lc_text)
      END IF
  END FOR
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Mapping text of element correspond to selected locale
# Date & Author..: 2004/03/31 By Brendan
# Input Parameter: pnode_frm om.DomNode   Parent Node
# Return code....: none
# Usage..........: CALL cl_setLocaleText(lnode_frm)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setLocaleText(pnode_frm)
  DEFINE pnode_frm        om.DomNode
  DEFINE lnode_child      om.DomNode
  DEFINE ls_tagName       STRING
  DEFINE ls_name          STRING
 
 
--Check every node for replacing text of locale, recursively
  LET lnode_child = pnode_frm.getFirstChild()
  WHILE lnode_child IS NOT NULL
        LET ls_tagName = lnode_child.getTagName()
 
        #No.FUN-770104 --start--
        IF ls_tagName = "Table" THEN
           LET mi_table_flag = TRUE
        END IF
        #No.FUN-770104 ---end---
 
        IF ms_elementList.getIndexOf(ls_tagName, 1) THEN
           LET ls_name = lnode_child.getAttribute("colName")
           IF cl_null(ls_name) THEN
              LET ls_name = lnode_child.getAttribute("name")
           END IF
 
           IF NOT cl_null(ls_name) THEN
              IF ls_tagName = "Label" THEN
                 IF ls_name.subString(1, 5) = "dummy" THEN
                    CALL cl_change_by_name(lnode_child, ls_tagName, ls_name)
                 END IF
              ELSE
                 CALL cl_change_by_name(lnode_child, ls_tagName, ls_name)
              END IF
           END IF
        END IF
 
        CALL cl_setLocaleText(lnode_child)
        LET lnode_child = lnode_child.getNext()
  END WHILE
--#
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 轉換多語言的欄位說明/註解.
# Date & Author..: 2003/07/01 by Hiko
# Input Parameter: pnode_target om.DomNode 欲轉換欄位說明/註解之節點
#                  ps_tag_name STRING TAG名稱
#                  pc_field_name VARCHAR(20) 欄位名稱
# Return Code....: void
# Usage..........: 
# Memo...........:
# Modify.........: 04/03/31 by Brendan
##################################################
FUNCTION cl_change_by_name(pnode_target, ps_tag_name, pc_field_name)
  DEFINE pnode_target    om.DomNode,
         ps_tag_name     STRING,
         pc_field_name   LIKE gae_file.gae02
  DEFINE lnode_pre       om.DomNode
  DEFINE li_bind_label   LIKE type_file.num5    #No.FUN-690005 SMALLINT
  DEFINE lc_text         LIKE gae_file.gae04    # 選出的 TEXT
# DEFINE lc_comment      LIKE gae_file.gae05    # 選出的 COMMENT
  DEFINE lc_comment      LIKE gbs_file.gbs06    # 選出的 COMMENT #FUN-7B0081
  DEFINE lc_comment2     LIKE gaq_file.gaq03    # gaq03額外comment
  DEFINE lc_visible      LIKE gav_file.gav03    # 選出的是否可視
  DEFINE lc_entry        LIKE gav_file.gav04    # 選出的是否可進入
  DEFINE lc_is_key       LIKE gav_file.gav07    # 選出的是否為KEY值
  DEFINE ls_notNull      STRING,
         ls_required     STRING
  DEFINE lnode_parent    om.DomNode
  DEFINE ls_hidden       STRING
  DEFINE ls_req_hidden   LIKE gav_file.gav09    # 是否可將必要欄位隱藏
  DEFINE ls_req_field    LIKE gav_file.gav10    # 是否為必要欄位
  #No.FUN-710055 --start--
  DEFINE li_width        LIKE gav_file.gav12    # 欄位寬度
  DEFINE lc_pagename     LIKE gav_file.gav13    # 欄位所在page
  DEFINE li_posX         LIKE gav_file.gav14    # 欄位橫向起點
  DEFINE li_posY         LIKE gav_file.gav15    # 欄位直向列數
  DEFINE li_tabIndex     LIKE gav_file.gav16    # 欄位輸入順序
  DEFINE lc_default      LIKE gav_file.gav17    # 欄位Default
  DEFINE lc_limit        LIKE gav_file.gav18    # 欄位限制值
  DEFINE lc_controlp     LIKE gav_file.gav19    # 欄位開窗設定
  DEFINE lc_reference    LIKE gav_file.gav21    # 關聯欄位
  DEFINE lc_combo_flag   LIKE gav_file.gav24    # 轉ComboBox否
  DEFINE lc_combo_str    LIKE gav_file.gav25    # ComboBox多語言
  DEFINE lc_refer_name   LIKE gav_file.gav31    # 關聯欄位
  DEFINE lc_btn          LIKE gav_file.gav32    # 串連程式
  DEFINE lc_checkbox     LIKE gav_file.gav33    # 轉CheckBox
  DEFINE li_posX_label   LIKE gav_file.gav34    # Label的起點
  DEFINE lc_auto_refer   LIKE gav_file.gav36    # 自動產生關聯欄位
  DEFINE li_posX_refer   LIKE gav_file.gav37    # 自動產生的關聯欄位起點
  DEFINE ls_posX         STRING
  DEFINE ls_posY         STRING
  DEFINE ls_width        STRING
  DEFINE ls_tabIndex     STRING
  DEFINE ls_posX_label   STRING
  DEFINE ls_posX_refer   STRING
  DEFINE lnode_child     om.DomNode             # 欄位的元件節點
  DEFINE ls_child_tag    STRING
  DEFINE lnode_next      om.DomNode             # reference的欄位節點
  DEFINE lnode_nextchild om.DomNode
  DEFINE ls_old_posX     STRING                 # 欄位的原X起點
  DEFINE ls_pre_posX     STRING                 # 前面Label的原X起點
  DEFINE ls_pagetemp     STRING                 # 比較設定與目前的page/group有否一樣
  #No.FUN-710055 ---end---
 
--2004/03/06 修改為固定欄位, 因為新增語言別及拆 table
# 2004/08/23 add gaq03
# FUN-4B0078 add gav09
# MOD-4C0124 add gav10
#No.FUN-7B0080 將自定義欄位設定column與原本SQL分開搜尋, 以加快速度
# #FUN-7B0081
# SELECT gae04, gae05, gav03, gav04, gav09, gav10, gav07, gaq03
#   INTO lc_text,lc_comment, lc_visible, lc_entry, ls_req_hidden, ls_req_field, lc_is_key, lc_comment2
#   FROM gae_file, OUTER gav_file
  SELECT gae04, gav03, gav04, gav09, gav10, gav07, gav14, gav15, gav32, gaq03
    INTO lc_text, lc_visible, lc_entry, ls_req_hidden, ls_req_field, lc_is_key, li_posX, li_posY, lc_btn, lc_comment2
    FROM gae_file LEFT OUTER JOIN gav_file ON gae01 = gav01 AND gae02 = gav02 AND gae11 = gav08 AND gae12 = gav11  #No.FUN-710055
                  LEFT OUTER JOIN gaq_file ON gae02 = gaq01 AND gae03 = gaq02
   WHERE gae01 = mc_frm_name AND gae02 = pc_field_name
     AND gae03 = g_lang
     AND gae11 = mc_cust_flag                   # MOD-4A0261 No.FUN-710055
     AND gae12 = g_ui_setting                   # No.FUN-710055
--#
   #No.MOD-640496 --start--
#   IF SQLCA.sqlcode = 100 OR SQLCA.sqlerrd[3] = 0 THEN  #FUN-7C0060
   IF SQLCA.sqlcode = 100 THEN                           #FUN-7C0060
      SELECT gav03, gav04, gav09, gav10, gav07, gaq03
        INTO lc_visible, lc_entry, ls_req_hidden, ls_req_field, lc_is_key, lc_comment2
    FROM gav_file LEFT OUTER JOIN gaq_file ON gav02 = gaq01 AND gaq02 = g_lang
   WHERE gav01 = mc_frm_name AND gav02 = pc_field_name
     AND gav_file.gav08 = mc_cust_gav 
     AND gav_file.gav11 = g_ui_setting                   #No.FUN-710055
   ELSE
      SELECT gbs06 INTO lc_comment FROM gbs_file    #FUN-7B0081
      #-- No.FUN-7C0060 BEGIN --------------------------------------------------
#       WHERE gae01=gbs01 AND gae02=gbs02 AND gae03=gbs03
#         AND gae11=gbs04 AND gae12=gbs05
        WHERE gbs01 = mc_frm_name AND gbs02 = pc_field_name
          AND gbs03 = g_lang AND gbs04 = mc_cust_flag AND gbs05 = g_ui_setting
      #-- No.FUN-7C0060 END ----------------------------------------------------
   END IF
   #No.MOD-640496 ---end---
 
   #No.FUN-7B0080 --start-- 當有自定義欄位開啟時才搜尋設定
   IF mi_open_userdefined THEN
      SELECT gav12, gav13, gav16, gav17, gav18, gav19, gav21,   #No.FUN-710055
             gav24, gav25, gav31, gav33, gav34, gav36, gav37           #No.FUN-710055
        INTO li_width,lc_pagename,li_tabIndex,lc_default,lc_limit,lc_controlp, lc_reference,                #No.FUN-710055
             lc_combo_flag, lc_combo_str, lc_refer_name, lc_checkbox, li_posX_label, lc_auto_refer, li_posX_refer   #No.FUN-710055
        FROM gav_file
       WHERE gav01 = mc_frm_name AND gav02 = pc_field_name
         AND gav_file.gav08 = mc_cust_gav AND gav_file.gav11 = g_ui_setting                   #No.FUN-710055
   END IF
   #No.FUN-7B0080 ---end---
 
   #No.FUN-710055 --start--
   LET lnode_child = pnode_target.getFirstChild()
   IF lnode_child IS NOT NULL THEN
      LET ls_child_tag = lnode_child.getTagName()
   END IF
   #No.FUN-710055 ---end---
 
   #No.FUN-760072 --start--
   CASE
      WHEN pc_field_name = "idx"
         LET mr_cntnode[1] = pnode_target
      WHEN pc_field_name = "cnt"
         LET mr_cntnode[2] = pnode_target
      WHEN pc_field_name = "cn2"
         LET mr_cntnode[3] = pnode_target
      WHEN pc_field_name = "cn3"
         LET mr_cntnode[4] = pnode_target
   END CASE
   #No.FUN-760072 ---end---
 
    #MOD-530555
   IF NOT cl_null(lc_comment2) AND pc_field_name != 'bdate' AND pc_field_name !='edate' THEN
      IF NOT cl_null(lc_comment) THEN
         LET lc_comment = lc_comment2 CLIPPED,":",lc_comment CLIPPED
      ELSE
         LET lc_comment = lc_comment2 CLIPPED
      END IF
   END IF
   LET lc_comment = lc_comment CLIPPED,"[",pc_field_name CLIPPED,"]"  #No.FUN-840180
 
   #No.FUN-710055 --start--  透過預覽畫面,顯示每個元件的內部設定
   IF g_action_choice = "preview" THEN
      LET lc_comment = lc_comment CLIPPED,
                       "\n<colName>  : ",pc_field_name,
                       "\n<Tag>      : ",ls_child_tag,
                       "\n<width>    : ",li_width,
                       "\n<tabIndex> : ",li_tabIndex
      IF ps_tag_name != "TableColumn" THEN
         LET lc_comment = lc_comment CLIPPED,
                       "\n<posX>    : ",li_posX,
                       "\n<posY>    : ",li_posY-1
      END IF
   END IF
   #No.FUN-710055 ---end---
 
   #No.FUN-710055 --start--
   #No.FUN-520002 --start-- No.FUN-610065
   #若自訂欄位 (???ud01~???ud15)都被隱藏，則自訂欄位page就會被隱藏
   IF (pc_field_name MATCHES "???ud[01][0-9]") OR (pc_field_name MATCHES "????ud[01][0-9]") THEN
      IF lc_visible = "Y" AND lc_pagename = "userdefined_field" THEN
         LET mi_userdefined_field_flag = TRUE
      END IF
   END IF
   #No.FUN-520002 ---end--- No.FUN-610065
   #No.FUN-710055 ---end---
 
 
--Check if parent node has already set as hidden, then return
  #No.FUN-710055 --start--
  LET lnode_parent = pnode_target.getParent()
  WHILE lnode_parent IS NOT NULL
     IF lnode_parent.getTagName() = "Page" OR lnode_parent.getTagName() = "Group" THEN
        LET ls_pagetemp = lnode_parent.getAttribute("name")
        EXIT WHILE
     ELSE
        LET lnode_parent = lnode_parent.getParent()
     END IF
  END WHILE
  IF ls_pagetemp.equals(lc_pagename CLIPPED) THEN
  #No.FUN-710055 ---end---
     LET lnode_parent = pnode_target.getParent()
     WHILE lnode_parent IS NOT NULL
         LET ls_hidden = lnode_parent.getAttribute("hidden")
         IF ( NOT cl_null(ls_hidden) ) AND ( ls_hidden = '1' ) THEN
            RETURN
         END IF
 
         LET lnode_parent = lnode_parent.getParent()
     END WHILE
  END IF
--#
 
--If this element set as hidden, then return 
  LET ls_notNull = pnode_target.getAttribute("notNull")
  LET ls_required = pnode_target.getAttribute("required")
 
  LET ms_field_passwd = "N" #FUN-8C0139
  # FUN-4B0078
  IF NOT cl_chk_auth(MI_VISIBLE, lc_visible, pc_field_name) THEN
      # MOD-4C0124
     IF (cl_null(ls_req_field)) AND (NOT ms_show_err) THEN
        CALL cl_err('','lib-221',1)
        LET ms_show_err = TRUE
     END IF
     IF ((ls_req_field = "Y") AND (ls_req_hidden = "N")) THEN
#    IF ( ( ( NOT cl_null(ls_notNull) ) AND ( ls_notNull = "1" ) ) OR
#       ( ( NOT cl_null(ls_required) ) AND ( ls_required = "1") ) ) AND
#       (ls_req_hidden = "N") THEN
     ELSE
     	#FUN-8C0139 --start--
        IF ms_field_passwd ="Y" THEN
           #需執行隱藏characters
        ELSE
           CALL pnode_target.setAttribute("hidden", "1")
 
--Also hide description text for this element
          IF NOT ms_excludeList.getIndexOf(ps_tag_name, 1) THEN
             CALL cl_get_change_text_node(pnode_target) RETURNING lnode_pre, li_bind_label
             IF li_bind_label THEN
                CALL lnode_pre.setAttribute("hidden", "1")
             END IF
          END IF
--#
          RETURN
       END IF
       #FUN-8C0139 --end
     END IF
  END IF
--#
 
  #FUN-8C0139 --start
  IF ms_field_passwd ="Y" THEN
    CALL lnode_child.setAttribute("isPassword", "1") #hide characters
  END IF
  #FUN-8C0139 --end
 
  CASE ps_tag_name
 
--Setting text of "Label" node; for static label, not for form field
     WHEN "Label"
        CALL cl_set_attribute("text", pnode_target, lc_text) 
--#
 
--Setting text of "Matrix" node; for scrollgrid
     WHEN "Matrix"
 
#       IF NOT cl_chk_auth(MI_ENTRY, lc_entry, pc_field_name) THEN
#          CALL pnode_target.setAttribute("noEntry", "1")
#
#          IF (ms_noentry_fields IS NULL) THEN
#             LET ms_noentry_fields = pc_field_name CLIPPED
#          ELSE
#             LET ms_noentry_fields = ms_noentry_fields || "," || pc_field_name
#          END IF
#       END IF
 
        IF lc_entry = "N" AND lc_is_key != "Y" AND ls_req_field != "Y" THEN #FUN-560038  #No.TQC-750249
           CALL pnode_target.setAttribute("noEntry", "1")
        END IF
 
        CALL cl_setFieldText(pnode_target, pc_field_name, lc_text, lc_comment)
 
        CALL cl_get_change_text_node(pnode_target) RETURNING lnode_pre, li_bind_label
        IF li_bind_label THEN
           CALL cl_set_attribute("text", lnode_pre, lc_text)
        END IF
 
        CALL cl_setKeyFieldHint(pnode_target, lc_is_key)
--#
 
--Setting text of "FormField" node
     WHEN "FormField"
#
#       IF NOT cl_chk_auth(MI_ENTRY, lc_entry, pc_field_name) THEN
#          CALL pnode_target.setAttribute("noEntry", "1")
#
#          IF (ms_noentry_fields IS NULL) THEN
#             LET ms_noentry_fields = pc_field_name CLIPPED
#          ELSE
#             LET ms_noentry_fields = ms_noentry_fields || "," || pc_field_name
#          END IF
#       END IF
#
        #No.TQC-750249 --start--
        IF lc_entry = "N" AND lc_is_key != "Y" AND ls_req_field != "Y" THEN
           CALL pnode_target.setAttribute("noEntry", "1")
        END IF
        #No.TQC-750249 ---end---
 
        CALL cl_setFieldText(pnode_target, pc_field_name, lc_text, lc_comment)
 
        CALL cl_get_change_text_node(pnode_target) RETURNING lnode_pre, li_bind_label
        IF li_bind_label THEN
           CALL cl_set_attribute("text", lnode_pre, lc_text)
        END IF
 
        #No.FUN-710055 --start--  #No.FUN-7B0080 更改為自定義欄位使用
        #以下若無開啟自定義欄位則不設定
        IF mi_open_userdefined OR mc_frm_name = "p_per_prog_chk" THEN  #No.FUN-760072 #No.FUN-7B0080
           #得到關聯欄位節點
           IF NOT cl_null(lc_reference) THEN
              CALL cl_get_reference(pnode_target,lc_reference) RETURNING lnode_next
              IF lnode_next IS NOT NULL THEN
                 LET lnode_nextchild = lnode_next.getFirstChild()
              END IF
           END IF
 
           #設定較單純的欄位寬度、起點、列數
           IF NOT cl_null(li_width) AND li_width > 0 THEN
              LET ls_width = li_width
              IF ls_width.getIndexOf(".",1) > 0 THEN
                 LET ls_width = ls_width.subString(1,ls_width.getIndexOf(".",1)-1)
              END IF
              CALL cl_set_attribute("width",lnode_child,ls_width)
              CALL cl_set_attribute("gridWidth",lnode_child,ls_width)
           END IF
           IF NOT cl_null(li_posX) AND li_posX > 0 THEN
              LET ls_posX = li_posX
              IF ls_posX.getIndexOf(".",1) > 0 THEN
                 LET ls_posX = ls_posX.subString(1,ls_posX.getIndexOf(".",1)-1)
              END IF
              LET ls_old_posX = lnode_child.getAttribute("posX")
              CALL cl_set_attribute("posX",lnode_child,ls_posX)
              #欄位起點置換後，前LABEL也要換
              IF li_bind_label THEN
                 LET ls_pre_posX = lnode_pre.getAttribute("posX")
                 IF ls_posX-ls_old_posX+ls_pre_posX <= 0 THEN
                    CALL cl_set_attribute("posX",lnode_pre,"1")
                 ELSE
                    CALL cl_set_attribute("posX",lnode_pre,ls_posX-ls_old_posX+ls_pre_posX)
                 END IF
              END IF
           END IF
           IF NOT cl_null(li_posX_label) AND li_posX_label > 0 AND li_bind_label THEN   #No.CHI-930026
              LET ls_posX_label = li_posX_label
              IF ls_posX_label.getIndexOf(".",1) > 0 THEN
                 LET ls_posX_label = ls_posX_label.subString(1,ls_posX_label.getIndexOf(".",1)-1)
              END IF
              CALL cl_set_attribute("posX",lnode_pre,ls_posX_label)
           END IF
           IF NOT cl_null(li_posY) AND li_posY > 0 THEN
              LET ls_posY = li_posY-1
              IF ls_posY.getIndexOf(".",1) > 0 THEN
                 LET ls_posY = ls_posY.subString(1,ls_posY.getIndexOf(".",1)-1)
              END IF
              CALL cl_set_attribute("posY",lnode_child,ls_posY)
              #欄位列數置換後，前LABEL也要換
              IF li_bind_label THEN
                 CALL cl_set_attribute("posY",lnode_pre,ls_posY)
              END IF
           END IF
 
           #設定欄位輸入順序、必要欄位、default值
           IF NOT cl_null(li_tabIndex) AND li_tabIndex > 0 THEN
              LET ls_tabIndex = li_tabIndex
              IF ls_tabIndex.getIndexOf(".",1) > 0 THEN
                 LET ls_tabIndex = ls_tabIndex.subString(1,ls_tabIndex.getIndexOf(".",1)-1)
              END IF
              CALL cl_set_attribute("tabIndex",pnode_target,li_tabIndex)
           END IF
           IF NOT cl_null(ls_req_field) THEN
              CALL cl_setFieldRequired(pnode_target,lnode_child,ls_req_field)
           END IF
           IF NOT cl_null(lc_default) THEN
              CALL cl_set_attribute("defaultValue",pnode_target,lc_default)
           END IF
 
           #限制值更動為ComboBox,CheckBox及開窗功能會轉換元件
           IF lc_checkbox = "Y" THEN
              CALL cl_setFieldCheckBox(pnode_target,lnode_child,ls_child_tag,lc_text CLIPPED,lnode_pre,ls_posX) RETURNING pnode_target,lnode_child,lnode_pre
           END IF
           IF NOT cl_null(lc_limit) THEN
              CALL cl_replace_str(lc_limit,",","|") RETURNING lc_limit
              CALL cl_set_attribute("include",pnode_target,lc_limit)
              IF lc_combo_flag = "Y" AND NOT cl_null(lc_combo_str) THEN
                 CALL cl_setFieldComboBox(pnode_target,lnode_child,pc_field_name CLIPPED,lc_limit CLIPPED,lc_combo_str CLIPPED) RETURNING pnode_target,lnode_child
              END IF
           END IF
           IF NOT cl_null(lc_controlp) THEN
              CALL cl_setFieldControlp(pnode_target,lnode_child,ls_child_tag) RETURNING pnode_target,lnode_child
           END IF
 
           #切換page或group所在位置會更動元件
           IF NOT cl_null(lc_pagename) THEN
              CALL cl_setFieldPage(pnode_target,lnode_child,li_bind_label,lnode_pre,lc_pagename CLIPPED) RETURNING pnode_target,lnode_child
           END IF
 
           #增加reference欄位
           IF NOT cl_null(lc_auto_refer) AND lc_auto_refer = "Y" AND
              NOT cl_null(lc_refer_name) THEN
              LET ls_posX_refer = li_posX_refer
              IF ls_posX_refer.getIndexOf(".",1) > 0 THEN
                 LET ls_posX_refer = ls_posX_refer.subString(1,ls_posX_refer.getIndexOf(".",1)-1)
              END IF
              CALL cl_addReferenceField(pnode_target,lc_refer_name CLIPPED,ls_posX_refer,ls_posY) RETURNING pnode_target
           END IF
        END IF
 
        IF NOT cl_null(lc_btn) THEN
           LET ls_posX = li_posX - 1    #No.FUN-760072
           IF ls_posX.getIndexOf(".",1) > 0 THEN
              LET ls_posX = ls_posX.subString(1,ls_posX.getIndexOf(".",1)-1)
           END IF
           LET ls_posY = li_posY-1
           IF ls_posY.getIndexOf(".",1) > 0 THEN
              LET ls_posY = ls_posY.subString(1,ls_posY.getIndexOf(".",1)-1)
           END IF
           CALL cl_setButton(pnode_target,lc_btn CLIPPED,ls_posX,ls_posY) RETURNING pnode_target
        END IF
        #No.FUN-710055 ---end---
 
        CALL cl_setKeyFieldHint(pnode_target, lc_is_key)
--#
 
--Setting text of "Button", "Group" and "Page" node
--2004/01/28 by Hiko : 此類原件並非輸入原件,因此不需要權限控制.
     WHEN "Button" 
        CALL cl_set_attribute("text", pnode_target, lc_text) 
        CALL cl_set_attribute("comment", pnode_target, lc_comment)   #No.FUN-570225
     WHEN "Group"
        CALL cl_set_attribute("text", pnode_target, lc_text) 
     WHEN "Page"
        CALL cl_set_attribute("text", pnode_target, lc_text) 
--#
 
--Setting text of "TableColumn"
     WHEN "TableColumn"
#
#       IF NOT cl_chk_auth(MI_ENTRY, lc_entry, pc_field_name) THEN
#          CALL pnode_target.setAttribute("noEntry", "1")
#
#          IF (ms_noentry_fields IS NULL) THEN
#             LET ms_noentry_fields = pc_field_name CLIPPED
#          ELSE
#             LET ms_noentry_fields = ms_noentry_fields || "," || pc_field_name
#          END IF
#       END IF
#
        #No.TQC-750249 --start--
        IF lc_entry = "N" AND lc_is_key != "Y" AND ls_req_field != "Y" THEN
           CALL pnode_target.setAttribute("noEntry", "1")
        END IF
        #No.TQC-750249 ---end---
 
        CALL cl_setFieldText(pnode_target, pc_field_name, lc_text, lc_comment)
 
        CALL cl_set_attribute("text", pnode_target, lc_text) 
 
        #No.FUN-710055 --start--
#最後再處理
#       CALL cl_setKeyFieldHint(pnode_target, lc_is_key)
 
#動態更換必要輸入欄位後再設定
--2004/03/03 by saki : 若<TableColumn>為required,則在title按右鍵不可讓欄位隱藏
#       LET ls_notNull = pnode_target.getAttribute("notNull")
#       LET ls_required = pnode_target.getAttribute("required")
#       IF ( ( NOT cl_null(ls_notNull) ) AND ( ls_notNull = "1" ) ) OR
#          ( ( NOT cl_null(ls_required) ) AND ( ls_required = "1") ) THEN
#          CALL pnode_target.setAttribute("unhidable", "1")
#       END IF
--#
 
        #No.FUN-7B0080 更改為自定義欄位開啟時才做設定
        IF mi_open_userdefined OR mc_frm_name = "p_per_prog_chk" THEN   #No.FUN-760072 #No.FUN-7B0080
           #設定較單純的欄位寬度、必要欄位、default值
           IF NOT cl_null(li_width) AND li_width > 0 THEN
              LET ls_width = li_width
              IF ls_width.getIndexOf(".",1) > 0 THEN
                 LET ls_width = ls_width.subString(1,ls_width.getIndexOf(".",1)-1)
              END IF
              CALL cl_set_attribute("width",lnode_child,li_width)
           END IF
           IF NOT cl_null(lc_default) THEN
              CALL cl_set_attribute("defaultValue",pnode_target,lc_default)
           END IF
        END IF   #No.TQC-910010
 
        #No.TQC-910010 --start-- 此設定不只用於自定義欄位
        IF NOT cl_null(ls_req_field) THEN
           CALL cl_setFieldRequired(pnode_target,lnode_child,ls_req_field)
        END IF
        #最終設定後,再變換欄位是否提供隱藏功能
        LET ls_notNull = pnode_target.getAttribute("notNull")
        LET ls_required = pnode_target.getAttribute("required")
        IF ( ( NOT cl_null(ls_notNull) ) AND ( ls_notNull = "1" ) ) OR
           ( ( NOT cl_null(ls_required) ) AND ( ls_required = "1") ) THEN
           CALL pnode_target.setAttribute("unhidable", "1")
        END IF
        #No.TQC-910010 ---end---
 
        IF mi_open_userdefined OR mc_frm_name = "p_per_prog_chk" THEN   #No.TQC-910010
           #限制值更動為ComboBox及開窗功能會轉換元件,最後處理
           IF lc_checkbox = "Y" THEN
              CALL cl_setFieldCheckBox(pnode_target,lnode_child,ls_child_tag,lc_text CLIPPED,lnode_pre,ls_posX) RETURNING pnode_target,lnode_child,lnode_pre
           END IF
           IF NOT cl_null(lc_limit) THEN
              CALL cl_replace_str(lc_limit,",","|") RETURNING lc_limit
              CALL cl_set_attribute("include",pnode_target,lc_limit)
              IF lc_combo_flag = "Y" AND NOT cl_null(lc_combo_str) THEN
                 CALL cl_setFieldComboBox(pnode_target,lnode_child,pc_field_name CLIPPED,lc_limit CLIPPED,lc_combo_str CLIPPED) RETURNING pnode_target,lnode_child
              END IF
           END IF
           IF NOT cl_null(lc_controlp) THEN
              CALL cl_setFieldControlp(pnode_target,lnode_child,ls_child_tag) RETURNING pnode_target,lnode_child
           END IF
        END IF
        #No.FUN-710055 ---end---
 
        #No.FUN-760049 --start-- 搬移位置, 串查程式與行業別無關
        IF NOT cl_null(lc_btn) THEN
           LET mi_btnb_flag = TRUE
        END IF
        #No.FUN-760049 ---end---
 
        CALL cl_setKeyFieldHint(pnode_target, lc_is_key)
--#
 
  END CASE
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 取得要改變文字的節點
# Date & Author..: 
# Input Parameter: pnode_target    om.DomNode   Parent Node
# Return code....: lnode_pre       om.DomNode
#                  li_bind_label
# Usage..........: CALL cl_get_change_text_node(pnode_target) RETURNING lnode_pre, li_bind_label
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_get_change_text_node(pnode_target)
  DEFINE pnode_target    om.DomNode
  DEFINE lnode_pre       om.DomNode
  DEFINE lnode_child     om.DomNode
  DEFINE li_bind_label   LIKE type_file.num5    #No.FUN-690005 SMALLINT
  DEFINE ls_tmp          STRING   #FUN-A10029 
 
  LET li_bind_label = FALSE
  IF pnode_target.getTagName() = "Button" THEN   #TQC-5A0006
     RETURN pnode_target, li_bind_label
  END IF
 
  LET lnode_pre = pnode_target.getPrevious()
  LET lnode_child = pnode_target.getFirstChild()
 
  IF lnode_child.getTagName() = "CheckBox" THEN
     RETURN lnode_pre, li_bind_label
  END IF
   
--Getting related "Label" node for this element
  IF lnode_pre IS NOT NULL THEN 
     IF ( lnode_pre.getTagName() = "Label" ) THEN          #FUN-A10029
        LET ls_tmp = lnode_pre.getAttribute("name")        #FOR Genero Form 2.20.06
        LET ls_tmp = ls_tmp.toUpperCase()
        IF ls_tmp.getLength() <= 5 OR NOT ls_tmp.subString(1,5) = "DUMMY" THEN
#       ( cl_null(lnode_pre.getAttribute("name")) ) THEN
           LET li_bind_label = TRUE
        END IF
     #No.FUN-710055 --start-- for欄位前會有串聯程式功能的button處理
     ELSE
        IF lnode_pre.getTagName() = "Button" AND lnode_pre.getAttribute("tag") = "+" THEN
           LET lnode_pre = lnode_pre.getPrevious()
           IF lnode_pre IS NOT NULL THEN
              IF ( lnode_pre.getTagName() = "Label" ) AND
                 ( cl_null(lnode_pre.getAttribute("name")) ) THEN
                 LET li_bind_label = TRUE
              END IF
           END IF
        END IF
     #No.FUN-710055 ---end---
     END IF
  END IF
--#
 
  RETURN lnode_pre, li_bind_label
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Setting text for child field of this element
# Date & Author..: 2004/04/02 by Brendan
# Input Parameter: pnode_target    om.DomNode   Parent Node
#                  pc_field_name   VARCHAR(10)     Field Name
#                  ps_text         STRING       Text for description
#                  ps_comment      STRING       Text for Comments
# Return code....: none
# Usage..........: CALL cl_setFieldText(pnode_parent, pc_field_name, ps_text, ps_comment)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldText(pnode_parent, pc_field_name, ps_text, ps_comment)
  DEFINE pnode_parent   om.DomNode,
         pc_field_name  LIKE gae_file.gae02,
         ps_text        STRING,
         ps_comment     STRING
  DEFINE lnode_child    om.DomNode  
  DEFINE ls_tagName     STRING
  DEFINE llist_item     om.NodeList
  DEFINE lnode_item     om.DomNode
  DEFINE li_i           LIKE type_file.num10   #No.FUN-690005 INTEGER
 
 
  LET lnode_child = pnode_parent.getFirstChild()
  LET ls_tagName = lnode_child.getTagName()
 
--Process child node for this element
  CASE
       WHEN ( ls_tagName = "ComboBox" ) OR
            ( ls_tagName = "RadioGroup" )
            LET llist_item = lnode_child.selectbyTagName("Item")
            FOR li_i = 1 TO llist_item.getLength()
                LET lnode_item = llist_item.item(li_i)
                CALL cl_setItemText( lnode_item, pc_field_name CLIPPED || '_' || lnode_item.getAttribute("name") )
            END FOR
 
            CALL cl_set_attribute("comment", lnode_child, ps_comment) 
 
       WHEN ( ls_tagName = "Edit" ) OR 
            ( ls_tagName = "TextEdit" ) OR 
            ( ls_tagName = "DateEdit" ) OR
            ( ls_tagName = "ButtonEdit" )
            CALL cl_set_attribute("comment", lnode_child, ps_comment) 
 
       WHEN ls_tagName = "CheckBox"
            IF pnode_parent.getTagName() != "TableColumn" THEN
               CALL cl_set_attribute("text", lnode_child, ps_text)
            END IF
            CALL cl_set_attribute("comment", lnode_child, ps_comment) 
  END CASE
--#
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Setting text of items for RadioGroup & ComboBox
# Date & Author..: 2004/04/02 by Brendan
# Input Parameter: pnode_item      om.DomNode   Item Node
#                  pc_field_name   VARCHAR(1)      Field Name
# Return code....: none
# Usage..........: CALL cl_setItemText(pnode_item, pc_field_name)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setItemText(pnode_item, pc_field_name)
  DEFINE pnode_item      om.DomNode,
         pc_field_name   LIKE gae_file.gae02  
  DEFINE lc_text         LIKE gae_file.gae04
  DEFINE lst_token       base.StringTokenizer
  DEFINE ls_token        STRING
 
 
#  SELECT gae04 INTO lc_text FROM gae_file, OUTER gav_file
  SELECT gae04 INTO lc_text 
    FROM gae_file LEFT OUTER JOIN gav_file ON gae01 = gav01 AND gae02 = gav02 AND gae11 = gav08 AND gae12 = gav11  #No.FUN-710055
   WHERE gae01 = mc_frm_name AND gae02 = pc_field_name
     AND gae03 = g_lang
     AND gae11 = mc_cust_flag                   # MOD-4A0261 No.FUN-710055
     AND gae12 = g_ui_setting                   # No.FUN-710055
 
  IF SQLCA.SQLCODE THEN
     RETURN
  END IF
 
--Setting text of item for RadioGroup & ComboBox
--2004/02/17 by Hiko : 為了能夠更清楚的顯現選擇的資料,因此在ComboBox與RadioGroup的顯現部分加上其儲存值.
  IF NOT cl_null(lc_text) THEN
     IF g_show_item_value THEN
        LET lst_token = base.StringTokenizer.create(pc_field_name, "_")
        WHILE lst_token.hasMoreTokens()
            LET ls_token = lst_token.nextToken()
        END WHILE
 
        LET lc_text = ls_token CLIPPED, ":", lc_text
     END IF
 
     CALL cl_set_attribute("text", pnode_item, lc_text) 
   END IF
--#
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Setting specific color for important field
# Date & Author..: 004/04/02 by Brendan
# Input Parameter: pnode_parent om.DomNode   Parent Node
# Return code....: none
# Usage..........: CALL cl_setKeyFieldHint(pnode_parent, ps_is_key)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setKeyFieldHint(pnode_parent, ps_is_key)
  DEFINE pnode_parent   om.DomNode,
         ps_is_key      STRING
  DEFINE lnode_child    om.DomNode
  DEFINE ls_tagName     STRING
 
 
  LET lnode_child = pnode_parent.getFirstChild()
  LET ls_tagName = lnode_child.getTagName()
 
  IF ps_is_key CLIPPED = 'Y' THEN
     IF (ls_tagName = "Edit") OR
        (ls_tagName = "ButtonEdit") OR
        (ls_tagName = "ComboBox") OR
        (ls_tagName = "DateEdit") OR
        (ls_tagName = "TextEdit") THEN
        #No.FUN-710055 --start--   demo中
#       CALL cl_set_attribute("color", lnode_child, g_gas.gas04)
#       CALL cl_set_attribute("reverse", lnode_child,"1")  #MOD-590433
        CALL cl_set_attribute("style",lnode_child,"inputbgcolor_"||g_gas.gas04 CLIPPED)
        #No.FUN-710055 ---end---
     END IF
  END IF
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 設定節點的屬性值
# Date & Author..: 2003/08/18 by Hiko
# Input Parameter: ps_type      STRING       屬性型態
#                  pnode_target om.DomNode   目標節點
#                  ps_value     STRING       要設定的屬性值
# Return code....: none
# Usage..........: 
# Memo...........:
# Modify.........: 04/03/31 by Brendan
##################################################
FUNCTION cl_set_attribute(ps_type, pnode_target, ps_value)
  DEFINE ps_type        STRING,
         pnode_target   om.DomNode,
         ps_value       STRING
 
  IF NOT cl_null(ps_value) THEN
     CALL pnode_target.setAttribute(ps_type, ps_value CLIPPED)
  END IF
END FUNCTION
 
 
# Descriptions...: 檢查欄位所對應的權限之顯現/輸入的設定.
# Date & Author..: 2003/07/01 by Hiko
# Input Parameter: pi_chk_type      SMALLINT   要判斷的設定別
#                  ps_default_value STRING     屬性預設值
#                  pc_field_name    VARCHAR(20)   欄位名稱
# Return Code....: SMALLINT 是否顯現/是否可輸入
# Modify.........: 04/03/31 by Brendan
 
FUNCTION cl_chk_auth(pi_chk_type, ps_default_value, pc_field_name)
  DEFINE pi_chk_type        LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
         ps_default_value   STRING,
         pc_field_name      LIKE gaj_file.gaj02
  DEFINE ls_sql             STRING
  DEFINE ls_fields          STRING
  DEFINE li_default_value   LIKE type_file.num10   #No.FUN-690005 INTEGER
  DEFINE lr_gaj             RECORD
                               class_plus    LIKE gaj_file.gaj03,
                               class_minus   LIKE gaj_file.gaj04,
                               usr_plus      LIKE gaj_file.gaj05,
                               usr_minus     LIKE gaj_file.gaj06,
                               data_hide     LIKE gaj_file.gaj12  #FUN-8C0139
                            END RECORD
 
  # 2003/07/02 Hiko 如果gav03/gav04無資料,則預設為顯現/可輸入(Y).
  # 2004/03/06 hjwang 改變 table schema 定義 
 
  IF ( ps_default_value = 'Y') OR ( cl_null(ps_default_value) ) THEN
     LET li_default_value = TRUE
  ELSE
     LET li_default_value = FALSE
  END IF
 
  CASE pi_chk_type
       WHEN MI_VISIBLE # 判斷是否要隱藏的設定
            LET ls_fields = "gaj03,gaj04,gaj05,gaj06,gaj12" #FUN-8C0139
       WHEN MI_ENTRY   # 判斷是否可輸入的設定
            LET ls_fields = "gaj07,gaj08,gaj09,gaj10"
  END CASE
 
  LET ls_sql = "SELECT ", ls_fields CLIPPED, " FROM gaj_file", 
               " WHERE gaj01 = ? AND gaj02 = ? ",
               " AND gaj11 = ?"                                        ##No.FUN-A80084 加入gaj11當key
          

  PREPARE lcurs_gaj_pre FROM ls_sql
  EXECUTE lcurs_gaj_pre USING mc_frm_name, pc_field_name, g_ui_setting #No.FUN-A80084 
     INTO lr_gaj.*
 
  IF SQLCA.SQLCODE THEN
     RETURN li_default_value
  END IF
 
  IF li_default_value THEN
     # 處理class反向
    #IF lr_gaj.class_minus IS NOT NULL THEN    #No.MOD-840618 mark
     IF NOT cl_null(lr_gaj.class_minus)THEN    #No.MOD-840618
        IF cl_chk_class_auth(lr_gaj.class_minus) THEN
           # exist GROUP(-) and USER(+)
           LET li_default_value = FALSE
           # 處理user正向
          #IF lr_gaj.usr_plus IS NOT NULL THEN   #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_plus)THEN   #No.MOD-840618
              IF cl_chk_user_auth(lr_gaj.usr_plus) THEN
                 LET li_default_value = TRUE
              END IF
           END IF
        ELSE
           # 2004/08/03 by saki : not exist GROUP(-) but exist USER(-)
          #IF lr_gaj.usr_minus IS NOT NULL THEN    #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_minus)THEN    #No.MOD-840618
              IF cl_chk_user_auth(lr_gaj.usr_minus) THEN
                 LET li_default_value = FALSE
              END IF
           END IF
        END IF
     ELSE
        #2004/08/03 by saki
       #IF lr_gaj.class_plus IS NOT NULL THEN    #No.MOD-840618 mark
        IF NOT cl_null(lr_gaj.class_plus)THEN    #No.MOD-840618
           IF cl_chk_class_auth(lr_gaj.class_plus) THEN
              # exist GROUP(+) and USER(-)
              # 處理user反向
             #IF lr_gaj.usr_minus IS NOT NULL THEN  #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_minus)THEN  #No.MOD-840618
                 IF cl_chk_user_auth(lr_gaj.usr_minus) THEN
                    LET li_default_value = FALSE
                 END IF
              END IF
           ELSE
              # not exist GROUP(+)
              LET li_default_value = FALSE
             #IF lr_gaj.usr_plus IS NOT NULL THEN   #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_plus)THEN   #No.MOD-840618
                 IF cl_chk_user_auth(lr_gaj.usr_plus) THEN
                    # not exist GROUP(+) but exist USER(+)
                    LET li_default_value = TRUE
                 END IF
              END IF
           END IF
        ELSE
           # not exist GROUP(+) and GROUP(-)
          #IF lr_gaj.usr_plus IS NOT NULL THEN    #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_plus)THEN    #No.MOD-840618
              # not exist USER(+)
              IF NOT cl_chk_user_auth(lr_gaj.usr_plus) THEN
                 LET li_default_value = FALSE
              END IF
           ELSE
             #IF lr_gaj.usr_minus IS NOT NULL THEN  #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_minus)THEN  #No.MOD-840618 
              # exist USER(-)
                 IF cl_chk_user_auth(lr_gaj.usr_minus) THEN
                    LET li_default_value = FALSE
                 END IF
              END IF
           END IF
        END IF
     END IF
  ELSE
     # 處理class正向
    #IF lr_gaj.class_plus IS NOT NULL THEN   #No.MOD-840618 mark
     IF NOT cl_null(lr_gaj.class_plus)THEN   #No.MOD-840618
        IF cl_chk_class_auth(lr_gaj.class_plus) THEN
           LET li_default_value = TRUE
           # 處理user反向
          #IF lr_gaj.usr_minus IS NOT NULL THEN   #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_minus)THEN   #No.MOD-840618
              IF cl_chk_user_auth(lr_gaj.usr_minus) THEN
                 LET li_default_value = FALSE
              END IF
           END IF
        ELSE
           # 2004/08/03 by saki : not exist GROUP(+) but exist USER(+)
          #IF lr_gaj.usr_plus IS NOT NULL THEN  #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_plus)THEN  #No.MOD-840618
              IF cl_chk_user_auth(lr_gaj.usr_plus) THEN
                 LET lI_default_value = TRUE
              END IF
           END IF
        END IF
     ELSE
        #2004/08/03 by saki
       #IF lr_gaj.class_minus IS NOT NULL THEN   #No.MOD-840618 mark
        IF NOT cl_null(lr_gaj.class_minus)THEN   #No.MOD-840618
           IF cl_chk_class_auth(lr_gaj.class_minus) THEN
              # 處理user正向 : exist GROUP(-) and USER(+)
             #IF lr_gaj.usr_plus IS NOT NULL THEN    #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_plus)THEN    #no.MOD-840618
                 IF cl_chk_user_auth(lr_gaj.usr_plus) THEN
                    LET li_default_value = TRUE
                 END IF
              END IF
           ELSE
              # not exist GROUP(-)
              LET li_default_value = TRUE
             #IF lr_gaj.usr_minus IS NOT NULL THEN    #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_minus)THEN    #No.MOD-840618
                 # but exist USER(-)
                 IF cl_chk_user_auth(lr_gaj.usr_minus) THEN
                    LET li_default_value = FALSE
                 END IF
              END IF
           END IF
        ELSE
           # not exist GROUP(+) and GROUP(-)
          #IF lr_gaj.usr_plus IS NOT NULL THEN    #No.MOD-840618 mark
           IF NOT cl_null(lr_gaj.usr_plus)THEN    #No.MOD-840618
              # exist USER(+)
              IF cl_chk_user_auth(lr_gaj.usr_plus) THEN
                 LET li_default_value = TRUE
              END IF
           ELSE
             #IF lr_gaj.usr_minus IS NOT NULL THEN   #No.MOD-840618 mark
              IF NOT cl_null(lr_gaj.usr_minus)THEN   #No.MOD-840618
              # not exist USER(-)
                 IF NOT cl_chk_user_auth(lr_gaj.usr_minus) THEN
                    LET li_default_value = TRUE
                 END IF
              END IF
           END IF
        END IF
     END IF
  END IF
 
  #FUN-8C0139 --start
  IF lr_gaj.data_hide = "Y" AND li_default_value = FALSE THEN
     LET ms_field_passwd = "Y"
  END IF
  #FUN-8C0139 --end
 
  RETURN li_default_value
END FUNCTION
 
 
# Descriptions...: 檢查使用者類別的權限.
# Date & Author..: 2003/06/27 by Hiko
# Input Parameter: ps_class STRING 類別字串(以pipe分隔)
# Return Code....: SMALLINT 是否有設定權限
# Modify.........: 04/03/31 by Brendan
 
FUNCTION cl_chk_class_auth(ps_class)
  DEFINE ps_class    STRING
  DEFINE li_result   LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE lst_class   base.StringTokenizer
  DEFINE ls_class    STRING
#-----------No.TQC-650047 add
  DEFINE l_sql       STRING
  DEFINE l_cnt       LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE l_zxw04     LIKE zxw_file.zxw04
#----------No.TQC-650047 end
 
 
  LET li_result = FALSE
  LET lst_class = base.StringTokenizer.create(ps_class.trim(), "|")
 
#-----------No.TQC-650047 add-----------------
#增加判斷p_zxw中的權限類別
  LET l_sql = " SELECT zxw04 FROM zxw_file ",
              " WHERE zxw01 ='",g_user CLIPPED,"'",
              " AND zxw03 = '1' "
  PREPARE l_clas_pb FROM l_sql
  DECLARE l_class_curs CURSOR FOR l_clas_pb
  FOREACH l_class_curs INTO l_zxw04
     IF STATUS THEN
        EXIT FOREACH
     END IF
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM zy_file 
        WHERE zy01 = l_zxw04 AND zy02 = mc_frm_name
     IF l_cnt > 0 THEN
        LET lst_class = base.StringTokenizer.create(ps_class.trim(), "|")
        WHILE lst_class.hasMoreTokens()
            LET ls_class = lst_class.nextToken()
            LET ls_class = ls_class.trim()
 
            IF ls_class = l_zxw04 THEN
               LET li_result = TRUE
               EXIT WHILE
            ELSE
               LET li_result = FALSE
            END IF
         END WHILE
         IF NOT li_result THEN
            RETURN li_result
         END IF
      END IF
 
  END FOREACH  
#-----------No.TQC-650047 end-----------------
 
  WHILE lst_class.hasMoreTokens()
      LET ls_class = lst_class.nextToken()
      LET ls_class = ls_class.trim()
 
      IF ls_class = g_clas CLIPPED THEN
         LET li_result = TRUE
         EXIT WHILE
      END IF
  END WHILE
 
  RETURN li_result
END FUNCTION
 
 
# Descriptions...: 檢查使用者的權限.
# Date & Author..: 2003/06/27 by Hiko
# Input Parameter: ps_users STRING 使用者字串(以pipe分隔)
# Return Code....: SMALLINT 是否有設定權限
# Modify.........: 04/03/31 by Brendan
 
FUNCTION cl_chk_user_auth(ps_users)
  DEFINE ps_users    STRING
  DEFINE li_result   LIKE type_file.num5          #No.FUN-690005 SMALLINT
  DEFINE lst_users   base.StringTokenizer
  DEFINE ls_user     STRING
 
 
  LET li_result = FALSE
  LET lst_users = base.StringTokenizer.create(ps_users.trim(), "|")
 
  WHILE lst_users.hasMoreTokens()
      LET ls_user = lst_users.nextToken()
      LET ls_user = ls_user.trim()
 
      IF ls_user = g_user CLIPPED THEN
         LET li_result = TRUE
         EXIT WHILE
      END IF
  END WHILE
 
  RETURN li_result
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 回傳預設為NOENTRY的欄位字串.
# Date & Author..: 2003/10/06 by Hiko
# Input Parameter: none
# Return code....: STRING
# Usage..........: 
# Memo...........: cl_set_comp_entry.4gl專用FUNCTION
# Modify.........: 
##################################################
FUNCTION cl_get_noentry_fields()
   RETURN ms_noentry_fields
END FUNCTION
 
#No.FUN-710055 --start--
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 擷取有設定關聯的reference節點
# Date & Author..: 2006/12/31 by saki
# Input Parameter: pnode_target     欄位節點-FormField
#                  ls_reference     reference欄位名稱
# Return code....: om.DomNode       關聯欄位節點
# Usage..........: CALL cl_get_reference(pnode_target,lc_reference) RETURNING lnode_next
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_get_reference(pnode_target,ls_reference)
   DEFINE   pnode_target om.DomNode
   DEFINE   ls_reference STRING
   DEFINE   lnode_next   om.DomNode
   DEFINE   ls_item_name STRING
 
   LET lnode_next = pnode_target.getNext()
   IF lnode_next IS NOT NULL THEN
      LET ls_item_name = lnode_next.getAttribute("colname")
      IF ls_item_name IS NULL THEN
         LET ls_item_name = lnode_next.getAttribute("name")
      END IF
   END IF
   IF (ls_item_name = ls_reference) OR
      (ls_item_name.subString(10,ls_item_name.getLength()) = ls_reference) OR
      (ls_item_name = ls_reference.subString(10,ls_reference.getLength())) THEN
      RETURN lnode_next
   ELSE
      RETURN NULL
   END IF
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--CONTROLP
# Date & Author..: 2006/12/31 by saki
# Input Parameter: pnode_target     欄位節點-FormField,TableColumn
#                  lnode_child      元件節點-Edit...
#                  ls_child_tag     元件名稱-Edit...
# Return code....: om.DomNode       欄位節點
#                  om.DomNode       元件節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldControlp(pnode_target,lnode_child,ls_child_tag)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE lnode_child     om.DomNode             # 欄位的元件節點
   DEFINE ls_tag_name     STRING
   DEFINE ls_child_tag    STRING
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_valuelist om.DomNode             # TableColumn的valuelist節點
   #為了Edit與ButtonEdit互換,必須紀錄原有Attribute
   DEFINE lr_att1         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE lr_att2         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD

   LET lnode_parent = pnode_target.getParent()
 
   IF ls_child_tag = "Edit" THEN
      #先紀錄原本Node下面的所有Attribute
      FOR li_cnt = 1 TO pnode_target.getAttributesCount()
          LET lr_att1[li_cnt].att_name = pnode_target.getAttributeName(li_cnt)
          LET lr_att1[li_cnt].value    = pnode_target.getAttributeValue(li_cnt)
      END FOR
      LET ls_tag_name = pnode_target.getTagName()
      IF ls_tag_name = "TableColumn" THEN
         LET lnode_valuelist = pnode_target.getLastChild()
      END IF
      FOR li_cnt = 1 TO lnode_child.getAttributesCount()
          LET lr_att2[li_cnt].att_name = lnode_child.getAttributeName(li_cnt)
          LET lr_att2[li_cnt].value    = lnode_child.getAttributeValue(li_cnt)
      END FOR
      #紀錄原有欄位,插入新的欄位
      LET mr_del_node[mi_cnt] = pnode_target
      LET mi_cnt = mi_cnt + 1
      LET pnode_target = lnode_parent.createChild(ls_tag_name)
      FOR li_cnt = 1 TO lr_att1.getLength()
          CALL pnode_target.setAttribute(lr_att1[li_cnt].att_name,lr_att1[li_cnt].value)
      END FOR
      LET lnode_child = pnode_target.createChild("ButtonEdit")
      CALL cl_set_attribute("action",lnode_child,"controlp")
      CALL cl_set_attribute("image",lnode_child,"zoom")
      FOR li_cnt = 1 TO lr_att2.getLength()
          CALL lnode_child.setAttribute(lr_att2[li_cnt].att_name,lr_att2[li_cnt].value)
      END FOR
      IF ls_tag_name = "TableColumn" THEN
         CALL pnode_target.appendChild(lnode_valuelist)
      END IF
      CALL lnode_parent.insertBefore(pnode_target,mr_del_node[mi_cnt-1])
   END IF
   RETURN pnode_target,lnode_child
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--CheckBox
# Date & Author..: 2007/03/14 by saki
# Input Parameter: pnode_target     欄位節點-FormField,TableColumn
#                  lnode_child      元件節點-Edit...
#                  ls_child_tag     元件名稱-Edit...
#                  lc_text          顯示名稱
#                  lnode_pre        欄位前的Label元件
#                  li_posX_label    Label的起點
# Return code....: om.DomNode       欄位節點
#                  om.DomNode       元件節點
#                  om.DomNode       欄位前的Label節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldCheckBox(pnode_target,lnode_child,ls_child_tag,lc_text,lnode_pre,ls_posX_label)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE lnode_child     om.DomNode             # 欄位的元件節點
   DEFINE ls_tag_name     STRING
   DEFINE ls_child_tag    STRING
   DEFINE lc_text         LIKE gae_file.gae04
   DEFINE lnode_pre       om.DomNode
   DEFINE ls_posX_label   STRING
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_valuelist om.DomNode             # TableColumn的valuelist節點
   #為了Edit與ButtonEdit互換,必須紀錄原有Attribute
   DEFINE lr_att1         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE lr_att2         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
 
  LET lnode_parent = pnode_target.getParent()
 
   IF ls_child_tag = "Edit" THEN
      #先紀錄原本Node下面的所有Attribute
      FOR li_cnt = 1 TO pnode_target.getAttributesCount()
          LET lr_att1[li_cnt].att_name = pnode_target.getAttributeName(li_cnt)
          LET lr_att1[li_cnt].value    = pnode_target.getAttributeValue(li_cnt)
      END FOR
      LET ls_tag_name = pnode_target.getTagName()
      IF ls_tag_name = "TableColumn" THEN
         LET lnode_valuelist = pnode_target.getLastChild()
      END IF
      FOR li_cnt = 1 TO lnode_child.getAttributesCount()
          LET lr_att2[li_cnt].att_name = lnode_child.getAttributeName(li_cnt)
          LET lr_att2[li_cnt].value    = lnode_child.getAttributeValue(li_cnt)
      END FOR
      #紀錄原有欄位,插入新的欄位
      LET mr_del_node[mi_cnt] = pnode_target
      LET mi_cnt = mi_cnt + 1
      LET pnode_target = lnode_parent.createChild(ls_tag_name)
      FOR li_cnt = 1 TO lr_att1.getLength()
          CALL pnode_target.setAttribute(lr_att1[li_cnt].att_name,lr_att1[li_cnt].value)
      END FOR
      LET lnode_child = pnode_target.createChild("CheckBox")
      IF ls_tag_name = "FormField" THEN
         CALL cl_set_attribute("text",lnode_child,lc_text CLIPPED)
      END IF
      CALL cl_set_attribute("sizePolicy",lnode_child,"dynamic")
      CALL cl_set_attribute("valueChecked",lnode_child,"Y")
      CALL cl_set_attribute("valueUnchecked",lnode_child,"N")
      FOR li_cnt = 1 TO lr_att2.getLength()
          IF lr_att2[li_cnt].att_name != "scroll" THEN
             CALL lnode_child.setAttribute(lr_att2[li_cnt].att_name,lr_att2[li_cnt].value)
          END IF
      END FOR
      IF ls_tag_name = "FormField" THEN
         #設定posX跟原本label同位置
         CALL lnode_child.setAttribute("posX",ls_posX_label)
         #刪掉原本Edit欄位前的敘述
         LET mr_del_node[mi_cnt] = lnode_pre
         LET mi_cnt = mi_cnt + 1
         LET lnode_pre = NULL
      END IF
      IF ls_tag_name = "TableColumn" THEN
         CALL pnode_target.appendChild(lnode_valuelist)
      END IF
      CALL lnode_parent.insertBefore(pnode_target,mr_del_node[mi_cnt-1])
   END IF
   RETURN pnode_target,lnode_child,lnode_pre
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--改變page/group所在
# Date & Author..: 2006/12/31 by saki
# Input Parameter: pnode_target     欄位節點-FormField
#                  lnode_child      元件節點-Edit...
#                  ls_pagename      要改變到哪個節點下
# Return Code....: om.DomNode       欄位節點
#                  om.DomNode       元件節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldPage(pnode_target,lnode_child,pi_bind_label,pnode_pre,ls_pagename)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE lnode_child     om.DomNode             # 欄位的元件節點
   DEFINE pi_bind_label   LIKE type_file.num5    # 是否有前面的Label元件
   DEFINE pnode_pre       om.DomNode             # Label節點
   DEFINE ls_pagename     STRING
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE lnode_parent    om.DomNode             # 更動page的根節點
   DEFINE ls_pagetemp     STRING                 # 比較設定與目前的page/group有否一樣
   DEFINE ls_tag_name     STRING
   DEFINE ls_child_tag    STRING
   DEFINE li_cnt          LIKE type_file.num5
   #改變位置,必須紀錄原有節點Attribute
   DEFINE lr_att1         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE lr_att2         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE li_change       LIKE type_file.num5
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
 
   LET lnode_parent = pnode_target.getParent()
   WHILE lnode_parent IS NOT NULL
      #No.EXT-B60126 --start--
      LET ls_pagetemp = lnode_parent.getAttribute("name")
      IF ls_pagetemp.equals(ls_pagename) THEN
         EXIT WHILE
      END IF
      #No.EXT-B60126 ---end---
      IF lnode_parent.getTagName() = "Page" OR lnode_parent.getTagName() = "Group" THEN
         LET ls_pagetemp = lnode_parent.getAttribute("name")
         EXIT WHILE
      ELSE
         LET lnode_parent = lnode_parent.getParent()
      END IF
   END WHILE
   IF NOT ls_pagetemp.equals(ls_pagename) THEN
      LET lnode_parent = lfrm_curr.findNode("Page",ls_pagename)
      IF lnode_parent IS NULL THEN
         LET lnode_parent = lfrm_curr.findNode("Group",ls_pagename)
      END IF
      #No.EXT-B60126 --start--
      IF lnode_parent IS NULL THEN
         LET lnode_parent = lfrm_curr.findNode("Grid",ls_pagename)
      END IF
      #No.EXT-B60126 ---end---
      IF lnode_parent IS NOT NULL THEN
         IF lnode_parent.getTagName() = "Page" THEN
            LET lnode_parent = lnode_parent.getFirstChild()
            IF lnode_parent.getTagName() = "Grid" THEN
               LET li_change = TRUE
            END IF
         END IF
         IF lnode_parent.getTagName() = "Group" THEN
            LET lnode_parent = lnode_parent.getFirstChild()
            IF lnode_parent IS NOT NULL THEN
               IF lnode_parent.getTagName() = "Grid" THEN
                  LET li_change = TRUE
               ELSE
                  LET lnode_parent = lnode_parent.getParent()
                  LET li_change = TRUE
               END IF
            END IF
         END IF
         #No.EXT-B60126 --start--
         IF lnode_parent.getTagName() = "Grid" THEN
            LET li_change = TRUE
         END IF
         #No.EXT-B60126 ---end---
         IF li_change THEN
            IF pi_bind_label AND pnode_pre IS NOT NULL THEN
               #先紀錄Label Node下面的所有Attribute
               FOR li_cnt = 1 TO pnode_pre.getAttributesCount()
                   LET lr_att1[li_cnt].att_name = pnode_pre.getAttributeName(li_cnt)
                   LET lr_att1[li_cnt].value    = pnode_pre.getAttributeValue(li_cnt)
               END FOR
               LET ls_tag_name = pnode_pre.getTagName()
               #紀錄原有欄位,插入新的欄位
               LET mr_del_node[mi_cnt] = pnode_pre
               LET mi_cnt = mi_cnt + 1
               LET pnode_pre = lnode_parent.createChild(ls_tag_name)
               FOR li_cnt = 1 TO lr_att1.getLength()
                   CALL pnode_pre.setAttribute(lr_att1[li_cnt].att_name,lr_att1[li_cnt].value)
               END FOR
            END IF
            #先紀錄原本Node下面的所有Attribute
            FOR li_cnt = 1 TO pnode_target.getAttributesCount()
                LET lr_att1[li_cnt].att_name = pnode_target.getAttributeName(li_cnt)
                LET lr_att1[li_cnt].value    = pnode_target.getAttributeValue(li_cnt)
            END FOR
            LET ls_tag_name = pnode_target.getTagName()
            IF lnode_child IS NOT NULL THEN
               FOR li_cnt = 1 TO lnode_child.getAttributesCount()
                   LET lr_att2[li_cnt].att_name = lnode_child.getAttributeName(li_cnt)
                   LET lr_att2[li_cnt].value    = lnode_child.getAttributeValue(li_cnt)
               END FOR
               LET ls_child_tag = lnode_child.getTagName()
            END IF
            #紀錄原有欄位,插入新的欄位
            LET mr_del_node[mi_cnt] = pnode_target
            LET mi_cnt = mi_cnt + 1
            LET pnode_target = lnode_parent.createChild(ls_tag_name)
            FOR li_cnt = 1 TO lr_att1.getLength()
                CALL pnode_target.setAttribute(lr_att1[li_cnt].att_name,lr_att1[li_cnt].value)
            END FOR
            IF lnode_child IS NOT NULL THEN
               LET lnode_child = pnode_target.createChild(ls_child_tag)
               FOR li_cnt = 1 TO lr_att2.getLength()
                   CALL lnode_child.setAttribute(lr_att2[li_cnt].att_name,lr_att2[li_cnt].value)
               END FOR
            END IF
         END IF
      END IF
   END IF
   RETURN pnode_target,lnode_child
END FUNCTION

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--改變Required,notNull的值
# Date & Author..: 2006/12/31 by saki
# Input Parameter: pnode_target     欄位節點-FormField
#                  lnode_child      元件節點-Edit...
#                  ps_required      是否為必要欄位
# Return code....: none
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldRequired(pnode_target,lnode_child,ps_required)
   DEFINE   pnode_target   om.DomNode
   DEFINE   lnode_child    om.DomNode
   DEFINE   ps_required    STRING
   DEFINE   ls_required    STRING
   DEFINE   ls_notNull     STRING
 
   IF ps_required = "Y" THEN
      CALL cl_set_attribute("notNull",pnode_target,"1")
      CALL cl_set_attribute("required",pnode_target,"1")
      IF lnode_child.getTagName()="ButtonEdit" OR
         lnode_child.getTagName()="Edit" OR
         lnode_child.getTagName()="ComboBox" OR
         lnode_child.getTagName()="DateEdit" OR
         lnode_child.getTagName()="TextEdit" THEN
         CALL cl_requiredHint(lnode_child)
      END IF
   ELSE
      LET ls_notNull = pnode_target.getAttribute("notNull")
      LET ls_required = pnode_target.getAttribute("required")
      CALL cl_set_attribute("notNull",pnode_target,"0")
      CALL cl_set_attribute("required",pnode_target,"0")
      IF lnode_child IS NOT NULL THEN
         IF lnode_child.getTagName()="ButtonEdit" OR
            lnode_child.getTagName()="Edit" OR
            lnode_child.getTagName()="ComboBox" OR
            lnode_child.getTagName()="DateEdit" OR
            lnode_child.getTagName()="TextEdit" THEN
            IF ls_notNull AND ls_required THEN
               #No.FUN-710055 --start-- demo中
#              CALL lnode_child.removeAttribute("color")
#              CALL lnode_child.removeAttribute("reverse")
               CALL lnode_child.setAttribute("style","inputbgcolor_while")
               #No.FUN-710055 ---end---
            END IF
         END IF
      END IF
   END IF
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--限制值及改變成ComboBox選單
# Date & Author..: 2006/12/31 by saki
# Input Parameter: pnode_target     欄位節點-FormField,TableColumn
#                  lnode_child      元件節點-Edit...
#                  ps_field_name    欄位名稱
#                  ls_limit         限制值
#                  ls_combo_str     多語言選項值(p_ze設定代碼)
# Return Code....: om.DomNode       欄位節點
#                  om.DomNode       元件節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setFieldComboBox(pnode_target,lnode_child,ps_field_name,ls_limit,ls_combo_str)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE lnode_child     om.DomNode             # 欄位的元件節點
   DEFINE ps_field_name   STRING
   DEFINE ls_limit        STRING
   DEFINE ls_combo_str    STRING
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_valuelist om.DomNode             # TableColumn的valuelist節點
   DEFINE ls_tag_name     STRING
   DEFINE li_cnt          LIKE type_file.num5
   #為了Edit與ComboBox互換,必須紀錄原有Attribute
   DEFINE lr_att1         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE lr_att2         DYNAMIC ARRAY OF RECORD
             att_name     STRING,
             value        STRING
                          END RECORD
   DEFINE lcb_curr        ui.ComboBox
   DEFINE lst_values      base.StringTokenizer
   DEFINE lst_items       base.StringTokenizer
   DEFINE ls_sql          STRING
   DEFINE lc_ze01         LIKE ze_file.ze01
   DEFINE lc_ze03         LIKE ze_file.ze03
 
   LET lnode_parent = pnode_target.getParent()
 
   IF lnode_child.getTagName() = "Edit" THEN
      #先紀錄原本Node下面的所有Attribute
      FOR li_cnt = 1 TO pnode_target.getAttributesCount()
          LET lr_att1[li_cnt].att_name = pnode_target.getAttributeName(li_cnt)
          LET lr_att1[li_cnt].value    = pnode_target.getAttributeValue(li_cnt)
      END FOR
      LET ls_tag_name = pnode_target.getTagName()
      IF ls_tag_name = "TableColumn" THEN
         LET lnode_valuelist = pnode_target.getLastChild()
      END IF
      FOR li_cnt = 1 TO lnode_child.getAttributesCount()
          LET lr_att2[li_cnt].att_name = lnode_child.getAttributeName(li_cnt)
          LET lr_att2[li_cnt].value    = lnode_child.getAttributeValue(li_cnt)
      END FOR
      #換名字是因為等下要用field name找尋combobox節點
      CALL pnode_target.setAttribute("name",ps_field_name||"_old")
      CALL pnode_target.setAttribute("colName",ps_field_name||"_old")
      #紀錄原有欄位,插入新的欄位
      LET mr_del_node[mi_cnt] = pnode_target
      LET mi_cnt = mi_cnt + 1
      LET pnode_target = lnode_parent.createChild(ls_tag_name)
      FOR li_cnt = 1 TO lr_att1.getLength()
          CALL pnode_target.setAttribute(lr_att1[li_cnt].att_name,lr_att1[li_cnt].value)
      END FOR
      LET lnode_child = pnode_target.createChild("ComboBox")
      FOR li_cnt = 1 TO lr_att2.getLength()
          CALL lnode_child.setAttribute(lr_att2[li_cnt].att_name,lr_att2[li_cnt].value)
      END FOR
      CALL lnode_child.setAttribute("queryEditable","1")
      LET ls_sql = "SELECT ze03 FROM ze_file WHERE ze01=? AND ze02=?"
      PREPARE combostr_pre FROM ls_sql
      LET lcb_curr = ui.ComboBox.forName(ps_field_name)
      IF lcb_curr IS NOT NULL THEN
         LET lst_values = base.StringTokenizer.create(ls_limit, "|")
         LET lst_items = base.StringTokenizer.create(ls_combo_str, ",")
         WHILE lst_values.hasMoreTokens() AND lst_items.hasMoreTokens()
            LET lc_ze01 = lst_items.nextToken()
            LET lc_ze03 = ""
            EXECUTE combostr_pre INTO lc_ze03 USING lc_ze01,g_lang
            CALL lcb_curr.addItem(lst_values.nextToken(), lc_ze03 CLIPPED)
         END WHILE
      END IF
      IF ls_tag_name = "TableColumn" THEN
         CALL pnode_target.appendChild(lnode_valuelist)
      END IF
      CALL lnode_parent.insertBefore(pnode_target,mr_del_node[mi_cnt-1])
   END IF
   RETURN pnode_target,lnode_child
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--增加串查程式Button在欄位前
# Date & Author..: 2007/01/01 by saki
# Input Parameter: pnode_target     欄位節點-FormField,TableColumn
#                  pc_btn           串查的程式代碼
#                  ps_posX          欄位橫向起點
#                  ps_posY          欄位直向列數
# Return Code....: om.DomNode       欄位節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setButton(pnode_target,pc_btn,ps_posX,ps_posY)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE pc_btn          LIKE gav_file.gav32
   DEFINE ps_posX         STRING
   DEFINE ps_posY         STRING
   DEFINE lc_gaz03        LIKE gaz_file.gaz03
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_button    om.DomNode
   DEFINE ls_name         STRING
 
   SELECT gaz03 INTO lc_gaz03 FROM gaz_file WHERE gaz01=pc_btn AND gaz02=g_lang
 
   IF mi_btn_create_flag THEN
      LET lnode_button = pnode_target.getPrevious()
      CALL lnode_button.setAttribute("comment",lc_gaz03 CLIPPED||"["||pc_btn CLIPPED||"]")
      RETURN pnode_target
   END IF
 
   LET lnode_parent = pnode_target.getParent()
   LET lnode_button = lnode_parent.createChild("Button")
   CALL lnode_parent.insertBefore(lnode_button,pnode_target)
   LET ls_name = "btn_",mi_btn_sn USING '&&'
   CALL lnode_button.setAttribute("name",ls_name)
   CALL lnode_button.setAttribute("tag","+")
   CALL lnode_button.setAttribute("hidden","0")
   CALL lnode_button.setAttribute("image","qs")
   CALL lnode_button.setAttribute("comment",lc_gaz03 CLIPPED||"["||pc_btn CLIPPED||"]")
   IF ps_posX.getIndexOf(".",1) > 0 THEN
      LET ps_posX = ps_posX.subString(1,ps_posX.getIndexOf(".",1)-1)
   END IF
   CALL lnode_button.setAttribute("posX",ps_posX)
   CALL lnode_button.setAttribute("posY",ps_posY)
   CALL lnode_button.setAttribute("sizePolicy","initial")
   LET mi_btn_sn = mi_btn_sn + 1
   RETURN pnode_target
END FUNCTION

# Private Func...: TRUE
# Descriptions...:
# Input Parameter: 
# Return Code....: 
# Memo...........: 另外一種Button模式，留下供參考，目前不使用
FUNCTION cl_setButton2(pnode_target,pc_btn,ps_posX,ps_posY,ps_text)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE pc_btn          LIKE gav_file.gav32
   DEFINE ps_posX         STRING
   DEFINE ps_posY         STRING
   DEFINE ps_text         STRING
   DEFINE lc_gaz03        LIKE gaz_file.gaz03
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_button    om.DomNode
   DEFINE ls_name         STRING
 
   SELECT gaz03 INTO lc_gaz03 FROM gaz_file WHERE gaz01=pc_btn AND gaz02=g_lang
 
   IF mi_btn_create_flag THEN
      LET lnode_button = pnode_target.getPrevious()
      CALL lnode_button.setAttribute("comment",lc_gaz03 CLIPPED||"["||pc_btn CLIPPED||"]")
      RETURN pnode_target
   END IF
 
   LET lnode_parent = pnode_target.getParent()
   LET lnode_button = lnode_parent.createChild("Button")
   CALL lnode_parent.insertBefore(lnode_button,pnode_target)
   LET ls_name = "btn_",mi_btn_sn USING '&&'
   CALL lnode_button.setAttribute("name",ls_name)
   CALL lnode_button.setAttribute("tag","+")
   CALL lnode_button.setAttribute("hidden","0")
   CALL lnode_button.setAttribute("text",ps_text)
   CALL lnode_button.setAttribute("comment",lc_gaz03 CLIPPED||"["||pc_btn CLIPPED||"]")
   CALL lnode_button.setAttribute("posX",ps_posX)
   CALL lnode_button.setAttribute("posY",ps_posY)
   CALL lnode_button.setAttribute("style","connect")
   CALL lnode_button.setAttribute("sizePolicy","initial")
   LET mi_btn_sn = mi_btn_sn + 1
   RETURN pnode_target
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 自動產生單身串查Button
# Date & Author..: 07/06/26 By saki
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_detail_setButton()
# Memo...........:
# Modify.........: 
##################################################
#No.FUN-760072 --start-- 自動產生單身串查Button
FUNCTION cl_detail_setButton()
   DEFINE   li_i           LIKE type_file.num5
   DEFINE   lnode_parent   om.DomNode
   DEFINE   lnode_last     om.DomNode
   DEFINE   lnode_button   om.DomNode
 
   #No.FUN-770104 --start--
   IF NOT mi_table_flag THEN
      RETURN
   END IF
   #No.FUN-770104 ---end---
 
   FOR li_i = 1 TO mr_cntnode.getLength()
       IF mr_cntnode[li_i] IS NULL THEN
          CONTINUE FOR
       END IF
       LET lnode_parent = mr_cntnode[li_i].getParent()
       LET lnode_last = lnode_parent.getLastChild()
       LET lnode_button = lnode_parent.createChild("Button")
       CALL lnode_parent.appendChild(lnode_button)
       CALL lnode_button.setAttribute("name","btn_detail")
       CALL lnode_button.setAttribute("tag","+")
       CALL lnode_button.setAttribute("hidden","0")
       CALL lnode_button.setAttribute("image","qs")
       CALL lnode_button.setAttribute("posY",lnode_last.getAttribute("posY"))
       CALL lnode_button.setAttribute("sizePolicy","initial")
       EXIT FOR
   END FOR
END FUNCTION
#No.FUN-760072 ---end---
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 改變p_per中UI設定--增加關聯欄位在欄位後
# Date & Author..: 2007/03/19 by saki
# Input Parameter: pnode_target     欄位節點-FormField,TableColumn
#                  pc_refer_fld     關聯欄位名稱
#                  ps_posX_refer    關聯欄位橫向起點
#                  ps_posY          欄位直向列數
# Return Code....: om.DomNode       欄位節點
# Usage..........: 
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_addReferenceField(pnode_target,pc_refer_fld,ps_posX_refer,ps_posY)
   DEFINE pnode_target    om.DomNode             # 欄位節點
   DEFINE pc_refer_fld    LIKE gav_file.gav31
   DEFINE ps_posX_refer   STRING
   DEFINE ps_posY         STRING
   DEFINE ls_width        STRING
   DEFINE ls_posX         STRING
   DEFINE lnode_root      om.DomNode
   DEFINE llst_items      om.NodeList
   DEFINE li_i            LIKE type_file.num5
   DEFINE lnode_parent    om.DomNode
   DEFINE lnode_reference om.DomNode
   DEFINE lnode_child     om.DomNode
   DEFINE lnode_next      om.DomNode
   DEFINE ls_name         STRING
 
   IF pc_refer_fld NOT MATCHES 'refer_*' THEN
      RETURN pnode_target
   END IF
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByTagName("FormField")
   FOR li_i = 1 TO llst_items.getLength()
       LET lnode_reference = llst_items.item(li_i)
       LET ls_name = lnode_reference.getAttribute("colName")
       IF ls_name.equals(pc_refer_fld CLIPPED) THEN
          RETURN pnode_target
       END IF
   END FOR
 
   LET lnode_child = pnode_target.getFirstChild()
   LET ls_width = lnode_child.getAttribute("width")
   LET ls_posX = lnode_child.getAttribute("posX")
   LET lnode_parent = pnode_target.getParent()
   LET lnode_next = pnode_target.getNext()
   LET lnode_reference = lnode_parent.createChild("FormField")
   LET lnode_child = lnode_reference.createChild("Edit")
   CALL lnode_parent.insertBefore(lnode_reference,lnode_next)
   CALL lnode_reference.setAttribute("colName",pc_refer_fld CLIPPED)
   CALL lnode_reference.setAttribute("name","formonly."||pc_refer_fld CLIPPED)
   CALL lnode_reference.setAttribute("noEntry",1)
   CALL lnode_child.setAttribute("width",20)
   IF cl_null(ps_posX_refer) OR ps_posX_refer <= 0 THEN
      LET ps_posX_refer = ls_posX+ls_width+1
      IF ps_posX_refer.getIndexOf(".",1) > 0 THEN
         LET ps_posX_refer = ps_posX_refer.subString(1,ps_posX_refer.getIndexOf(".",1)-1)
      END IF
   END IF
   CALL lnode_child.setAttribute("posX",ps_posX_refer)
   CALL lnode_child.setAttribute("posY",ps_posY)
   CALL lnode_child.setAttribute("scroll",1)
   RETURN pnode_target
END FUNCTION
#No.FUN-710055 ---end---
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: Ring Menu 的 button 加 show hint 顯示 button comment
# Date & Author..: 07/05/02 By Echo
# Input Parameter: pn_form
# Return code....: none
# Usage..........: CALL cl_set_action_comment(lnode_frm)
# Memo...........:
# Modify.........: 
##################################################
#FUN-710013
FUNCTION cl_set_action_comment(pn_form)
 DEFINE pn_form                 om.DomNode,
        ln_actionList           om.DomNode,
        ln_action               om.DomNode
 DEFINE lst_actionDefaultList   om.NodeList,
        lst_actionDefault       om.NodeList,
        lst_action              om.NodeList
 DEFINE li_i                    LIKE type_file.num10
 DEFINE l_text                  STRING,
        l_comment               STRING
 
   LET lst_actionDefaultList = pn_form.selectByTagName("ActionDefaultList")
   IF lst_actionDefaultList.getLength() > 0 THEN
      LET ln_actionList = lst_actionDefaultList.item(1)
      LET lst_actionDefault = ln_actionList.selectByTagName("ActionDefault")
      FOR li_i = 1 TO lst_actionDefault.getLength()
          LET ln_action = lst_actionDefault.item(li_i)
          LET l_text = ln_action.getAttribute("text")
          LET l_comment = ln_action.getAttribute("comment")
          IF cl_null(l_comment) THEN
              CALL ln_action.setAttribute("comment",l_text)
          END IF
      END FOR
   END IF
 
END FUNCTION
#END FUN-710013
