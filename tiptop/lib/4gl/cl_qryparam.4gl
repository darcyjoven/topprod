# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: cl_qryparam.4gl
# Descriptions...: 動態開窗函式設定及使用 No.FUN-710055
# Date & Author..: 2007/01/25 by saki
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_zav     RECORD LIKE zav_file.*
DEFINE   g_zav08   RECORD
           zav08_1 LIKE type_file.chr1,
           zav08_2 LIKE type_file.chr1,
           zav08_3 LIKE type_file.chr1,
           zav08_4 LIKE type_file.chr1,
           zav08_5 LIKE type_file.chr1
                   END RECORD
DEFINE   g_zav14   RECORD
           zav14_1 LIKE type_file.chr1,
           zav14_2 LIKE type_file.chr1,
           zav14_3 LIKE type_file.chr1,
           zav14_4 LIKE type_file.chr1,
           zav14_5 LIKE type_file.chr1,
           zav14_6 LIKE type_file.chr1,
           zav14_7 LIKE type_file.chr1,
           zav14_8 LIKE type_file.chr1,
           zav14_9 LIKE type_file.chr1
                   END RECORD
DEFINE   g_zav_e   RECORD
           zav09_e STRING,
           zav10_e STRING,
           zav11_e STRING,
           zav12_e STRING,
           zav13_e STRING,
           zav15_e STRING,
           zav16_e STRING,
           zav17_e STRING,
           zav18_e STRING,
           zav19_e STRING,
           zav20_e STRING,
           zav21_e STRING,
           zav22_e STRING,
           zav23_e STRING
                   END RECORD
DEFINE   g_firstin LIKE type_file.num5
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 動態開窗函式參數設定
# Date & Author..: 2007/01/25 By saki
# Input Parameter: pc_zav01   程式使用(1.per 2.query)
#                  pc_zav02   程式代碼/查詢單id
#                  pc_zav03   欄位代碼
#                  pc_zav04   客製碼
#                  pc_zav05   行業別代碼
#                  pc_zav24   開窗狀態
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_set_qryparam("1",g_gav01,g_gav[l_ac].gav02,g_gav08,g_gav11,"c")
# Memo...........:
##################################################
FUNCTION cl_set_qryparam(pc_zav01,pc_zav02,pc_zav03,pc_zav04,pc_zav05,pc_zav24)
   DEFINE   pc_zav01 LIKE zav_file.zav01
   DEFINE   pc_zav02 LIKE zav_file.zav02
   DEFINE   pc_zav03 LIKE zav_file.zav03
   DEFINE   pc_zav04 LIKE zav_file.zav04
   DEFINE   pc_zav05 LIKE zav_file.zav05
   DEFINE   pc_zav24 LIKE zav_file.zav24
   DEFINE   lc_cmd   LIKE type_file.chr1
   DEFINE   li_i     LIKE type_file.num5
 
   INITIALIZE g_zav.* TO NULL
   INITIALIZE g_zav08.* TO NULL
   INITIALIZE g_zav14.* TO NULL
   INITIALIZE g_zav_e.* TO NULL
   SELECT * INTO g_zav.* FROM zav_file
    WHERE zav01=pc_zav01 AND zav02=pc_zav02 AND zav03=pc_zav03 AND zav04=pc_zav04 AND zav05=pc_zav05 AND zav24=pc_zav24
   IF cl_null(g_zav.zav01) OR cl_null(g_zav.zav02) OR cl_null(g_zav.zav03) OR
      cl_null(g_zav.zav04) OR cl_null(g_zav.zav05) OR cl_null(g_zav.zav24) THEN
      LET lc_cmd = "a"
      LET g_zav.zav01 = pc_zav01
      LET g_zav.zav02 = pc_zav02
      LET g_zav.zav03 = pc_zav03
      LET g_zav.zav04 = pc_zav04
      LET g_zav.zav05 = pc_zav05
      LET g_zav.zav24 = pc_zav24
   ELSE
      LET lc_cmd = "u"
   END IF
   IF cl_null(g_zav.zav06) THEN
      LET g_zav.zav06 = "Y"
   END IF
   IF cl_null(g_zav.zav08) THEN
      LET g_zav08.zav08_1 = 0
      LET g_zav08.zav08_2 = 0
      LET g_zav08.zav08_3 = 0
      LET g_zav08.zav08_4 = 0
      LET g_zav08.zav08_5 = 0
   ELSE
      LET g_zav08.zav08_1 = g_zav.zav08[1]
      LET g_zav08.zav08_2 = g_zav.zav08[2]
      LET g_zav08.zav08_3 = g_zav.zav08[3]
      LET g_zav08.zav08_4 = g_zav.zav08[4]
      LET g_zav08.zav08_5 = g_zav.zav08[5]
   END IF
   IF cl_null(g_zav.zav14) THEN
      LET g_zav14.zav14_1 = 0
      LET g_zav14.zav14_2 = 0
      LET g_zav14.zav14_3 = 0
      LET g_zav14.zav14_4 = 0
      LET g_zav14.zav14_5 = 0
      LET g_zav14.zav14_6 = 0
      LET g_zav14.zav14_7 = 0
      LET g_zav14.zav14_8 = 0
      LET g_zav14.zav14_9 = 0
   ELSE
      LET g_zav14.zav14_1 = g_zav.zav14[1]
      LET g_zav14.zav14_2 = g_zav.zav14[2]
      LET g_zav14.zav14_3 = g_zav.zav14[3]
      LET g_zav14.zav14_4 = g_zav.zav14[4]
      LET g_zav14.zav14_5 = g_zav.zav14[5]
      LET g_zav14.zav14_6 = g_zav.zav14[6]
      LET g_zav14.zav14_7 = g_zav.zav14[7]
      LET g_zav14.zav14_8 = g_zav.zav14[8]
      LET g_zav14.zav14_9 = g_zav.zav14[9]
   END IF
   FOR li_i = 1 TO 5
       IF g_zav.zav08[li_i] = "2" THEN 
          CASE li_i
             WHEN 1
                LET g_zav_e.zav09_e = g_zav.zav09
             WHEN 2                   
                LET g_zav_e.zav10_e = g_zav.zav10
             WHEN 3                   
                LET g_zav_e.zav11_e = g_zav.zav11
             WHEN 4                   
                LET g_zav_e.zav12_e = g_zav.zav12
             WHEN 5                   
                LET g_zav_e.zav13_e = g_zav.zav13
          END CASE
       END IF
   END FOR
   FOR li_i = 1 TO 9
       IF g_zav.zav14[li_i] = "2" THEN
          CASE
             WHEN 1
                LET g_zav_e.zav15_e = g_zav.zav15
             WHEN 2                              
                LET g_zav_e.zav16_e = g_zav.zav16
             WHEN 3                              
                LET g_zav_e.zav17_e = g_zav.zav17
             WHEN 4                              
                LET g_zav_e.zav18_e = g_zav.zav18
             WHEN 5                              
                LET g_zav_e.zav19_e = g_zav.zav19
             WHEN 6                              
                LET g_zav_e.zav20_e = g_zav.zav20
             WHEN 7                              
                LET g_zav_e.zav21_e = g_zav.zav21
             WHEN 8                              
                LET g_zav_e.zav22_e = g_zav.zav22
             WHEN 9                              
                LET g_zav_e.zav23_e = g_zav.zav23
          END CASE
       END IF
   END FOR
 
   OPEN WINDOW set_qryparam_w WITH FORM "lib/42f/cl_set_qryparam"
      ATTRIBUTE(STYLE="create_qry")
   CALL cl_ui_locale("cl_set_qryparam")
 
   DISPLAY BY NAME g_zav.zav06,g_zav.zav07,g_zav.zav09,g_zav.zav10,g_zav.zav11,
                   g_zav.zav12,g_zav.zav13,g_zav.zav15,g_zav.zav16,g_zav.zav17,
                   g_zav.zav18,g_zav.zav19,g_zav.zav20,g_zav.zav21,g_zav.zav22,
                   g_zav.zav23
   DISPLAY g_zav08.zav08_1,g_zav08.zav08_2,g_zav08.zav08_3,g_zav08.zav08_4,g_zav08.zav08_5
        TO zav08_1,zav08_2,zav08_3,zav08_4,zav08_5
   DISPLAY g_zav14.zav14_1,g_zav14.zav14_2,g_zav14.zav14_3,g_zav14.zav14_4,g_zav14.zav14_5,
           g_zav14.zav14_6,g_zav14.zav14_7,g_zav14.zav14_8,g_zav14.zav14_9
        TO zav14_1,zav14_2,zav14_3,zav14_4,zav14_5,zav14_6,zav14_7,zav14_8,zav14_9
 
   CALL cl_qryparam_set_posX()
   CALL cl_qryparam_set_ComboBox(pc_zav02,pc_zav04,pc_zav05)
   IF g_zav.zav01 = "2" THEN
      CALL cl_set_comp_visible("group01",FALSE)
   END IF
 
   WHILE TRUE
      INPUT g_zav.zav06,g_zav.zav07,g_zav08.zav08_1,g_zav.zav09,g_zav_e.zav09_e,
            g_zav08.zav08_2,g_zav.zav10,g_zav_e.zav10_e,
            g_zav08.zav08_3,g_zav.zav11,g_zav_e.zav11_e,
            g_zav08.zav08_4,g_zav.zav12,g_zav_e.zav12_e,
            g_zav08.zav08_5,g_zav.zav13,g_zav_e.zav13_e,
            g_zav14.zav14_1,g_zav.zav15,g_zav_e.zav15_e,
            g_zav14.zav14_2,g_zav.zav16,g_zav_e.zav16_e,
            g_zav14.zav14_3,g_zav.zav17,g_zav_e.zav17_e,
            g_zav14.zav14_4,g_zav.zav18,g_zav_e.zav18_e,
            g_zav14.zav14_5,g_zav.zav19,g_zav_e.zav19_e,
            g_zav14.zav14_6,g_zav.zav20,g_zav_e.zav20_e,
            g_zav14.zav14_7,g_zav.zav21,g_zav_e.zav21_e,
            g_zav14.zav14_8,g_zav.zav22,g_zav_e.zav22_e,
            g_zav14.zav14_9,g_zav.zav23,g_zav_e.zav23_e WITHOUT DEFAULTS
       FROM zav06,zav07,zav08_1,zav09,zav09_e,zav08_2,zav10,zav10_e,
            zav08_3,zav11,zav11_e,zav08_4,zav12,zav12_e,zav08_5,zav13,zav13_e,
            zav14_1,zav15,zav15_e,zav14_2,zav16,zav16_e,zav14_3,zav17,zav17_e,
            zav14_4,zav18,zav18_e,zav14_5,zav19,zav19_e,zav14_6,zav20,zav20_e,
            zav14_7,zav21,zav21_e,zav14_8,zav22,zav22_e,zav14_9,zav23,zav23_e
 
         BEFORE INPUT
            LET g_firstin = FALSE
            CALL cl_qryparam_set_visible()
            LET g_firstin = TRUE
 
         ON CHANGE zav08_1
            CALL cl_qryparam_set_visible()
         ON CHANGE zav08_2
            CALL cl_qryparam_set_visible()
         ON CHANGE zav08_3
            CALL cl_qryparam_set_visible()
         ON CHANGE zav08_4
            CALL cl_qryparam_set_visible()
         ON CHANGE zav08_5
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_1
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_2
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_3
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_4
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_5
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_6
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_7
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_8
            CALL cl_qryparam_set_visible()
         ON CHANGE zav14_9
            CALL cl_qryparam_set_visible()
 
         AFTER INPUT
            LET g_zav.zav06 = GET_FLDBUF(zav06)
            LET g_zav.zav07 = GET_FLDBUF(zav07)
            LET g_zav.zav09 = GET_FLDBUF(zav09)
            LET g_zav.zav10 = GET_FLDBUF(zav10)
            LET g_zav.zav11 = GET_FLDBUF(zav11)
            LET g_zav.zav12 = GET_FLDBUF(zav12)
            LET g_zav.zav13 = GET_FLDBUF(zav13)
            LET g_zav.zav15 = GET_FLDBUF(zav15)
            LET g_zav.zav16 = GET_FLDBUF(zav16)
            LET g_zav.zav17 = GET_FLDBUF(zav17)
            LET g_zav.zav18 = GET_FLDBUF(zav18)
            LET g_zav.zav19 = GET_FLDBUF(zav19)
            LET g_zav.zav20 = GET_FLDBUF(zav20)
            LET g_zav.zav21 = GET_FLDBUF(zav21)
            LET g_zav.zav22 = GET_FLDBUF(zav22)
            LET g_zav.zav23 = GET_FLDBUF(zav23)
            LET g_zav08.zav08_1 = GET_FLDBUF(zav08_1)
            LET g_zav08.zav08_2 = GET_FLDBUF(zav08_2)
            LET g_zav08.zav08_3 = GET_FLDBUF(zav08_3)
            LET g_zav08.zav08_4 = GET_FLDBUF(zav08_4)
            LET g_zav08.zav08_5 = GET_FLDBUF(zav08_5)
            LET g_zav_e.zav09_e = GET_FLDBUF(zav09_e)
            LET g_zav_e.zav10_e = GET_FLDBUF(zav10_e)
            LET g_zav_e.zav11_e = GET_FLDBUF(zav11_e)
            LET g_zav_e.zav12_e = GET_FLDBUF(zav12_e)
            LET g_zav_e.zav13_e = GET_FLDBUF(zav13_e)
            LET g_zav14.zav14_1 = GET_FLDBUF(zav14_1)
            LET g_zav14.zav14_2 = GET_FLDBUF(zav14_2)
            LET g_zav14.zav14_3 = GET_FLDBUF(zav14_3)
            LET g_zav14.zav14_4 = GET_FLDBUF(zav14_4)
            LET g_zav14.zav14_5 = GET_FLDBUF(zav14_5)
            LET g_zav14.zav14_6 = GET_FLDBUF(zav14_6)
            LET g_zav14.zav14_7 = GET_FLDBUF(zav14_7)
            LET g_zav14.zav14_8 = GET_FLDBUF(zav14_8)
            LET g_zav14.zav14_9 = GET_FLDBUF(zav14_9)
            LET g_zav_e.zav15_e = GET_FLDBUF(zav15_e)
            LET g_zav_e.zav16_e = GET_FLDBUF(zav16_e)
            LET g_zav_e.zav17_e = GET_FLDBUF(zav17_e)
            LET g_zav_e.zav18_e = GET_FLDBUF(zav18_e)
            LET g_zav_e.zav19_e = GET_FLDBUF(zav19_e)
            LET g_zav_e.zav20_e = GET_FLDBUF(zav20_e)
            LET g_zav_e.zav21_e = GET_FLDBUF(zav21_e)
            LET g_zav_e.zav22_e = GET_FLDBUF(zav22_e)
            LET g_zav_e.zav23_e = GET_FLDBUF(zav23_e)
 
         #No.TQC-860016 --start--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
         #No.TQC-860016 ---end---
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
      ELSE
         IF cl_null(g_zav.zav01) OR cl_null(g_zav.zav02) OR cl_null(g_zav.zav03) OR
            cl_null(g_zav.zav04) OR cl_null(g_zav.zav05) OR cl_null(g_zav.zav24) THEN
            CONTINUE WHILE
         END IF
         FOR li_i = 1 TO 5
             IF g_zav.zav08[li_i] = "2" THEN 
                CASE li_i
                   WHEN 1
                      LET g_zav.zav09 = g_zav_e.zav09_e
                   WHEN 2
                      LET g_zav.zav10 = g_zav_e.zav10_e
                   WHEN 3
                      LET g_zav.zav11 = g_zav_e.zav11_e
                   WHEN 4
                      LET g_zav.zav12 = g_zav_e.zav12_e
                   WHEN 5
                      LET g_zav.zav13 = g_zav_e.zav13_e
                END CASE
             END IF
         END FOR
         FOR li_i = 1 TO 9
             IF g_zav.zav14[li_i] = "2" THEN
                CASE
                   WHEN 1
                      LET g_zav.zav15 = g_zav_e.zav15_e
                   WHEN 2
                      LET g_zav.zav16 = g_zav_e.zav16_e
                   WHEN 3
                      LET g_zav.zav17 = g_zav_e.zav17_e
                   WHEN 4
                      LET g_zav.zav18 = g_zav_e.zav18_e
                   WHEN 5
                      LET g_zav.zav19 = g_zav_e.zav19_e
                   WHEN 6
                      LET g_zav.zav20 = g_zav_e.zav20_e
                   WHEN 7
                      LET g_zav.zav21 = g_zav_e.zav21_e
                   WHEN 8
                      LET g_zav.zav22 = g_zav_e.zav22_e
                   WHEN 9
                      LET g_zav.zav23 = g_zav_e.zav23_e
                END CASE
             END IF
         END FOR
         LET g_zav.zav08 = g_zav08.zav08_1,g_zav08.zav08_2,g_zav08.zav08_3,g_zav08.zav08_4,g_zav08.zav08_5
         LET g_zav.zav14 = g_zav14.zav14_1,g_zav14.zav14_2,g_zav14.zav14_3,g_zav14.zav14_4,g_zav14.zav14_5,g_zav14.zav14_6,g_zav14.zav14_7,g_zav14.zav14_8,g_zav14.zav14_9
         IF lc_cmd = "a" THEN
            INSERT INTO zav_file VALUES(g_zav.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","zav_file",g_zav.zav02,g_zav.zav03,SQLCA.sqlcode,"","",1)
            END IF
         ELSE
            UPDATE zav_file SET zav06 = g_zav.zav06,zav07 = g_zav.zav07,
                                zav08 = g_zav.zav08,zav09 = g_zav.zav09,
                                zav10 = g_zav.zav10,zav11 = g_zav.zav11,
                                zav12 = g_zav.zav12,zav13 = g_zav.zav13,
                                zav14 = g_zav.zav14,zav15 = g_zav.zav15,
                                zav16 = g_zav.zav16,zav17 = g_zav.zav17,
                                zav18 = g_zav.zav18,zav19 = g_zav.zav19,
                                zav20 = g_zav.zav20,zav21 = g_zav.zav21,
                                zav22 = g_zav.zav22,zav23 = g_zav.zav23
             WHERE zav01 = g_zav.zav01 AND zav02 = g_zav.zav02 AND zav03 = g_zav.zav03
               AND zav04 = g_zav.zav04 AND zav05 = g_zav.zav05 AND zav24 = g_zav.zav24
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","zav_file",g_zav.zav02,g_zav.zav03,SQLCA.sqlcode,"","",1)
             END IF
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE WINDOW set_qryparam_w
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 設定動態開窗畫面元件的X軸位置
# Date & Author..: 07/01/25 By saki
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_qryparam_set_posX()
# Memo...........:
##################################################
FUNCTION cl_qryparam_set_posX()
   DEFINE   lwin_curr  ui.Window
   DEFINE   lfrm_curr  ui.Form
   DEFINE   lnode_item om.DomNode
   DEFINE   li_posX    LIKE type_file.num5
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_item = lfrm_curr.findNode("FormField","zav_file.zav09")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      LET li_posX = lnode_item.getAttribute("posX")
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav09_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav11_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav13_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav15_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav17_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav19_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav21_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav23_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","zav_file.zav10")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      LET li_posX = lnode_item.getAttribute("posX")
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav10_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav12_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav16_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav18_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav20_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
   LET lnode_item = lfrm_curr.findNode("FormField","formonly.zav22_e")
   LET lnode_item = lnode_item.getFirstChild()
   IF lnode_item IS NOT NULL THEN
      CALL lnode_item.setAttribute("posX",li_posX)
   END IF
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 設定動態開窗的ComboBox
# Date & Author..: 07/01/25 By saki
# Input Parameter: pc_zav02   程式代碼/查詢單id
#                  pc_zav04   客製碼
#                  pc_zav05   行業別代碼
# Return code....: none
# Usage..........: CALL cl_qryparam_set_ComboBox(pc_zav02,pc_zav04,pc_zav05)
# Memo...........:
##################################################
FUNCTION cl_qryparam_set_ComboBox(pc_zav02,pc_zav04,pc_zav05)
   DEFINE   pc_zav02 LIKE zav_file.zav02
   DEFINE   pc_zav04 LIKE zav_file.zav04
   DEFINE   pc_zav05 LIKE zav_file.zav05
   DEFINE   ls_sql   STRING
   DEFINE   lc_gav02 LIKE gav_file.gav02
   DEFINE   ls_str   STRING
 
   LET ls_sql = "SELECT gav02 FROM gav_file ",
                " WHERE gav01='",pc_zav02 CLIPPED,"' AND gav08='",pc_zav04 CLIPPED,"'",
                "   AND gav11='",pc_zav05 CLIPPED,"' AND gav16 IS NOT NULL ORDER BY gav02"
   PREPARE gav02_pre FROM ls_sql
   DECLARE gav02_curs CURSOR FOR gav02_pre
   LET ls_str = "g_lang,"
   FOREACH gav02_curs INTO lc_gav02
      LET ls_str = ls_str,lc_gav02 CLIPPED,","
   END FOREACH
   LET ls_str = ls_str.subString(1,ls_str.getLength()-1)
 
   CALL cl_set_combo_items("zav09",ls_str.subString(7,ls_str.getLength()),ls_str.subString(7,ls_str.getLength()))
   CALL cl_set_combo_items("zav10",ls_str.subString(7,ls_str.getLength()),ls_str.subString(7,ls_str.getLength()))
   CALL cl_set_combo_items("zav11",ls_str.subString(7,ls_str.getLength()),ls_str.subString(7,ls_str.getLength()))
   CALL cl_set_combo_items("zav12",ls_str.subString(7,ls_str.getLength()),ls_str.subString(7,ls_str.getLength()))
   CALL cl_set_combo_items("zav13",ls_str.subString(7,ls_str.getLength()),ls_str.subString(7,ls_str.getLength()))
   CALL cl_set_combo_items("zav15",ls_str,ls_str)
   CALL cl_set_combo_items("zav16",ls_str,ls_str)
   CALL cl_set_combo_items("zav17",ls_str,ls_str)
   CALL cl_set_combo_items("zav18",ls_str,ls_str)
   CALL cl_set_combo_items("zav19",ls_str,ls_str)
   CALL cl_set_combo_items("zav20",ls_str,ls_str)
   CALL cl_set_combo_items("zav21",ls_str,ls_str)
   CALL cl_set_combo_items("zav22",ls_str,ls_str)
   CALL cl_set_combo_items("zav23",ls_str,ls_str)
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 設定動態開窗畫面原件是否隱藏
# Date & Author..: 07/01/25 By saki
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_qryparam_set_visible()
# Memo...........:
##################################################
FUNCTION cl_qryparam_set_visible()
   IF INFIELD(zav08_1) OR NOT g_firstin THEN
      IF g_zav08.zav08_1 = "2" THEN
         CALL cl_set_comp_visible("zav09",FALSE)
         CALL cl_set_comp_visible("zav09_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav09",TRUE)
         CALL cl_set_comp_visible("zav09_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav08_2) OR NOT g_firstin THEN
      IF g_zav08.zav08_2 = "2" THEN
         CALL cl_set_comp_visible("zav10",FALSE)
         CALL cl_set_comp_visible("zav10_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav10",TRUE)
         CALL cl_set_comp_visible("zav10_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav08_3) OR NOT g_firstin THEN
      IF g_zav08.zav08_3 = "2" THEN
         CALL cl_set_comp_visible("zav11",FALSE)
         CALL cl_set_comp_visible("zav11_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav11",TRUE)
         CALL cl_set_comp_visible("zav11_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav08_4) OR NOT g_firstin THEN
      IF g_zav08.zav08_4 = "2" THEN
         CALL cl_set_comp_visible("zav12",FALSE)
         CALL cl_set_comp_visible("zav12_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav12",TRUE)
         CALL cl_set_comp_visible("zav12_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav08_5) OR NOT g_firstin THEN
      IF g_zav08.zav08_5 = "2" THEN
         CALL cl_set_comp_visible("zav13",FALSE)
         CALL cl_set_comp_visible("zav13_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav13",TRUE)
         CALL cl_set_comp_visible("zav13_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_1) OR NOT g_firstin THEN
      IF g_zav14.zav14_1 = "2" THEN
         CALL cl_set_comp_visible("zav15",FALSE)
         CALL cl_set_comp_visible("zav15_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav15",TRUE)
         CALL cl_set_comp_visible("zav15_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_2) OR NOT g_firstin THEN
      IF g_zav14.zav14_2 = "2" THEN
         CALL cl_set_comp_visible("zav16",FALSE)
         CALL cl_set_comp_visible("zav16_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav16",TRUE)
         CALL cl_set_comp_visible("zav16_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_3) OR NOT g_firstin THEN
      IF g_zav14.zav14_3 = "2" THEN
         CALL cl_set_comp_visible("zav17",FALSE)
         CALL cl_set_comp_visible("zav17_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav17",TRUE)
         CALL cl_set_comp_visible("zav17_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_4) OR NOT g_firstin THEN
      IF g_zav14.zav14_4 = "2" THEN
         CALL cl_set_comp_visible("zav18",FALSE)
         CALL cl_set_comp_visible("zav18_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav18",TRUE)
         CALL cl_set_comp_visible("zav18_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_5) OR NOT g_firstin THEN
      IF g_zav14.zav14_5 = "2" THEN
         CALL cl_set_comp_visible("zav19",FALSE)
         CALL cl_set_comp_visible("zav19_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav19",TRUE)
         CALL cl_set_comp_visible("zav19_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_6) OR NOT g_firstin THEN
      IF g_zav14.zav14_6 = "2" THEN
         CALL cl_set_comp_visible("zav20",FALSE)
         CALL cl_set_comp_visible("zav20_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav20",TRUE)
         CALL cl_set_comp_visible("zav20_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_7) OR NOT g_firstin THEN
      IF g_zav14.zav14_7 = "2" THEN
         CALL cl_set_comp_visible("zav21",FALSE)
         CALL cl_set_comp_visible("zav21_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav21",TRUE)
         CALL cl_set_comp_visible("zav21_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_8) OR NOT g_firstin THEN
      IF g_zav14.zav14_8 = "2" THEN
         CALL cl_set_comp_visible("zav22",FALSE)
         CALL cl_set_comp_visible("zav22_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav22",TRUE)
         CALL cl_set_comp_visible("zav22_e",FALSE)
      END IF
   END IF
   IF INFIELD(zav14_9) OR NOT g_firstin THEN
      IF g_zav14.zav14_9 = "2" THEN
         CALL cl_set_comp_visible("zav23",FALSE)
         CALL cl_set_comp_visible("zav23_e",TRUE)
      ELSE
         CALL cl_set_comp_visible("zav23",TRUE)
         CALL cl_set_comp_visible("zav23_e",FALSE)
      END IF
   END IF
END FUNCTION
#No.FUN-710055
