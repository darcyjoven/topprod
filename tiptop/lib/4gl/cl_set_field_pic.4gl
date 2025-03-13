# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: cl_set_field_pic.4gl
# Descriptions...: 設定顯示圖片
# Date & Author..: 04/03/12 by saki
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-720042 07/02/27 By saki pixelHeight->Height,pixelWidth->Width
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-9B0022 09/11/20 by hsien 新增autoScale=0, sizePolicy=dynamic屬性
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
# Descriptions...: 設定顯示圖片
# Input Parameter: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#                  ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
#                  若有效碼為N則不管其他碼圖,圖片都顯示無效 
# Return Code....:
 
FUNCTION cl_set_field_pic(ps_confirm,ps_approve,ps_post,ps_close,ps_void,ps_valid)
   DEFINE   ps_fields          STRING,
            ps_att_value       STRING
   DEFINE   ps_confirm         LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
            ps_approve         LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
            ps_post            LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
            ps_close           LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
            ps_void            LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
            ps_valid           LIKE type_file.chr1              #No.FUN-690005  VARCHAR(1)
   DEFINE   g_pri              DYNAMIC ARRAY OF RECORD
               pri_name        STRING,
               pri_value       LIKE type_file.chr1              #No.FUN-690005  VARCHAR(1)
                               END RECORD
   DEFINE   ls_pri             STRING
   DEFINE   li_i               LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   ls_imgmksg         STRING
   DEFINE   lnode_root         om.DomNode
   DEFINE   llst_items         om.NodeList
   DEFINE   lnode_item         om.DomNode
   DEFINE   ls_item_name       STRING
   DEFINE   lnode_child        om.DomNode
   DEFINE   ls_pic_url         STRING
 
   #FUN-640184
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
 
      RETURN
   END IF
   #END FUN-640184
 
   # 2004/05/17 by saki : 依照語言別秀不一樣圖形, 圖片大小可能不一樣
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByPath("//Form//*")
   
   FOR li_i = 1 TO llst_items.getLength()
       LET lnode_item = llst_items.item(li_i)
       LET ls_item_name = lnode_item.getAttribute("colName")
       IF (ls_item_name IS NULL) THEN
          LET ls_item_name = lnode_item.getAttribute("name")
          IF (ls_item_name IS NULL) THEN
             CONTINUE FOR
          END IF
       END IF
       IF (ls_item_name.equals("imgmksg")) THEN
          LET lnode_child = lnode_item.getFirstChild()
          CALL lnode_child.setAttribute("sizePolicy","dynamic")           #No.CHI-9B0022
          CALL lnode_child.setAttribute("autoScale","0")                  #No.CHI-9B0022
          CASE g_lang
             WHEN "0"
                CALL lnode_child.setAttribute("height","36px") #No.FUN-720042
                CALL lnode_child.setAttribute("width","36px")  #No.FUN-720042
             WHEN "1"
                CALL lnode_child.setAttribute("height","36px") #No.FUN-720042
                CALL lnode_child.setAttribute("width","36px")  #No.FUN-720042
             WHEN "2"
                CALL lnode_child.setAttribute("height","36px") #No.FUN-720042
                CALL lnode_child.setAttribute("width","36px")  #No.FUN-720042
             OTHERWISE
                CALL lnode_child.setAttribute("height","36px") #No.FUN-720042
                CALL lnode_child.setAttribute("width","36px")  #No.FUN-720042
          END CASE
          EXIT FOR
       END IF
   END FOR
   
   IF ps_valid = 'N' THEN
      LET ls_pri = "valid"   
   ELSE
      LET g_pri[1].pri_name  = "void"
      LET g_pri[1].pri_value = ps_void
      LET g_pri[2].pri_name  = "close"
      LET g_pri[2].pri_value = ps_close
      LET g_pri[3].pri_name  = "post"
      LET g_pri[3].pri_value = ps_post
      LET g_pri[4].pri_name  = "approve"
      LET g_pri[4].pri_value = ps_approve
      LET g_pri[5].pri_name  = "confirm"
      LET g_pri[5].pri_value = ps_confirm
 
      FOR li_i = 1 TO g_pri.getLength()
          IF (NOT cl_null(g_pri[li_i].pri_value)) AND g_pri[li_i].pri_value = 'Y' THEN
             LET ls_pri = g_pri[li_i].pri_name
             EXIT FOR
          END IF
      END FOR
   END IF
 
   LET ls_pic_url = FGL_GETENV("FGLASIP") || "/tiptop/pic/"
   CASE g_lang
      WHEN "0"
         CASE ls_pri
            WHEN "void"
               LET ls_imgmksg = ls_pic_url.trim() || "void_0.bmp"
            WHEN "close"
               LET ls_imgmksg = ls_pic_url.trim() || "close_0.bmp"
            WHEN "post"
               LET ls_imgmksg = ls_pic_url.trim() || "post_0.bmp"
            WHEN "approve"
               LET ls_imgmksg = ls_pic_url.trim() || "approval_0.bmp"
            WHEN "confirm"
               LET ls_imgmksg = ls_pic_url.trim() || "confirm_0.bmp"
            WHEN "valid"
               LET ls_imgmksg = ls_pic_url.trim() || "valid_0.bmp"
            OTHERWISE
#              LET ls_imgmksg = ""
               LET ls_imgmksg = ls_pic_url.trim() || "space_0.gif"
         END CASE
      WHEN "1"
         CASE ls_pri
            WHEN "void"
               LET ls_imgmksg = ls_pic_url.trim() || "void_1.bmp"
            WHEN "close"
               LET ls_imgmksg = ls_pic_url.trim() || "close_1.bmp"
            WHEN "post"
               LET ls_imgmksg = ls_pic_url.trim() || "post_1.bmp"
            WHEN "approve"
               LET ls_imgmksg = ls_pic_url.trim() || "approval_1.bmp"
            WHEN "confirm"
               LET ls_imgmksg = ls_pic_url.trim() || "confirm_1.bmp"
            WHEN "valid"
               LET ls_imgmksg = ls_pic_url.trim() || "valid_1.bmp"
            OTHERWISE
#              LET ls_imgmksg = ""
               LET ls_imgmksg = ls_pic_url.trim() || "space_0.gif"
         END CASE
      WHEN "2"
         CASE ls_pri
            WHEN "void"
               LET ls_imgmksg = ls_pic_url.trim() || "void_0.bmp"
            WHEN "close"
               LET ls_imgmksg = ls_pic_url.trim() || "close_0.bmp"
            WHEN "post"
               LET ls_imgmksg = ls_pic_url.trim() || "post_0.bmp"
            WHEN "approve"
               LET ls_imgmksg = ls_pic_url.trim() || "approval_0.bmp"
            WHEN "confirm"
               LET ls_imgmksg = ls_pic_url.trim() || "confirm_0.bmp"
            WHEN "valid"
               LET ls_imgmksg = ls_pic_url.trim() || "valid_0.bmp"
            OTHERWISE
#              LET ls_imgmksg = ""
               LET ls_imgmksg = ls_pic_url.trim() || "space_0.gif"
         END CASE
      OTHERWISE
         CASE ls_pri
            WHEN "void"
               LET ls_imgmksg = ls_pic_url.trim() || "void_1.bmp"
            WHEN "close"
               LET ls_imgmksg = ls_pic_url.trim() || "close_1.bmp"
            WHEN "post"
               LET ls_imgmksg = ls_pic_url.trim() || "post_1.bmp"
            WHEN "approve"
               LET ls_imgmksg = ls_pic_url.trim() || "approval_1.bmp"
            WHEN "confirm"
               LET ls_imgmksg = ls_pic_url.trim() || "confirm_1.bmp"
            WHEN "valid"
               LET ls_imgmksg = ls_pic_url.trim() || "valid_1.bmp"
            OTHERWISE
#              LET ls_imgmksg = ""
               LET ls_imgmksg = ls_pic_url.trim() || "space_0.gif"
         END CASE
      END CASE
 
   DISPLAY ls_imgmksg TO imgmksg
END FUNCTION
