# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aoop700.4gl  
# Descriptions...: 程序自動執行作業
# Date & Author..: 12/09/06 By fengrui  #FUN-C80092

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_cka   DYNAMIC ARRAY OF RECORD LIKE cka_file.*       
DEFINE g_gga           RECORD 
          gga01        LIKE gga_file.gga01,
          gga02        LIKE gga_file.gga02,
          yy           LIKE type_file.num5,
          mm           LIKE type_file.num5
                       END RECORD 
DEFINE l_ac            LIKE type_file.num10                       
DEFINE g_sql           STRING
DEFINE g_wc_o          STRING
DEFINE g_idx           LIKE type_file.num5
DEFINE g_tree DYNAMIC ARRAY OF RECORD
             name           STRING,                 #节点名称
             pid            LIKE ima_file.ima01,    #父节点id
             id             LIKE ima_file.ima01,    #节点id
             has_children   BOOLEAN,                #1:有子节点, null:无子节点
             expanded       BOOLEAN,                #0:不展开, 1展开
             level          LIKE type_file.num5,    #层级
             path           STRING,
             treekey1       STRING,
             treekey2       STRING,
             gga01          LIKE gga_file.gga01,
             ggb02          LIKE ggb_file.ggb02,
             img            STRING 
        END RECORD
DEFINE g_tree_focus_idx     STRING                  #当前节点数
DEFINE g_tree_focus_path    STRING
DEFINE g_tree_arr_curr      LIKE type_file.num5
DEFINE g_tree_reload        LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_tree_item          LIKE gga_file.gga01
DEFINE p_row,p_col          LIKE type_file.num5 
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10 
DEFINE g_rec_b              LIKE type_file.num5
DEFINE g_cnt,g_cnt1,g_cnt2  LIKE type_file.num5 
DEFINE g_wc2                STRING
DEFINE g_ver_no             LIKE cka_file.cka11

MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET p_row = 1 LET p_col = 3
   OPEN WINDOW p700_w AT p_row,p_col WITH FORM "aoo/42f/aoop700"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_init()
   CALL cl_set_comp_visible("ckaud01,ckaud02,ckaud03,ckaud04,ckaud05,ckaud06,ckaud07,
            ckaud08,ckaud09,ckaud10,ckaud11,ckaud12,ckaud13,ckaud14,ckaud15",FALSE)
            
   LET g_tree_reload = "Y"                             #tree是否要重新整理 Y/N
   LET g_tree_focus_idx = 0                            #focus节点index
   CALL p700_q() #free add
   CALL p700_menu()
   CLOSE WINDOW p700_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p700_menu()
   WHILE TRUE
      CALL p700_bp("G")       
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p700_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cka),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() THEN
               IF g_gga.gga01 IS NOT NULL THEN
                  LET g_doc.column1 = "gga01"
                  LET g_doc.column2 = "gga02"
                  LET g_doc.value1 = g_gga.gga01
                  LET g_doc.value2 = g_gga.gga02
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION p700_curs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
DEFINE  l_cka11         LIKE cka_file.cka11
DEFINE  l_n             LIKE type_file.num5

   CLEAR FORM
   LET g_wc2 = ''
   LET g_cnt1 = ''
   LET g_cnt2 = ''
   LET g_ver_no = ''
   LET g_tree_item = ''
   INITIALIZE g_gga.* TO NULL 
   CALL g_cka.clear()
   CALL g_tree.clear()
   CALL p700_picclear()  
   CALL cl_set_head_visible("","YES")
    
   INPUT BY NAME g_gga.gga01,g_gga.yy,g_gga.mm
      BEFORE INPUT 
         SELECT ccz01,ccz02 INTO g_gga.yy,g_gga.mm
           FROM ccz_file WHERE ccz00='0'
         DISPLAY BY NAME g_gga.yy,g_gga.mm

      AFTER FIELD gga01
         IF NOT cl_null(g_gga.gga01) THEN 
            SELECT COUNT(*) INTO l_n 
              FROM gga_file 
             WHERE gga01 = g_gga.gga01
            IF l_n <> 1 THEN 
               CALL cl_err(g_gga.gga01,'tri-006',0)
               NEXT FIELD gga01 
            END IF 
            SELECT COUNT(*) INTO l_n 
              FROM gga_file 
             WHERE gga01 = g_gga.gga01
               AND ggaacti = 'N' 
            IF l_n = 1 THEN 
               CALL cl_err(g_gga.gga01,'tri-009',0)
               NEXT FIELD gga01 
            END IF 
            SELECT gga02 INTO g_gga.gga02 
              FROM gga_file 
             WHERE gga01 = g_gga.gga01
               AND ggaacti = 'Y'  
            DISPLAY BY NAME g_gga.gga02             
         END IF 

      AFTER FIELD yy
         IF NOT cl_null(g_gga.yy) AND (g_gga.yy<1000 OR g_gga.yy>9999) THEN 
            CALL cl_err(g_gga.yy,'afa-370',0)
            NEXT FIELD yy
         END IF 

      AFTER FIELD mm
         IF NOT cl_null(g_gga.mm) AND g_gga.mm<1 OR g_gga.mm>12 THEN 
            CALL cl_err(g_gga.mm,'agl-020',0)
            NEXT FIELD mm
         END IF 

      ON ACTION controlp
         IF INFIELD(gga01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gga"
            LET g_qryparam.default1 = g_gga.gga01
            CALL cl_create_qry() RETURNING g_gga.gga01
            SELECT gga02 INTO g_gga.gga02 
              FROM gga_file 
             WHERE gga01 = g_gga.gga01
               AND ggaacti = 'Y'  
            DISPLAY BY NAME g_gga.gga01,g_gga.gga02 
            NEXT FIELD gga01
         END IF
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG 
         CALL cl_cmdask()    
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
           
      ON ACTION about         
         CALL cl_about()     
         
      ON ACTION help         
         CALL cl_show_help() 
           
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
            
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
   IF INT_FLAG THEN INITIALIZE g_gga.* TO NULL RETURN END IF
      
   INPUT l_cka11 WITHOUT DEFAULTS FROM cka11
      AFTER FIELD cka11
         IF NOT cl_null(l_cka11) THEN 
            SELECT count(DISTINCT cka11) INTO l_n 
              FROM cka_file
              WHERE cka11 = l_cka11
            IF l_n <> 1 THEN 
               CALL cl_err(l_cka11,'aoo-231',0)
               NEXT FIELD cka11 
            END IF 
         END IF 
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG 
         CALL cl_cmdask()    
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
           
      ON ACTION about         
         CALL cl_about()     
         
      ON ACTION help         
         CALL cl_show_help() 
           
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
            
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT

   IF INT_FLAG THEN LET g_wc2 = '' RETURN END IF
   IF NOT cl_null(l_cka11) THEN 
      LET g_wc2=" cka11='",l_cka11,"' "
      LET g_ver_no=l_cka11
   END IF 
   LET g_wc_o = " gga01='",g_gga.gga01 CLIPPED, "'"   
   
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ggauser', 'ggagrup')
   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF 

   LET g_sql="SELECT gga01 FROM gga_file ",            
             " WHERE gga01 = '",g_gga.gga01 CLIPPED, "' ",
             " ORDER BY gga01 "  
   PREPARE p700_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE p700_curs SCROLL CURSOR WITH HOLD FOR p700_prepare   

END FUNCTION

FUNCTION p700_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gga.* TO NULL     
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cka.clear()
    CALL p700_curs()      
    IF INT_FLAG THEN
       INITIALIZE g_gga.* TO NULL
       CALL g_tree.clear()
       LET g_tree_focus_idx =0
       LET INT_FLAG = 0
       RETURN
    END IF

    MESSAGE " SEARCHING ! "
    OPEN p700_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                     
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gga.* TO NULL
    ELSE
       FETCH p700_curs INTO g_gga.gga01
       CALL p700_show()
    END IF
    MESSAGE " "
END FUNCTION

FUNCTION p700_show()
    DISPLAY BY NAME g_gga.gga01, g_gga.gga02

    IF cl_null(g_wc2) THEN
      LET g_wc2 = " 1=1"
    END IF
    IF cl_null(g_tree_item) THEN
       CALL g_tree.clear()
       CALL p700_tree_fill(g_wc_o,NULL,0,NULL,NULL,NULL,g_gga.gga01)    
    END IF
    CALL p700_b_fill()                      
    CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION p700_b_fill()              

    SELECT gga02 INTO g_gga.gga02 FROM gga_file WHERE gga01 = g_gga.gga01
    IF cl_null(g_wc2) THEN LET g_wc2=' 1=1' END IF  

    IF g_wc2 = ' 1=1' THEN CALL g_cka.clear() RETURN END IF 
    LET g_sql = "SELECT * FROM cka_file",
                " WHERE ", g_wc2 ,
                " ORDER BY cka00"

    PREPARE p700_pb FROM g_sql
    DECLARE cka_curs CURSOR FOR p700_pb

    CALL g_cka.clear()
   LET g_cnt = 1

   FOREACH cka_curs INTO g_cka[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF   
   END FOREACH 
   CALL g_cka.deleteElement(g_cnt)

   LET g_sql = "SELECT count(*) FROM cka_file",
               " WHERE (", g_wc2 ,") ",
               "   AND cka10 = 'Y' ",
               " ORDER BY cka00"
   PREPARE p700_suc_pre FROM g_sql
   DECLARE p700_suc_cs1 CURSOR FOR p700_suc_pre
   OPEN p700_suc_cs1 
   FETCH p700_suc_cs1 INTO g_cnt1
   
   LET g_sql = "SELECT count(*) FROM cka_file",
               " WHERE (", g_wc2 ,") ",
               "   AND cka10 = 'N' ",
               " ORDER BY cka00"

   PREPARE p700_fai_pre FROM g_sql
   DECLARE p700_fai_cs2 CURSOR FOR p700_fai_pre
   OPEN p700_fai_cs2 
   FETCH p700_fai_cs2 INTO g_cnt2
END FUNCTION

FUNCTION p700_bp(p_ud)
   DEFINE  p_ud              LIKE type_file.chr1  
   DEFINE  l_wc              LIKE type_file.chr1000    
   DEFINE  l_tree_arr_curr   LIKE type_file.num5
   DEFINE  l_i               LIKE type_file.num5
   DEFINE  l_cnt             LIKE type_file.num5

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   DISPLAY g_cnt1,g_cnt2,g_ver_no TO cn1,cn2,ver
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME g_gga.*
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_tree_focus_idx <= 0 THEN
               LET g_tree_focus_idx = ARR_CURR()
            END IF

         BEFORE ROW
            LET l_tree_arr_curr = ARR_CURR() #目前在tree的row
            LET g_tree_arr_curr = ARR_CURR()
            LET g_tree_focus_path = g_tree[l_tree_arr_curr].path
               #有子節點就focus在此，沒有子節點就focus在它的父節點
               IF g_tree[l_tree_arr_curr].has_children THEN
                  LET g_tree_focus_idx = l_tree_arr_curr CLIPPED
               ELSE
                  CALL cl_str_sepcnt(g_tree_focus_path,".") RETURNING l_i  #依分隔符號分隔字串後的item數量
                  IF l_i > 1 THEN
                     CALL cl_str_sepsub(g_tree_focus_path CLIPPED,".",1,l_i-1) RETURNING g_tree_focus_path #依分隔符號分隔字串後，截取
                  END IF
               END IF

         ON ACTION accept             #双击时如果是锁定状态并且是尾阶料号，则让用户输入状态
            LET g_tree_item = g_tree[l_tree_arr_curr].treekey2
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM gga_file
             WHERE gga01 = g_tree_item
            IF l_cnt > 0 THEN
               IF cl_confirm('aoo-276') THEN
                  CALL p700_run_all(l_tree_arr_curr)
               END IF
            ELSE 
               CALL p700_run_one(l_tree_arr_curr) 
            END IF
            EXIT DIALOG  
            
      END DISPLAY

      DISPLAY ARRAY g_cka TO s_cka.* ATTRIBUTE(COUNT=g_rec_b)     
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL cl_show_fld_cont()  

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()       

         AFTER DISPLAY
            CONTINUE DIALOG

      END DISPLAY

      BEFORE DIALOG
          LET l_tree_arr_curr = 1
          LET l_ac = 1

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                    

      ON ACTION autorun
         #爲了單隻運行光標停留在所在行，將調用寫到dialog內部.  #添加单只刷新树,故光标无法控制.
         LET g_tree_item = g_tree[l_tree_arr_curr].treekey2
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM gga_file
          WHERE gga01 = g_tree_item
         IF l_cnt > 0 AND cl_confirm('aoo-276') THEN
            CALL p700_run_all(l_tree_arr_curr)
         ELSE 
            CALL p700_run_one(l_tree_arr_curr)
         END IF
         EXIT DIALOG  

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG            

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG                         

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG       

      ON ACTION controlg      
         CALL cl_cmdask()   

      ON ACTION about      
         CALL cl_about()  

   END DIALOG  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p700_tree_fill(p_wc,p_pid,p_level,p_path,p_key1,p_key2,p_gga01)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE p_gga01            LIKE gga_file.gga01             
   DEFINE l_child            INTEGER
   DEFINE l_gga              DYNAMIC ARRAY OF RECORD
             gga01           LIKE gga_file.gga01,
             ggb03           LIKE ggb_file.ggb03,
             child_cnt       LIKE type_file.num5  #子節點數
             END RECORD
   DEFINE l_ggb              DYNAMIC ARRAY OF RECORD
              ggb02          LIKE ggb_file.ggb02,
              ggb03          LIKE ggb_file.ggb03,
              ggb04          LIKE ggb_file.ggb04
              END RECORD
   DEFINE l_sql              STRING
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5 
   DEFINE l_count            LIKE type_file.num5
   DEFINE l_gga02            LIKE gga_file.gga02
   DEFINE l_gaz03            LIKE gaz_file.gaz03

   LET max_level = 20 #設定最大階層數為20
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF 
   
   IF p_level = 0 THEN
      LET g_idx = 0
      LET p_level = 1
      CALL g_tree.clear()
      CALL l_gga.clear()
      
      #讓QBE出來的單頭都當作Tree的最上層
      LET l_ac = 1
      LET l_sql = "SELECT DISTINCT ggb01,ggb01 as ggb03,COUNT(ggb03) as child_cnt FROM ggb_file,gga_file", 
                  " WHERE ", p_wc CLIPPED,
                  "   AND ggb01 = gga_file.gga01 ",
                  "   AND gga01 = '",p_gga01 CLIPPED,"'", 
                  "   AND ggaacti = 'Y' ",   
                  " GROUP BY ggb01",
                  " ORDER BY ggb01"  
      PREPARE p700_tree_pre1 FROM l_sql
      DECLARE p700_tree_cs1 CURSOR FOR p700_tree_pre1  
      LET l_i = 1
      FOREACH p700_tree_cs1 INTO l_gga[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF   
         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = NULL
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = l_str
         LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
         SELECT gga02 INTO l_gga02 FROM gga_file
          WHERE gga01 = l_gga[l_i].gga01
         LET g_tree[g_idx].name = l_gga[l_i].gga01,' ',l_gga02
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].path = l_gga[l_i].ggb03
         LET g_tree[g_idx].treekey1 = l_gga[l_i].gga01
         LET g_tree[g_idx].treekey2 = l_gga[l_i].ggb03
         LET g_tree[g_idx].gga01 = l_gga[l_i].gga01    
         LET g_tree[g_idx].ggb02 = ''

        # 有子節點
         IF l_gga[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL p700_tree_fill(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,
                                g_tree[g_idx].treekey2,l_gga[l_i].gga01)
         ELSE
            LET g_tree[g_idx].img = 'time'  #FUN-C80092
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH    
   ELSE
      IF p_level <= 20 THEN               #FUN-B90117
         LET p_level = p_level + 1   #下一階層
         IF p_level > max_level THEN
            CALL cl_err_msg("","agl1001",max_level,0)
            RETURN
         END IF      
         LET l_sql = "SELECT UNIQUE ggb02,ggb03,ggb04 ", 
                     " FROM  gga_file,ggb_file ",             
                     "WHERE  ggb01 = '", p_key1 CLIPPED,"' ",                                        
                     "  AND ggb01 = gga01 ",     
                     "  AND ggbacti = 'Y' ",                     
                     "ORDER BY ggb02 "    
         PREPARE p700_tree_pre2 FROM l_sql
         DECLARE p700_tree_cs2 CURSOR FOR p700_tree_pre2

         #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
         LET l_cnt = 1
         CALL l_ggb.clear()
         FOREACH p700_tree_cs2 INTO l_ggb[l_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL l_ggb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
         LET l_cnt = l_cnt - 1
         IF l_cnt >0 THEN
            FOR l_i=1 TO l_cnt
               LET g_idx = g_idx + 1
               LET g_tree[g_idx].pid = p_pid CLIPPED
               LET l_str = l_i  #數值轉字串
               LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
               LET g_tree[g_idx].expanded = TRUE   #TRUE:展開, FALSE:不展開
               #判斷是流程編號還是程式編號
               SELECT COUNT(*) INTO l_count FROM gga_file,ggb_file 
                WHERE gga01 = ggb01
                  AND ggb01 = l_ggb[l_i].ggb03   
               IF cl_null(l_count) THEN LET l_count = 0 END IF
               IF l_count > 0 THEN  #流程編號
                  SELECT gga02 INTO l_gga02 FROM gga_file
                   WHERE gga01 = l_ggb[l_i].ggb03 
                  LET g_tree[g_idx].name = l_ggb[l_i].ggb03,' ',l_gga02
               ELSE        
                  SELECT gaz03 INTO l_gaz03 FROM gaz_file
                   WHERE gaz01 = l_ggb[l_i].ggb03
                     AND gaz02 = g_lang
                  LET g_tree[g_idx].name = l_ggb[l_i].ggb02,'  ',l_ggb[l_i].ggb03,'-',l_gaz03
               END IF                 
               LET g_tree[g_idx].level = p_level
               LET g_tree[g_idx].path = p_path CLIPPED,".",l_ggb[l_i].ggb03
               LET g_tree[g_idx].treekey1 = l_gga[l_i].gga01
               LET g_tree[g_idx].treekey2 = l_ggb[l_i].ggb03
               LET g_tree[g_idx].gga01 = p_key1
               LET g_tree[g_idx].ggb02 = l_ggb[l_i].ggb02
               #有子節點
               SELECT COUNT(ggb03) INTO l_child FROM ggb_file WHERE ggb01 = l_ggb[l_i].ggb03
               IF l_child > 0 AND p_level <= max_level THEN 
                  LET g_tree[g_idx].has_children = TRUE
                  CALL p700_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,
                                      g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
               ELSE
                  LET g_tree[g_idx].img = 'time'  #FUN-C80092
                  LET g_tree[g_idx].has_children = FALSE
               END IF
            END FOR
         END IF
      END IF            
   END IF
END FUNCTION 


FUNCTION p700_tree_fill2(p_wc,p_pid,p_level,p_path,p_key1,p_key2)
   DEFINE p_wc               STRING               #查詢條件
   DEFINE p_pid              STRING               #父節點id
   DEFINE p_level            LIKE type_file.num5  #階層
   DEFINE p_path             STRING               #節點路徑
   DEFINE p_key1             STRING
   DEFINE p_key2             STRING
   DEFINE l_child            INTEGER
   DEFINE l_ggb              DYNAMIC ARRAY OF RECORD
              ggb02           LIKE ggb_file.ggb02,
              ggb03           LIKE ggb_file.ggb03,
              ggb04           LIKE ggb_file.ggb04              
              END RECORD
   DEFINE l_sql              STRING
   DEFINE l_count            LIKE type_file.num5 
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5  #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_gga02            LIKE gga_file.gga02
   DEFINE l_gaz03            LIKE gaz_file.gaz03

   LET max_level = 20 #設定最大階層數為20  
   LET p_level = p_level+1  
   IF p_level > max_level THEN
      CALL cl_err_msg("","mfg-087",max_level,1)
      RETURN
   END IF   
   LET l_sql = "SELECT UNIQUE ggb02,ggb03,ggb04 ",
                " FROM ggb_file ",
                "WHERE  ggb01 = '", p_key2 CLIPPED,"'",
                "  AND ggbacti = 'Y' ",  
                " ORDER BY ggb02"

   PREPARE p700_tree_pre3 FROM l_sql
   DECLARE p700_tree_cs3 CURSOR FOR p700_tree_pre3

   #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
   LET l_cnt = 1
   CALL l_ggb.clear()   
   FOREACH p700_tree_cs3 INTO l_ggb[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_ggb.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
      FOR l_i=1 TO l_cnt   
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = TRUE    #TRUE:展開, FALSE:不展開
            
            #判斷是流程編號還是程式編號
            SELECT COUNT(*) INTO l_count FROM gga_file,ggb_file 
             WHERE gga01 = ggb01
               AND ggb01 = l_ggb[l_i].ggb03   
            IF cl_null(l_count) THEN LET l_count = 0 END IF
            IF l_count > 0 THEN  #流程編號
               SELECT gga02 INTO l_gga02 FROM gga_file
                WHERE gga01 = l_ggb[l_i].ggb03
               LET g_tree[g_idx].name = l_ggb[l_i].ggb03,' ',l_gga02
            ELSE        
               SELECT gaz03 INTO l_gaz03 FROM gaz_file
                WHERE gaz01 = l_ggb[l_i].ggb03
                  AND gaz02 = g_lang
               LET g_tree[g_idx].name = l_ggb[l_i].ggb02,'  ',l_ggb[l_i].ggb03,'-',l_gaz03
            END IF               

            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].path = p_path CLIPPED,".",l_ggb[l_i].ggb03
            LET g_tree[g_idx].treekey2 = l_ggb[l_i].ggb03
            LET g_tree[g_idx].gga01 = p_key2
            LET g_tree[g_idx].ggb02 = l_ggb[l_i].ggb02 

            SELECT COUNT(ggb03) INTO l_child FROM ggb_file WHERE ggb01 = l_ggb[l_i].ggb03

            IF l_child > 0 AND p_level <= max_level THEN 
               LET g_tree[g_idx].has_children = TRUE
               CALL p700_tree_fill2(p_wc,g_tree[g_idx].id,p_level,g_tree[g_idx].path,g_tree[g_idx].treekey1,g_tree[g_idx].treekey2)
            ELSE
               LET g_tree[g_idx].img = 'time'  #FUN-C80092
               LET g_tree[g_idx].has_children = FALSE
            END IF
      END FOR
   END IF            
END FUNCTION 

FUNCTION p700_run_all(p_cnt)
DEFINE p_cnt   LIKE type_file.num5
DEFINE n       LIKE type_file.num5
DEFINE i       LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5
DEFINE l_str   STRING 
DEFINE l_str_tmp STRING 
DEFINE l_avg   STRING 
DEFINE l_cmd   STRING 
DEFINE l_ver_tf    LIKE type_file.chr1      #是否依照版本號繼續執行
DEFINE l_ver_cnt   LIKE type_file.num5      #程式所對應tree的行數
DEFINE l_bdate     LIKE type_file.dat
DEFINE l_edate     LIKE type_file.dat
DEFINE l_cka01 LIKE cka_file.cka01
DEFINE l_cka10 LIKE cka_file.cka10 
DEFINE l_cka10_new LIKE cka_file.cka10 
DEFINE l_cka11 LIKE cka_file.cka11      #版本号
DEFINE l_cka11_old LIKE cka_file.cka11  #版本号 已存在
DEFINE l_cka   RECORD LIKE cka_file.*
DEFINE l_ggb   RECORD LIKE ggb_file.*
DEFINE l_ccz01  LIKE ccz_file.ccz01
DEFINE l_ccz02  LIKE ccz_file.ccz02
DEFINE l_msg      STRING 
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_must     LIKE type_file.chr1     #根據父節點判斷子節點是否必須 
DEFINE l_cka05    LIKE cka_file.cka05
DEFINE l_continue LIKE  type_file.chr1
DEFINE l_father DYNAMIC ARRAY OF RECORD  #用於判斷子節點是否需要運行,是否必須運行 .
       id       LIKE ima_file.ima01,
       run1     LIKE type_file.chr1,
       must     LIKE ggb_file.ggb05      #父節點為N ,則子節點 有 child的節點為 N [此時ggb_file 值為Y 也給N].
                END RECORD 

   SELECT ccz01,ccz02 INTO l_ccz01,l_ccz02
     FROM ccz_file WHERE ccz00='0'
   IF g_gga.yy <> l_ccz01 OR g_gga.mm <> l_ccz02 THEN 
      CALL cl_err('','aoo-273',1)
      RETURN 
   END IF 
   LET l_ver_tf = FALSE 
   IF cl_null(p_cnt) OR p_cnt<=0 THEN RETURN END IF
   #生成版本号
   IF cl_null(g_ver_no) THEN 
      SELECT MAX(cka11) INTO l_cka11_old FROM cka_file 
      IF cl_null(l_cka11_old) THEN 
         LET l_cka11 = TODAY USING 'yymmdd' 
         LET l_cka11 = l_cka11 , '001'
      ELSE
         LET l_cka11 = TODAY USING 'yymmdd'
         LET l_cka11 = l_cka11 , '001'
         IF l_cka11 <= l_cka11_old THEN
            LET l_cka11 = l_cka11_old + 1
         END IF 
      END IF
      LET g_ver_no =  l_cka11
      IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF 
      IF g_wc2 = " 1=1" THEN 
         LET g_wc2 = " cka11 = '", l_cka11 ,"' "
      ELSE 
         LET g_wc2 = g_wc2, " OR cka11 = '", l_cka11 ,"' "
      END IF 
   ELSE 
      CALL cl_getmsg('aoo-274',g_lang) RETURNING l_msg
      LET l_msg = cl_replace_str(l_msg,"%1",g_ver_no)
      PROMPT l_msg CLIPPED,'  ' FOR l_ver_tf
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
      END PROMPT
      IF INT_FLAG THEN
         RETURN 
      END IF
      IF cl_null(l_ver_tf) THEN 
         RETURN 
      ELSE 
         IF l_ver_tf <> 1 THEN 
            LET l_ver_tf = FALSE 
            CALL p700_picclear()   
         ELSE 
            LET l_ver_tf = TRUE 
         END IF
      END IF 
      
      IF l_ver_tf THEN  #根據已有版本號運行
         LET l_cka01 = ''  LET l_cka10 = ''
         SELECT cka01,cka10 INTO l_cka01,l_cka10 FROM cka_file 
          WHERE cka00 IN (SELECT MAX(cka00) FROM cka_file 
                        WHERE cka11 = g_ver_no )
         #查出最後運行程式對應行數,失敗為當前行,成功則行數加1
         FOR i=1 TO g_tree.getLength()
            IF g_tree[i].treekey2 = l_cka01 THEN 
               LET l_ver_cnt = i
               IF l_cka10 = 'Y' THEN 
                  LET l_ver_cnt = l_ver_cnt +1
               END IF 
               EXIT FOR 
            END IF    
         END FOR 
      ELSE   #產生新版本號
         SELECT MAX(cka11) INTO l_cka11_old FROM cka_file 
         IF cl_null(l_cka11_old) THEN 
            LET l_cka11 = TODAY USING 'yymmdd' 
            LET l_cka11 = l_cka11 , '001'
         ELSE
            LET l_cka11 = TODAY USING 'yymmdd'
            LET l_cka11 = l_cka11 , '001'
            IF l_cka11 <= l_cka11_old THEN
               LET l_cka11 = l_cka11_old + 1
            END IF 
         END IF
         LET g_ver_no =  l_cka11
         IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF 
         IF g_wc2 = " 1=1" THEN 
            LET g_wc2 = " cka11 = '", l_cka11 ,"' "
         ELSE 
            LET g_wc2 = g_wc2, " OR cka11 = '", l_cka11 ,"' "
         END IF 
      END IF 
   END IF 

   DISPLAY g_ver_no TO ver
   CALL ui.Interface.refresh()
   #FOR循環拉出節點下面的所有數據
   LET l_cnt = 1
   FOR i=p_cnt+1 TO g_tree.getLength()
      IF g_tree[i].level > g_tree[p_cnt].level THEN 

      
         #判斷節點是否要自動運行 #如果不是自動運行,根據父節點判斷是否必須.
         #根據主鍵抓對應單身那筆所有資料
         INITIALIZE l_ggb.* TO NULL 
         SELECT * INTO l_ggb.* FROM ggb_file 
          WHERE ggb01 = g_tree[i].gga01
            AND ggb02 = g_tree[i].ggb02
         
         IF g_tree[i].has_children THEN  #存在子節點

            LET l_continue = FALSE   
            FOR l_i=1 TO l_father.getLength() #查此節點是否在l_father中存在父節點
               IF l_father[l_i].id = g_tree[i].pid THEN  #若父節點也為不自動運行
                  LET l_father[l_cnt].id = g_tree[i].id 
                  IF l_father[l_i].run1 = 'N' THEN       
                     LET l_father[l_cnt].run1 = 'N'    #父節點為N 則為N ,父節點為Y 則為自己ggb04值
                  ELSE 
                     LET l_father[l_cnt].run1 = l_ggb.ggb04
                  END IF 
                  IF l_father[l_i].must = 'N' THEN       
                     LET l_father[l_cnt].must = 'N'    #父節點為N 則為N ,否則為自身 必須否
                  ELSE 
                     LET l_father[l_cnt].must = l_ggb.ggb05
                  END IF 
                  LET l_continue = TRUE 
                  LET l_cnt = l_cnt + 1
                  EXIT FOR 
               END IF 
            END FOR 
            IF l_continue THEN LET l_continue = FALSE CONTINUE FOR END IF 
            #在l_father中不存在父節點
            LET l_father[l_cnt].id   = g_tree[i].id 
            LET l_father[l_cnt].run1 = l_ggb.ggb04
            LET l_father[l_cnt].must = l_ggb.ggb05
            LET l_cnt = l_cnt + 1
            CONTINUE FOR 
         END IF 

         IF NOT g_tree[i].has_children THEN 
            FOR l_i=1 TO l_father.getLength()  #根據父節點改變子節點的值
               IF l_father[l_i].id = g_tree[i].pid THEN 
                  IF l_father[l_i].run1 = 'N' THEN       
                     LET l_ggb.ggb04 =  'N'    #父節點為N 則為N 
                  END IF 
                  IF l_father[l_i].must = 'N' THEN       
                     LET l_ggb.ggb05 = 'N'    #父節點為N 則為N 
                  END IF 
                  EXIT FOR 
               END IF 
            END FOR 
            
            IF l_ggb.ggb04 = 'N' AND l_ggb.ggb05 = 'N' THEN 
               CALL p700_pic(i,'5')  
               CONTINUE FOR 
            END IF     
            IF l_ggb.ggb04 = 'N' AND l_ggb.ggb05 = 'Y' THEN 
               LET l_must = 'Y'
               LET l_cka05=''
               FOR l_i=1 TO g_cka.getLength()
                  IF g_cka[l_i].cka01 = l_ggb.ggb03 AND g_cka[l_i].cka10 = 'Y' THEN 
                     IF cl_null(l_cka05) OR l_cka05 < g_cka[l_i].cka05 THEN
                        LET l_cka05=g_cka[l_i].cka05 
                        IF g_cka[l_i].cka10 = 'Y' THEN
                           LET l_must = 'N'  #l_must 為N代表 已經run過了，并成功了.
                        ELSE 
                           LET l_must = 'Y'
                        END IF
                     END IF
                  END IF 
               END FOR 
               IF l_must = 'Y' THEN  #g_cka中不存在對應的成功日誌 
                  CALL cl_err(l_ggb.ggb03,'aoo-278',1)
                  RETURN 
               ELSE 
                  CALL p700_pic(i,'1')  
                  CONTINUE FOR 
               END IF 
            END IF 
         END IF 

         #若比版本號對應程式行數小,則到下一筆.
         #若父节点不为自动运行，下面子节点跳过.
         IF i < l_ver_cnt AND l_ver_tf THEN CONTINUE FOR END IF 

         #判斷結束,自動運行程式準備
            
         IF l_ggb.ggbacti='Y' THEN 
            LET l_msg = ''
            CALL cl_getmsg('aoo-275',g_lang) RETURNING l_msg
            LET l_msg = l_msg,' ' ,l_ggb.ggb03,'...'
            MESSAGE l_msg 
            CALL p700_pic(i,'3')    
            LET l_avg = ''
            LET l_str = l_ggb.ggb06 
            FOR n=1 TO 150
               LET l_str_tmp = ''
               CALL cl_str_sepcnt(l_str,"|") RETURNING l_i  #依分隔符號分隔字串後的item數量
               IF l_i>1 THEN 
                  CALL cl_str_sepsub(l_str CLIPPED,"|",l_i,l_i) RETURNING l_str_tmp
                  CALL cl_str_sepsub(l_str CLIPPED,"|",1,l_i-1) RETURNING l_str
               ELSE 
                  IF l_i = 1 THEN LET l_str_tmp = l_str END IF 
               END IF 
               #新增項需要填補
               SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
               CALL s_azn01(g_gga.yy,g_gga.mm) RETURNING l_bdate,l_edate
               CASE l_str_tmp
                  WHEN 'yy'     LET l_str_tmp = g_gga.yy 
                  WHEN 'mm'     LET l_str_tmp = g_gga.mm 
                  WHEN 'date'   LET l_str_tmp = DATE 
                  WHEN 'plant'  LET l_str_tmp = g_plant
                  WHEN 'bookno' LET l_str_tmp = g_aaz.aaz64
                  WHEN 'type'   LET l_str_tmp = g_ccz.ccz28
                  WHEN 'bdate'  LET l_str_tmp = l_bdate 
                  WHEN 'edate'  LET l_str_tmp = l_edate
                  OTHERWISE EXIT CASE 
               END CASE 
               LET l_avg = " '",l_str_tmp,"' ",l_avg
               IF l_i <= 1 THEN 
                  MESSAGE '' 
                  EXIT FOR 
               END IF 
            END FOR 
            LET l_cmd = l_ggb.ggb03," ",l_avg
            
            CALL s_log_cka11(g_ver_no,l_ggb.ggb03,g_gga.yy,g_gga.mm,'1')          
            CALL cl_cmdrun_wait(l_cmd)
            CALL s_log_cka11('','','','','0')

            CALL p700_b_fill()                      
            CALL cl_show_fld_cont()  
            DISPLAY ARRAY g_cka TO s_cka.*
               BEFORE DISPLAY 
                  DISPLAY g_cnt1,g_cnt2 TO cn1,cn2
                  EXIT DISPLAY 
            END DISPLAY  
            LET l_cka10_new = ''
            SELECT cka10 INTO l_cka10_new FROM cka_file 
             WHERE cka01 = l_ggb.ggb03
               AND cka00 = (SELECT MAX(cka00) FROM cka_file
                              WHERE cka11 = g_ver_no )
            IF cl_null(l_cka10_new) THEN
               CALL p700_pic(i,'5')
            END IF
            IF l_cka10_new = 'Y' THEN 
               CALL p700_pic(i,'1') 
            END IF 
            IF l_cka10_new = 'N' THEN
               CALL p700_pic(i,'2')
            END IF 
            IF l_ggb.ggb05='Y' AND (l_cka10_new='N' OR cl_null(l_cka10_new))THEN 
               CALL cl_err(l_ggb.ggb03,'aoo-278',1)
               RETURN 
            ELSE 
               MESSAGE 'O.K' 
            END IF 
         ELSE 
              CALL p700_pic(i,'5')   
         END IF 
      ELSE 
         EXIT FOR 
      END IF 
   END FOR 
END FUNCTION

FUNCTION p700_run_one(p_cnt)
DEFINE p_cnt   LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5
DEFINE l_str   STRING 
DEFINE l_cka11 LIKE cka_file.cka11      #版本号
DEFINE l_cka11_old LIKE cka_file.cka11  #版本号 已存在
DEFINE l_cmd   STRING 
DEFINE l_no    LIKE cka_file.cka11
DEFINE l_ggb   RECORD LIKE ggb_file.*
DEFINE l_cka10_new LIKE cka_file.cka10

   IF cl_null(p_cnt) OR p_cnt<=0 THEN RETURN END IF 
   #根據主鍵抓對應單身那筆所有資料
   SELECT * INTO l_ggb.* FROM ggb_file 
    WHERE ggb01 = g_tree[p_cnt].gga01
      AND ggb02 = g_tree[p_cnt].ggb02
   IF l_ggb.ggbacti='Y' THEN 
      #生成版本号
      SELECT MAX(cka11) INTO l_cka11_old FROM cka_file 
      IF cl_null(l_cka11_old) THEN 
         LET l_cka11 = TODAY USING 'yymmdd' 
         LET l_cka11 = l_cka11 , '001'
      ELSE
         LET l_cka11 = TODAY USING 'yymmdd'
         LET l_cka11 = l_cka11 , '001'
         IF l_cka11 <= l_cka11_old THEN
            LET l_cka11 = l_cka11_old + 1
            IF g_ver_no = l_cka11 THEN 
               LET l_cka11 = l_cka11 + 1
            END IF 
         END IF 
      END IF 
      LET l_no = l_cka11
      IF g_wc2 = " 1=1" THEN 
         LET g_wc2 = " cka11 = '", l_cka11 ,"' "
      ELSE 
         LET g_wc2 = g_wc2, " OR cka11 = '", l_cka11 ,"' "
      END IF 

      CALL s_log_cka11(l_no,l_ggb.ggb03,g_gga.yy,g_gga.mm,'1')
      
      LET l_cmd = l_ggb.ggb03
      CALL cl_cmdrun_wait(l_cmd)
      CALL s_log_cka11('','','','','0') 

      CALL p700_b_fill()       
      CALL cl_show_fld_cont()  
      DISPLAY ARRAY g_cka TO s_cka.*
         BEFORE DISPLAY EXIT DISPLAY 
      END DISPLAY 
      DISPLAY g_cnt1,g_cnt2 TO cn1,cn2
      LET l_cka10_new = ''
      SELECT cka10 INTO l_cka10_new FROM cka_file 
       WHERE cka01 = l_ggb.ggb03
         AND cka00 = (SELECT MAX(cka00) FROM cka_file
                       WHERE cka11 = l_cka11 )
      IF l_cka10_new = 'Y' THEN 
         CALL p700_pic(p_cnt,'1')  
      END IF 
      IF l_cka10_new = 'N' THEN 
         CALL p700_pic(p_cnt,'2')  
      END IF 
   END IF 
END FUNCTION

FUNCTION p700_pic(p_cnt,p_style)
DEFINE p_cnt   LIKE type_file.num5
DEFINE p_style LIKE type_file.num5  # 1：成功 2：失败 3：处理中 4：等待 5:无需执行

   CASE p_style
      WHEN '1'
         LET g_tree[p_cnt].img = 'accept' 
      WHEN '2'
         LET g_tree[p_cnt].img = 'cancel' 
      WHEN '3'
         LET g_tree[p_cnt].img = 'filter'  
      WHEN '4'
         LET g_tree[p_cnt].img = 'time'   
      WHEN '5'
         LET g_tree[p_cnt].img = 'file'  
      OTHERWISE EXIT CASE 
   END CASE  
   DISPLAY ARRAY g_tree TO tree.*
      BEFORE DISPLAY EXIT DISPLAY 
   END DISPLAY 
   CALL ui.Interface.refresh()
END FUNCTION 

FUNCTION p700_picclear()
DEFINE i       LIKE type_file.num5

   IF g_tree.getLength() > 1 THEN
      FOR i=1 TO g_tree.getLength()
         IF NOT g_tree[i].has_children THEN 
            LET g_tree[i].img = 'time'
         END IF 
      END FOR 
   END IF 
   DISPLAY ARRAY g_tree TO tree.*
      BEFORE DISPLAY EXIT DISPLAY 
   END DISPLAY 
   CALL ui.Interface.refresh()
END FUNCTION 
#FUN-C80092
