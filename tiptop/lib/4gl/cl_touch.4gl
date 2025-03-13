# Prog. Version..: '5.30.06-13.03.12(00001)'     #

# Program name...: cl_touch.4gl
# Descriptions...: 觸控
# Usage..........:
# Date & Author..: No.FUN-B30128 11/03/17 By tsai_yen

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-B30128
##################################################
# Descriptions...: 產生流程圖
# Date & Author..: 2010/06/18 By tsai_yen
# Input Parameter: p_type #排列方式 ex:"0"/"1"/"2"
#                  p_group #4fd Group name
#                  p_col  #一列最多顯示幾個
#                  p_title #標題
#                  p_detail  #文字描述
#                  p_doc_key #doc的key=value組成字串.以";"分隔
#                  p_doc_field #存圖片的欄位
#                  p_gridw #gridWidth
#                  p_gridh #gridHeight
# Return code....: l_acthidden STRING   #隱藏的按鈕,以","分隔
# Usage..........: CALL cl_touch_flow("2","flowchar",5,l_title,l_detail,l_doc_key,l_doc_field,l_gridw,l_gridh) RETURNING l_acthidden
# Memo...........:
##################################################
FUNCTION cl_touch_flow(p_type,p_group,p_col,p_title,p_detail,p_doc_key,p_doc_field,p_gridw,p_gridh)
   DEFINE p_type          STRING                    #排列方式 ex:"0"/ "1"/ "2"
   DEFINE p_group         STRING                    #4fd Group name
   DEFINE p_col           LIKE type_file.num5       #一列最多顯示幾個
   DEFINE p_title         DYNAMIC ARRAY OF STRING   #標題
   DEFINE p_detail        DYNAMIC ARRAY OF STRING   #文字描述
   #doc的key=value組成字串.每組以";"分隔
   #kye1=value1;kye2=value2;kye3=value3;kye4=value4;kye5=value5
   DEFINE p_doc_key       DYNAMIC ARRAY OF STRING
   DEFINE p_doc_field     DYNAMIC ARRAY OF STRING   #存圖片的欄位
   DEFINE p_gridw         LIKE type_file.num5       #圖片gridWidth
   DEFINE p_gridh         LIKE type_file.num5       #圖片gridHeight
   DEFINE l_img           DYNAMIC ARRAY OF STRING   #圖片路徑
   DEFINE l_acthidden     STRING                    #隱藏的按鈕,以","分隔
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_ii            LIKE type_file.num5
   DEFINE l_j             LIKE type_file.num5
   DEFINE l_col_mod       LIKE type_file.num5
   DEFINE l_row_mod       LIKE type_file.num5
   DEFINE l_row           LIKE type_file.num5  #第幾列
   DEFINE l_row_max       LIKE type_file.num5  #最後列
   DEFINE lnode_group     om.DomNode
   DEFINE lnode_vbox      om.DomNode
   DEFINE lnode_hbox      om.DomNode
   DEFINE lnode_grid      om.DomNode
   DEFINE ls_name         STRING
   DEFINE l_act_max       LIKE type_file.num5  #最多預設幾個按鈕(routingaction.4gl)
   DEFINE l_act_num       LIKE type_file.num5  #按鈕數量
   DEFINE l_str           STRING
   DEFINE l_x             LIKE type_file.num5  #X軸
   DEFINE l_y             LIKE type_file.num5  #Y軸
   DEFINE l_oi            STRING
   DEFINE l_turn_i        LIKE type_file.num5  #反轉順序的index
   DEFINE l_turn_oi       LIKE type_file.num5  #反轉順序
   DEFINE l_turn          LIKE type_file.num5
   DEFINE l_firsti        LIKE type_file.num5  #按鈕第一個顯示
   DEFINE l_arrow         LIKE type_file.chr1  #水平箭頭
   DEFINE l_tok           base.StringTokenizer
   DEFINE l_tmp           STRING

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_group = lfrm_curr.findNode("Group",p_group)
   IF lnode_group IS NULL THEN
      MESSAGE "Can't find layout"
      RETURN
   ELSE
      LET ls_name = p_group,"_VBox"
      #刪除VBox,避免重覆執行時元件重疊
      LET lnode_vbox = lfrm_curr.findNode("VBox",ls_name)
      IF lnode_vbox IS NOT NULL THEN
         CALL lnode_group.removeChild(lnode_vbox)
      END IF
      #新增VBox
      LET lnode_vbox = lnode_group.createChild("VBox")
      CALL lnode_vbox.setAttribute("name",ls_name)
   END IF

   LET l_act_max = 100
   LET l_act_num = p_title.getlength()

   #隱藏全部的按鈕
   IF l_act_num = 0 THEN
      FOR l_i = 1 TO l_act_max
         LET l_str = l_i
         LET l_acthidden = l_acthidden,",btn",l_str
      END FOR
      IF l_acthidden.getindexof(",",1) > 0 THEN   #拿掉第一個","
         LET l_acthidden = l_acthidden.substring(2,l_acthidden.getlength())
      END IF

      RETURN l_acthidden
   END IF

   CASE
      WHEN p_type = "0"
         LET l_firsti = 1
         LET l_arrow = "N"
      WHEN p_type = "1"
         LET l_firsti = 2
         LET l_arrow = "Y"
      WHEN p_type = "2"
         LET l_firsti = 1
         LET l_arrow = "Y"
   END CASE

   CALL cl_get_fld_pic2(p_doc_key,p_doc_field,"2")  RETURNING l_str

   LET l_tok = base.StringTokenizer.createExt(l_str CLIPPED,",","",TRUE)	#指定分隔符號
   LET l_i = 0
   WHILE l_tok.hasMoreTokens()	#依序取得子字串
     LET l_i = l_i + 1
     LET l_tmp = l_tok.nextToken()
     LET l_img[l_i] = l_tmp.trim()
     #DISPLAY l_i USING "&&",".l_img='",l_img[l_i],"'"
   END WHILE

   LET l_row = 0
   IF p_type = "1" THEN
      LET l_row = l_row + 1

      LET lnode_hbox = lnode_vbox.createChild("HBox")
      LET ls_name = p_group,"_hb",l_i USING "&&&"
      CALL lnode_hbox.setAttribute("name",ls_name)

      LET lnode_grid = lnode_hbox.createChild("Grid")
      LET ls_name = p_group,"_grid",l_i USING "&&&"  #元件名稱 ex:"_grid001"
      CALL lnode_grid.setAttribute("name",ls_name)
      CALL cl_touch_flow_component(lnode_grid,l_i,"Image",p_title[1],p_detail[1],l_img[1],p_gridw,p_gridh)
      CALL lnode_grid.setAttribute("posY",0)
      CALL lnode_grid.setAttribute("posX",0)
      CALL lnode_grid.setAttribute("gridWidth",p_gridw)
      CALL lnode_grid.setAttribute("gridHeight",p_gridh)
      CALL lnode_grid.setAttribute("width",50)

      LET lnode_grid = lnode_hbox.createChild("Grid")
      LET ls_name = p_group,"_arrow",l_i USING "&&&"
      CALL lnode_grid.setAttribute("name",ls_name)
      CALL lnode_grid.setAttribute("posY",0)
      CALL lnode_grid.setAttribute("posX",p_gridh+1)
      CALL lnode_grid.setAttribute("gridWidth",p_gridw)
      CALL cl_touch_flow_arrow(lnode_grid,l_i,"touch_line",1)
   END IF

   IF l_act_num MOD p_col = 0 THEN
      LET l_row_max = l_act_num/p_col
   ELSE
      LET l_row_max = l_act_num/p_col + 1
   END IF
   FOR l_i = l_firsti TO l_act_max+l_firsti
       LET l_oi = l_i - (l_firsti-1)

       IF l_i <= l_act_num AND l_oi <= l_act_max THEN
          LET l_col_mod = l_i MOD p_col
          IF l_col_mod >0 THEN
             IF l_col_mod = 1 THEN   #換列
                LET l_row = l_row + 1
             END IF
             LET l_row_mod = ( l_i/p_col + 1 ) MOD 4
          ELSE
             LET l_row_mod = ( l_i/p_col ) MOD 4
          END IF

          LET l_x = l_x + 1

          IF l_firsti = 1 AND l_col_mod = 1 THEN
              LET lnode_hbox = lnode_vbox.createChild("HBox")
              LET ls_name = p_group,"_hb",l_row_mod USING "&&&"
              CALL lnode_hbox.setAttribute("name",ls_name)
          END IF

          IF p_type = "1" OR p_type = "2" THEN   #反轉順序
             IF l_row_mod = 1 OR l_row_mod = 3 THEN
                LET l_turn_i = l_i
                LET l_turn_oi = l_oi
             ELSE
                IF l_row = l_row_max THEN   #最後一列
                   IF l_col_mod = 1 THEN
                      LET l_turn = l_act_num - l_i
                      LET l_turn_i = l_i + l_turn
                      LET l_turn_oi = l_oi + l_turn
                   ELSE
                      LET l_turn_i = l_turn_i - 1
                      LET l_turn_oi = l_turn_oi - 1
                   END IF
                ELSE
                   IF l_col_mod = 1 THEN
                      LET l_turn_i = l_i + p_col - 1
                      LET l_turn_oi = l_oi + p_col - 1
                   ELSE
                      LET l_turn_i = l_turn_i - 1
                      LET l_turn_oi = l_turn_oi - 1
                   END IF
                END IF
             END IF
          ELSE
             LET l_turn_i = l_i
             LET l_turn_oi = l_oi
          END IF

          #補齊最後一列的空欄位(前)
          IF l_col_mod = 1                    #第一欄資料
             AND (l_row = l_row_max)          #最後一列
             AND (l_act_num MOD p_col > 0)    #需要補齊
             AND ((p_type = "1" OR p_type = "2") AND (l_row_mod = 2 OR l_row_mod = 0)) THEN #反轉,最後一列屬於反轉列
                 LET l_x = l_x + 1
                 LET l_j = l_turn_oi
                 FOR l_ii = ((l_act_num MOD p_col) * 2) TO (p_col * 2) - 1
                    LET l_x = l_x + 1
                    LET l_j = l_j + 1
                    LET lnode_grid = lnode_hbox.createChild("Grid")
                    CALL lnode_grid.setAttribute("posX",l_x)
                    CALL lnode_grid.setAttribute("posY",l_y)
                    CALL cl_touch_flow_arrow(lnode_grid,l_j,"space1x1",0)
                 END FOR
          END IF

          LET lnode_grid = lnode_hbox.createChild("Grid")
          LET ls_name = p_group,"_grid",l_oi USING "&&&"  #元件名稱 ex:"_grid001"
          CALL lnode_grid.setAttribute("name",ls_name)
          CALL cl_touch_flow_component(lnode_grid,l_turn_oi,"Button",p_title[l_turn_i],p_detail[l_turn_i],l_img[l_turn_i],p_gridw,p_gridh)
          CALL lnode_grid.setAttribute("posY",l_y)
          CALL lnode_grid.setAttribute("posX",l_x)
          CALL lnode_grid.setAttribute("gridWidth",p_gridw)

          #補齊最後一列的空欄位(後)
          IF l_turn_i = l_act_num             #最後一筆資料
             AND (l_act_num MOD p_col > 0)    #需要補齊
             AND ((p_type = "0")              #無反轉
                   OR ((p_type = "1" OR p_type = "2") AND (l_row_mod = 1 OR l_row_mod = 3))) THEN #反轉,最後一列不屬於反轉列
                 LET l_x = l_x + 1
                 LET l_j = l_turn_oi
                 FOR l_ii = ((l_act_num MOD p_col) * 2) TO (p_col * 2) - 1
                    LET l_x = l_x + 1
                    LET l_j = l_j + 1
                    LET lnode_grid = lnode_hbox.createChild("Grid")
                    CALL lnode_grid.setAttribute("posX",l_x)
                    CALL lnode_grid.setAttribute("posY",l_y)
                    CALL cl_touch_flow_arrow(lnode_grid,l_j,"space1x1",0)
                 END FOR
          END IF

          #橫向箭頭
          IF l_col_mod > 0 AND (l_oi + l_firsti) <= l_act_num THEN
             LET l_x = l_x + 1
             LET lnode_grid = lnode_hbox.createChild("Grid")
             LET ls_name = p_group,"_arrow",l_oi USING "&&&"
             CALL lnode_grid.setAttribute("name",ls_name)
             CALL lnode_grid.setAttribute("posX",l_x)
             CALL lnode_grid.setAttribute("posY",l_y)
             CALL lnode_grid.setAttribute("gridWidth",10)
             CASE
                WHEN l_arrow = "Y" AND (l_row_mod = 1 OR l_row_mod = 3)
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"touch_r",1)
                WHEN l_arrow = "Y" AND (l_row_mod = 2 OR l_row_mod = 0)
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"touch_l",1)
                WHEN l_arrow = "N"
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"space1x1",0)
             END CASE
          END IF


          #向下箭頭
          IF l_col_mod = 0 AND (l_oi + l_firsti) <= l_act_num THEN
             LET l_x = 0
             LET l_y = 0
             LET lnode_hbox = lnode_vbox.createChild("HBox")
             LET ls_name = p_group,"_hb",l_oi USING "&&&"
             CALL lnode_hbox.setAttribute("name",ls_name)

             IF l_arrow = "Y" THEN
                #向下箭頭(靠右)
                IF l_row_mod = 1 OR l_row_mod = 3 THEN
                   FOR l_ii = 1 TO ((p_col-1)*2)
                      LET lnode_grid = lnode_hbox.createChild("Grid")
                      CALL lnode_grid.setAttribute("posX",l_x)
                      CALL lnode_grid.setAttribute("posY",l_y)
                      CALL cl_touch_flow_arrow(lnode_grid,l_oi,"space1x1",0)
                      LET l_x = l_x + 1
                   END FOR
                   LET lnode_grid = lnode_hbox.createChild("Grid")
                   LET ls_name = p_group,"_arrow",l_oi USING "&&&"
                   CALL lnode_grid.setAttribute("name",ls_name)
                   CALL lnode_grid.setAttribute("posX",l_x)
                   CALL lnode_grid.setAttribute("posY",l_y)
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"touch_b",0)
                END IF
                #向下箭頭(靠左)
                IF l_row_mod = 2 OR l_row_mod = 0 THEN
                   LET lnode_grid = lnode_hbox.createChild("Grid")
                   LET ls_name = p_group,"_arrow",l_oi USING "&&&"
                   CALL lnode_grid.setAttribute("name",ls_name)
                   CALL lnode_grid.setAttribute("posX",l_x)
                   CALL lnode_grid.setAttribute("posY",l_y)
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"touch_b",0)
                   FOR l_ii = 1 TO ((p_col-1)*2)
                      LET lnode_grid = lnode_hbox.createChild("Grid")
                      CALL lnode_grid.setAttribute("posX",l_x)
                      CALL lnode_grid.setAttribute("posY",l_y)
                      CALL cl_touch_flow_arrow(lnode_grid,l_oi,"space1x1",0)
                      LET l_x = l_x + 1
                   END FOR
                END IF
             ELSE
                FOR l_ii = 1 TO (p_col*2)
                   LET lnode_grid = lnode_hbox.createChild("Grid")
                   CALL lnode_grid.setAttribute("posX",l_x)
                   CALL lnode_grid.setAttribute("posY",l_y)
                   CALL cl_touch_flow_arrow(lnode_grid,l_oi,"space1x1",0)
                   LET l_x = l_x + 1
                END FOR
             END IF
             LET l_y = l_y + 1
             LET lnode_hbox = lnode_vbox.createChild("HBox")
             LET ls_name = p_group,"_hb",l_row_mod USING "&&&"
             CALL lnode_hbox.setAttribute("name",ls_name)
          END IF
       ELSE
          LET l_str = l_oi
          IF l_oi <= l_act_max THEN
             LET l_acthidden = l_acthidden,",btn",l_str
          END IF
       END IF
   END FOR
   IF l_acthidden.getindexof(",",1) > 0 THEN   #拿掉第一個","
      LET l_acthidden = l_acthidden.substring(2,l_acthidden.getlength())
   END IF

   RETURN l_acthidden
END FUNCTION


##################################################
# Private Func...: TRUE
# Descriptions...: 產生流程圖元件
# Date & Author..: 2010/06/18 By tsai_yen
# Input Parameter: pnode_parent,p_i,p_type,p_title,p_detail,p_img,p_gridw,p_gridh
# Return code....: none
# Usage..........: CALL cl_touch_flow_component(pnode_parent,p_i,p_type,p_title,p_detail,p_img,p_gridw,p_gridh)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_touch_flow_component(pnode_parent,p_i,p_type,p_title,p_detail,p_img,p_gridw,p_gridh)
   DEFINE pnode_parent    om.DomNode
   DEFINE p_i             LIKE type_file.num5
   DEFINE l_id            STRING
   DEFINE p_type          STRING       #原件類型:Button,Image
   DEFINE p_title         STRING       #標題
   DEFINE p_detail        STRING       #文字描述
   DEFINE p_img           STRING       #圖片
   DEFINE p_gridw         LIKE type_file.num5       #圖片gridWidth
   DEFINE p_gridh         LIKE type_file.num5       #圖片gridHeight
   DEFINE lnode_desc      om.DomNode
   DEFINE lnode_button    om.DomNode
   DEFINE lnode_detail    om.DomNode
   DEFINE lnode_detail1   om.DomNode
   DEFINE ls_name         STRING
   DEFINE l_str           STRING

   LET l_id = p_i           # TO INTEGER

   #Routing ID - Title
   LET lnode_desc = pnode_parent.createChild("Label")
   LET ls_name = "label_id",l_id
   CALL lnode_desc.setAttribute("name",ls_name)
   CALL lnode_desc.setAttribute("text",UPSHIFT(p_title))
   CALL lnode_desc.setAttribute("posX",0)
   CALL lnode_desc.setAttribute("posY",0)
   CALL lnode_desc.setAttribute("style","routingname")

   #Routing Icon - Picture
   LET lnode_button = pnode_parent.createChild(p_type)
   LET ls_name = "btn",l_id
   CALL lnode_button.setAttribute("name",ls_name)
   IF NOT cl_null(p_img) THEN
      CALL lnode_button.setAttribute("image",p_img)
      IF p_type = "Image" THEN
         CALL lnode_button.setAttribute("sizePolicy","fixed") #fixed,dynamic,initial
      ELSE
         CALL lnode_button.setAttribute("sizePolicy","fixed") #fixed,dynamic
      END IF
   END IF
   CALL lnode_button.setAttribute("comment","選擇工單程式[xxxxx]")
   CALL lnode_button.setAttribute("posX",0)
   CALL lnode_button.setAttribute("posY",1)
   CALL lnode_button.setAttribute("gridWidth",p_gridw)
   CALL lnode_button.setAttribute("gridHeight",p_gridh)

   LET ls_name = 1
   CALL lnode_button.setAttribute("style","routingbutton"||ls_name)

   #Routing Detail - Detail
   LET lnode_detail = pnode_parent.createChild("FormField")
   LET ls_name = "label_FF",l_id
   CALL lnode_detail.setAttribute("name",ls_name)
   CALL lnode_detail.setAttribute("value",UPSHIFT(p_detail))

   LET lnode_detail1 = lnode_detail.createChild("TextEdit")
   LET ls_name = "label_dt",l_id
   CALL lnode_detail1.setAttribute("name",ls_name)
   CALL lnode_detail1.setAttribute("posX",0)
   CALL lnode_detail1.setAttribute("posY",p_gridh+1)
   CALL lnode_detail1.setAttribute("gridWidth",p_gridw)
   CALL lnode_detail1.setAttribute("gridHeight",3)
   CALL lnode_detail1.setAttribute("style","routingdetail")
END FUNCTION


##################################################
# Private Func...: TRUE
# Descriptions...: 產生流程圖箭頭
# Date & Author..: 2010/06/18 By tsai_yen
# Input Parameter: pnode_parent,ps_position,p_img,p_labelnum
# Return code....: none
# Usage..........: CALL cl_touch_flow_arrow(pnode_parent,ps_position,p_img,p_labelnum)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_touch_flow_arrow(pnode_parent,ps_position,p_img,p_labelnum)
   DEFINE   pnode_parent   om.DomNode
   DEFINE   ps_position    STRING
   DEFINE   p_img          STRING                #箭頭圖片
   DEFINE   p_labelnum     LIKE type_file.num5   #加label的數量
   DEFINE   lnode_label    om.DomNode
   DEFINE   lnode_image    om.DomNode
   DEFINE   ls_name        STRING
   DEFINE   l_i            LIKE type_file.num5
   DEFINE   l_img          STRING

   #Space
   FOR l_i = 1 TO p_labelnum
      LET lnode_label = pnode_parent.createChild("Label")
      LET ls_name = "arrow_lb",ps_position
      CALL lnode_label.setAttribute("name",ls_name)
      CALL lnode_label.setAttribute("posX",0)
      CALL lnode_label.setAttribute("posY",0)
      CALL lnode_label.setAttribute("height",3)
   END FOR

   #Arrow between routing and routing - Canvas, but when is not parallel routing, use image is fast
   LET lnode_image = pnode_parent.createChild("Image")
   LET ls_name = "arrow_rt",ps_position
   CALL lnode_image.setAttribute("name",ls_name)
   IF NOT cl_null(p_img) THEN
      #LET l_img = "touch/",p_img
      LET l_img = p_img
      CALL lnode_image.setAttribute("image",l_img)
      CALL lnode_image.setAttribute("sizePolicy","dynamic")
   END IF
   CALL lnode_image.setAttribute("posX",0)
   CALL lnode_image.setAttribute("posY",1)
   CALL lnode_image.setAttribute("style","routingarrow")
END FUNCTION
