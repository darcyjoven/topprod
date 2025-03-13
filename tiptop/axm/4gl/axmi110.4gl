# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi110.4gl
# Descriptions...: 產品分類維護作業
# Date & Author..: 94/12/14 By Danny
# Modify      ...: 04/03/10 By Carrier NO.A112
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-670032 06/07/12 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690012 06/10/14 By rainy 新增銷貨收入科目(oba11)
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730048 07/03/28 By johnray 會計科目加帳套
# Modify.........: No.TQC-790076 07/09/12 By judy 打印報表中，單頭缺少"銷貨收入科目"
# Modify.........: No.FUN-810099 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.MOD-8A0230 08/10/27 By sherry 多帳套時增加oba111字段
# Modify.........: No.MOD-8A0253 08/11/15 By Pengu 銷貨收入科目欄位無法開窗查詢
# Modify.........: No.FUN-870100 09/06/09 By lala  add oba12,oba13,oba14,oba15,obaacti,obapos
# Modify.........: No.TQC-970125 09/07/14 By lilingyu "生產期數"欄位錄入負數沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0069 09/12/14 By bnlent 所屬一級分類碼不可為空 
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:MOD-AA0085 10/10/20 By chenying obaacti新增時預設Y
# Modify.........: No:FUN-AA0079 10/10/26 By chenying  
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-BB0038 11/11/18 By elva add oba16,oba161
# Modify.........: No:MOD-BC0304 11/12/30 By Vampire oba08/oba09這兩個欄位拿掉
# Modify.........: No:FUN-C90078 12/10/17 By minpp 增加外销收入科目（oba17，oba171） 
# Modify.........: No:FUN-D20020 13/02/05 By dongsz 改善層級邏輯
# Modify.........: No:FUN-D30093 13/03/27 By dongsz 如果分類名稱有異動，同時更新apci054中的分類名稱及已傳POS否欄位
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oba           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oba01       LIKE oba_file.oba01,  
        oba02       LIKE oba_file.oba02, 
        oba12       LIKE oba_file.oba12,  #FUN-870100
        oba13       LIKE oba_file.oba13,  #FUN-870100
        oba13_desc  LIKE oba_file.oba02,  #FUN-870100
        oba14       LIKE oba_file.oba14,  #FUN-870100
        oba15       LIKE oba_file.oba15,  #FUN-870100
#No:MOD-AA0085 mark
#        oba03       LIKE oba_file.oba03,  
#        oba04       LIKE oba_file.oba04, 
#        oba05       LIKE oba_file.oba05, 
#        oba06       LIKE oba_file.oba06,
#No:MOD-AA0085 mark
        #oba08       LIKE oba_file.oba08,  #add 040402 NO.A112                  #MOD-BC0304 mark 
        #oba09       LIKE oba_file.oba09,  #add 040402 NO.A112                  #MOD-BC0304 mark
        oba10       LIKE oba_file.oba10,  #FUN-670032
        gem02       LIKE gem_file.gem02,  #FUN-670032
        oba11       LIKE oba_file.oba11,  #FUN-690012
        oba111      LIKE oba_file.oba111, #MOD-8A0230 
        oba16       LIKE oba_file.oba16,  #FUN-BB0038
        oba161      LIKE oba_file.oba161, #FUN-BB0038
        oba17       LIKE oba_file.oba17,  #FUN-C90078
        oba171      LIKE oba_file.oba171, #FUN-C90078
        obaacti     LIKE oba_file.obaacti,#FUN-870100
        obapos      LIKE oba_file.obapos  #FUN-870100
                    END RECORD,
    g_oba_t         RECORD                 #程式變數 (舊值)
        oba01       LIKE oba_file.oba01,  
        oba02       LIKE oba_file.oba02, 
        oba12       LIKE oba_file.oba12,  #FUN-870100
        oba13       LIKE oba_file.oba13,  #FUN-870100
        oba13_desc  LIKE oba_file.oba02,  #FUN-870100
        oba14       LIKE oba_file.oba14,  #FUN-870100
        oba15       LIKE oba_file.oba15,  #FUN-870100
#No:MOD-AA0085 mark        
#        oba03       LIKE oba_file.oba03, 
#        oba04       LIKE oba_file.oba04, 
#        oba05       LIKE oba_file.oba05, 
#        oba06       LIKE oba_file.oba06,
#No:MOD-AA0085 mark
        #oba08       LIKE oba_file.oba08,  #add 040402 NO.A112                  #MOD-BC0304 mark
        #oba09       LIKE oba_file.oba09,  #add 040402 NO.A112                  #MOD-BC0304 mark
        oba10       LIKE oba_file.oba10,  #FUN-670032
        gem02       LIKE gem_file.gem02,  #FUN-670032
        oba11       LIKE oba_file.oba11,  #FUN-690012
        oba111      LIKE oba_file.oba111, #MOD-8A0230 
        oba16       LIKE oba_file.oba16,  #FUN-BB0038
        oba161      LIKE oba_file.oba161, #FUN-BB0038        
        oba17       LIKE oba_file.oba17,  #FUN-C90078
        oba171      LIKE oba_file.oba171, #FUN-C90078
        obaacti     LIKE oba_file.obaacti,#FUN-870100
        obapos      LIKE oba_file.obapos  #FUN-870100
                    END RECORD,
    g_wc2,g_sql     STRING,  #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql    STRING     #SELECT ... FOR UPDATE SQL    
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109          #No.FUN-680137 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                  #NO.FUN-6A0094      
 
    OPEN WINDOW i110_w WITH FORM "axm/42f/axmi110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("oba10,gem02",g_aaz.aaz90='Y')
 
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible("oba12,oba13,oba13_desc,oba14,oba15",FALSE)     #MOD-AA0085 del obaacti
       #CALL cl_set_comp_visible("oba08,oba09,oba10,gem02",TRUE)                 #MOD-AA0085 del oba03,oba04,oba05,oba06, #MOD-BC0304 mark
       CALL cl_set_comp_visible("oba10,gem02",TRUE)                 #MOD-AA0085 del oba03,oba04,oba05,oba06,              #MOD-BC0304 add
    ELSE
       CALL cl_set_comp_visible("oba12,oba13,oba13_desc,oba14,oba15,obaacti",TRUE)
       #CALL cl_set_comp_visible("oba08,oba09,oba10,gem02",FALSE)                #MOD-AA0085 del oba03,oba04,oba05,oba06,  #MOD-BC0304 mark
       CALL cl_set_comp_visible("oba10,gem02",FALSE)                #MOD-AA0085 del oba03,oba04,oba05,oba06,   #MOD-BC0304 add
    END IF
    
    IF g_aza.aza88 = 'N' THEN
       CALL cl_set_comp_visible('obapos',FALSE)
    END IF
    CALL cl_set_comp_visible('obapos',FALSE)   #TQC-B30004 add 
    LET g_wc2 = '1=1' CALL i110_b_fill(g_wc2)
    CALL i110_menu()
    CLOSE WINDOW i110_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i110_menu()
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-810099
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i110_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
#No.FUN-810099--begin--mark--
#No.FUN-810099--start--  
#               CALL i110_out() 
#               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF  
#               IF g_aaz.aaz90 = 'Y'  THEN   
#                  LET l_cmd = 'p_query "axmi110" "',g_wc2 CLIPPED,'"'  
#               ELSE      
#                  LET l_cmd = 'p_query "axmi110_1" "',g_wc2 CLIPPED,'"'  
#               END IF     
#               CALL cl_cmdrun(l_cmd)                                 
#No.FUN-810099--end--
                CALL i110_out()                
#No.FUN-810099--end--
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oba),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680137 SMALLINT
    l_cnt           LIKE type_file.num10,                  #FUN-670032   #No.FUN-680137  INTEGER 
    l_oba15         LIKE oba_file.oba15,                   #FUN-870100
    l_oba12         LIKE oba_file.oba12,                   #FUN-870100
    l_oba01         LIKE oba_file.oba01,                   #FUN-870100
    l_oba13         LIKE oba_file.oba13,                   #FUN-870100
    l_oba12_1       LIKE oba_file.oba12,                   #FUN-D20020 add
    l_oba15_1       LIKE oba_file.oba15,                   #FUN-D20020 add
    l_n1            LIKE type_file.num5,                   #FUN-D20020 add
    l_n2            LIKE type_file.num5                    #FUN-D20020 add
DEFINE l_sql        STRING                                 #FUN-870100
DEFINE i            LIKE type_file.num5                    #No.FUN-870100 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    #LET g_forupd_sql = "SELECT oba01,oba02,oba12,oba13,'',oba14,oba15,oba08,oba09,oba10,'',oba11,oba111,oba16,oba161,obaacti,obapos ",  #FUN-870100  #MOD-AA0085 del oba03,oba04,oba05,oba06, #FUN-BB0038 #MOD-BC0304 mark
    LET g_forupd_sql = "SELECT oba01,oba02,oba12,oba13,'',oba14,oba15,oba10,'',oba11,oba111,", #FUN-870100  #MOD-AA0085 del oba03,oba04,oba05,oba06,
                       " oba16,oba161,oba17,oba171,obaacti,obapos ",   #FUN-BB0038 #MOD-BC0304 add  #FUN-C90078 add-oba17,oba171
                       "  FROM oba_file WHERE oba01=? FOR UPDATE"  #NO.A112  #FUN-670032  #FUN-690012 add oba11 #MOD-8A0230 add  #FUN-C90078 add-oba17,oba171 oba111
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_oba WITHOUT DEFAULTS FROM s_oba.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
#               CALL cl_set_comp_entry("oba01",FALSE) #FUN-870100
               IF cl_null(g_oba[l_ac].oba14) THEN 
                  LET g_oba[l_ac].oba14='0'  #FUN-870100
                  UPDATE oba_file SET oba14=0 WHERE oba01 = g_oba[l_ac].oba01
                
               END IF
#               LET g_oba[l_ac].obaacti='Y'  #FUN-870100
#               LET g_oba[l_ac].obapos='N'  #FUN-870100
               LET g_oba_t.* = g_oba[l_ac].*  #BACKUP
 
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i110_set_entry_b(p_cmd)                                                                                         
               CALL i110_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--  
               BEGIN WORK
 
               OPEN i110_bcl USING g_oba_t.oba01
               IF STATUS THEN
                  CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i110_bcl INTO g_oba[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oba_t.oba01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  IF g_azw.azw04='2' THEN                             #No.FUN-870100
                     CALL i110_get_oba13_desc(g_oba[l_ac].oba13)      #No.FUN-870100
                          RETURNING g_oba[l_ac].oba13_desc            #No.FUN-870100 
                  END IF                                              #No.FUN-870100   
                  CALL i110_get_gem02(g_oba[l_ac].oba10) 
                        RETURNING g_oba[l_ac].gem02 #FUN-670032
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
#NO.A112
            #INSERT INTO oba_file(oba01,oba02,oba08,oba09,oba10,oba11,oba111,oba12,oba13,oba14,oba15,oba16,oba161,obaacti) #MOD-8A0230 add oba111 #FUN-670032  #FUN-690012 add oba11 #FUN-870100 #MOD-AA0085 del oba03,oba04,oba05,oba06,#FUN-BB0038 #MOD-BC0304 mark
            INSERT INTO oba_file(oba01,oba02,oba10,oba11,oba111,oba12,oba13,oba14,oba15,oba16,oba161,oba17,oba171,obaacti) #MOD-8A0230 add oba111 #FUN-670032  #FUN-690012 add oba11 #FUN-870100 #MOD-AA0085 del oba03,oba04,oba05,oba06,#FUN-BB0038  #MOD-BC0304 add #FUN-C90078 add-oba17,171
              VALUES(g_oba[l_ac].oba01,g_oba[l_ac].oba02,
#                     g_oba[l_ac].oba03,g_oba[l_ac].oba04,  #MOD-AA0085 del oba03,oba04,oba05,oba06,
#                     g_oba[l_ac].oba05,g_oba[l_ac].oba06,  #MOD-AA0085 del oba03,oba04,oba05,oba06,
                     #g_oba[l_ac].oba08,g_oba[l_ac].oba09,  #MOD-BC0304 mark
                     g_oba[l_ac].oba10,g_oba[l_ac].oba11,g_oba[l_ac].oba111,  #FUN-670032 #FUN-690012 add oba11 #MOD-8A0230 add oba111
                     g_oba[l_ac].oba12,g_oba[l_ac].oba13,   #FUN-870100
                     g_oba[l_ac].oba14,g_oba[l_ac].oba15,   #FUN-870100 
                     g_oba[l_ac].oba16,g_oba[l_ac].oba161,  #FUN-BB0038
                     g_oba[l_ac].oba17,g_oba[l_ac].oba171,  #FUN-C90078
                     g_oba[l_ac].obaacti)                   #FUN-870100 #FUN-B50042 remove POS
 
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","oba_file",g_oba[l_ac].oba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
              ELSE
                  #FUN-870100  --BEGIN
                  IF g_azw.azw04='2' THEN
                     IF g_oba[l_ac].oba13 IS NOT NULL THEN
                        UPDATE oba_file SET oba14=COALESCE(oba14,0)+1 WHERE oba01=g_oba[l_ac].oba13
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","oba_file",g_oba[l_ac].oba01,"",SQLCA.sqlcode,"","",1)
                        END IF
                     END IF
                  END IF
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  
                  IF g_azw.azw04='2' THEN                           
                     FOR i=1 TO g_rec_b                                                                                             
                        IF g_oba[l_ac].oba13=g_oba[i].oba01 THEN                                                                    
                           LET g_oba[i].oba14=g_oba[i].oba14+1                                                               
                        END IF                                                                                                      
                     END FOR 
                     IF cl_null(g_oba[l_ac].oba14) THEN 
                        LET g_oba[l_ac].oba14 = 0
                     END IF 
                     DISPLAY BY NAME g_oba[l_ac].oba14 
                  END IF    
                  #FUN-870100 --end    
              END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--
            LET g_before_input_done = FALSE
            CALL i110_set_entry_b(p_cmd)
            CALL i110_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end--
            INITIALIZE g_oba[l_ac].* TO NULL      #900423
            IF g_azw.azw04='2' THEN                  #No.FUN-870100    
               LET g_oba[l_ac].oba14=0               #No.FUN-870100 
               LET g_oba[l_ac].obaacti='Y'           #No.FUN-870100 
               LET g_oba[l_ac].oba12 = 1             #FUN-D20020 add
            END IF                                   #No.FUN-870100    
            #LET g_oba[l_ac].obapos='N'              #FUN-870100 #FUN-B50042 mark
            LET g_oba[l_ac].obaacti='Y'              #MOD-AA0085 
            #DISPLAY BY NAME g_oba[l_ac].obapos      #FUN-870100 #FUN-B50042 mark
            LET g_oba_t.* = g_oba[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oba01
 
        AFTER FIELD oba01                        #check 編號是否重複
            IF g_oba[l_ac].oba01 IS NOT NULL THEN
               IF p_cmd = "a" THEN                     #FUN-D20020 add
                  LET g_oba[l_ac].oba15 = g_oba[l_ac].oba01 #No.FUN-9C0069
               END IF                                  #FUN-D20020 add
               IF g_oba[l_ac].oba01 != g_oba_t.oba01 OR
                  (g_oba[l_ac].oba01 IS NOT NULL AND g_oba_t.oba01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM oba_file
                       WHERE oba01 = g_oba[l_ac].oba01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_oba[l_ac].oba01 = g_oba_t.oba01
                       NEXT FIELD oba01
                   END IF
               END IF
            END IF
 
        #FUN-870100  --BEGIN 
       #FUN-D20020--mark--str---
       #AFTER FIELD oba12
       #   IF g_azw.azw04='2' THEN
       #      IF g_oba[l_ac].oba12<=0 THEN
       #         CALL cl_err('','afa-949',0)
       #         LET g_oba[l_ac].oba12=g_oba_t.oba12
       #         DISPLAY BY NAME g_oba[l_ac].oba12
       #         NEXT FIELD oba12
       #      END IF
       #      IF NOT cl_null(g_oba[l_ac].oba13) THEN
       #         LET l_oba12='' 
       #         SELECT oba12 INTO l_oba12 FROM oba_file 
       #                          WHERE oba01=g_oba[l_ac].oba13
       #         IF l_oba12>=g_oba[l_ac].oba12 THEN
       #            CALL cl_err('','art-027',1)
       #            LET g_oba[l_ac].oba12=g_oba_t.oba12 
       #            DISPLAY BY NAME g_oba[l_ac].oba12
       #            NEXT FIELD oba12
       #         END IF
       #      END IF
       #   END IF
       #FUN-D20020--mark--end---
        AFTER FIELD oba13
           IF g_azw.azw04='2' THEN   
              IF NOT cl_null(g_oba[l_ac].oba13) THEN
                 #FUN-AA0079---add----str-----------
                 LET l_n= 0 
                 SELECT COUNT(*) INTO l_n FROM oba_file
                   WHERE oba01 = g_oba[l_ac].oba13
                   IF l_n = 0 AND g_oba[l_ac].oba13 != g_oba[l_ac].oba01 THEN 
                      CALL cl_err('','alm-845',1)
                      LET g_oba[l_ac].oba13=g_oba_t.oba13
                      LET g_oba[l_ac].oba13_desc=g_oba_t.oba13_desc
                      DISPLAY BY NAME g_oba[l_ac].oba13,g_oba[l_ac].oba13_desc
                      NEXT FIELD oba13
                   END IF
                   IF g_oba[l_ac].oba13 != g_oba[l_ac].oba01 THEN   
                 #FUN-AA0079---add----end-----------
                     #FUN-D20020--add--str---
                      IF g_oba[l_ac].oba13 != g_oba_t.oba13 OR g_oba_t.oba13 IS NULL THEN
                         SELECT oba12 INTO l_oba12_1 FROM oba_file WHERE oba01 = g_oba[l_ac].oba13
                         LET g_oba[l_ac].oba12 = l_oba12_1 + 1
                         DISPLAY BY NAME g_oba[l_ac].oba12
                         LET l_oba12_1 = g_oba[l_ac].oba12 + 1
                         CALL i110_oba13_oba12(g_oba[l_ac].oba01,l_oba12_1)
                         SELECT COUNT(*) INTO l_n1 FROM oba_file WHERE oba13 = g_oba[l_ac].oba01
                         LET g_oba[l_ac].oba14 = l_n1
                         DISPLAY BY NAME g_oba[l_ac].oba14
                        #UPDATE oba_file SET oba14=COALESCE(oba14,0)-1 WHERE oba01 = g_oba_t.oba13
                        #UPDATE oba_file SET oba14=COALESCE(oba14,0)+1 WHERE oba01 = g_oba[l_ac].oba13
                         SELECT oba15 INTO l_oba15_1 FROM oba_file WHERE oba01=g_oba[l_ac].oba13
                         LET g_oba[l_ac].oba15=l_oba15_1
                         DISPLAY BY NAME g_oba[l_ac].oba15
                         CALL i110_oba13_oba15(g_oba[l_ac].oba01,l_oba15_1)
                      END IF
                     #FUN-D20020--add--end---

                      IF NOT cl_null(g_oba[l_ac].oba12) THEN                     
                         LET l_cnt=0
                         SELECT COUNT(*) INTO l_cnt FROM oba_file
                                        WHERE oba01=g_oba[l_ac].oba13
                                          AND obaacti='Y' AND oba12<g_oba[l_ac].oba12
                      ELSE
                        LET l_cnt=0
                        SELECT COUNT(*) INTO l_cnt FROM oba_file
                                      WHERE oba01=g_oba[l_ac].oba13
                                        AND obaacti='Y'
                      END IF
                      IF l_cnt=0 THEN 
                         CALL cl_err('','art-027',1)
                         LET g_oba[l_ac].oba13=g_oba_t.oba13
                         LET g_oba[l_ac].oba13_desc=g_oba_t.oba13_desc
                         DISPLAY BY NAME g_oba[l_ac].oba13,g_oba[l_ac].oba13_desc
                         NEXT FIELD oba13
                      END IF
                END IF     #FUN-AA0079 add
                 CALL i110_get_oba13_desc(g_oba[l_ac].oba13)
                       RETURNING g_oba[l_ac].oba13_desc
#                 DISPLAY BY NAME g_oba[l_ac].oba13_desc
              #FUN-D20020--mark--str---
               # SELECT oba15 INTO l_oba15 FROM oba_file    
               #   WHERE oba01=g_oba[l_ac].oba13
               # LET g_oba[l_ac].oba15=l_oba15
               # DISPLAY BY NAME g_oba[l_ac].oba15
              #FUN-D20020--mark--end---      
              ELSE
                #FUN-D20020--add--str---
                 LET g_oba[l_ac].oba12 = 1                  
                 DISPLAY BY NAME g_oba[l_ac].oba12         
                 LET l_oba12_1 = g_oba[l_ac].oba12 + 1
                 CALL i110_oba13_oba12(g_oba[l_ac].oba01,l_oba12_1)
                 SELECT COUNT(*) INTO l_n1 FROM oba_file WHERE oba13 = g_oba[l_ac].oba01
                 LET g_oba[l_ac].oba14 = l_n1
                 DISPLAY BY NAME g_oba[l_ac].oba14
                #FUN-D20020--add--end---
                 LET g_oba[l_ac].oba13_desc=NULL
                 DISPLAY BY NAME g_oba[l_ac].oba13_desc
                 LET g_oba[l_ac].oba15=g_oba[l_ac].oba01
                 DISPLAY BY NAME g_oba[l_ac].oba15
                 CALL i110_oba13_oba15(g_oba[l_ac].oba01,g_oba[l_ac].oba15)
              END IF
        END IF
        #FUN-870100  --END
#MOD-BC0304 ----- mark start ----- 
##TQC-970125 --begin--
#        AFTER FIELD oba09
#           IF NOT cl_null(g_oba[l_ac].oba09) THEN 
#              IF g_oba[l_ac].oba09 < 0 THEN 
#                 CALL cl_err('','axm-161',0)
#                 NEXT FIELD oba09
#              END IF 
#           END IF 
##TQC-970125 --end--
#MOD-BC0304 ----- mark start ----- 
            
        #FUN-670032...............begin
        AFTER FIELD oba10
            IF NOT cl_null(g_oba[l_ac].oba10) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM gem_file 
                                         WHERE gem01=g_oba[l_ac].oba10
                                           AND gem09 IN ('1','2')
                                           AND gemacti='Y'
               IF l_cnt=0 THEN
                  CALL cl_err('',100,1)
                  LET g_oba[l_ac].oba10=g_oba_t.oba10
                  LET g_oba[l_ac].gem02=g_oba_t.gem02
                  DISPLAY BY NAME g_oba[l_ac].oba10,g_oba[l_ac].gem02
                  NEXT FIELD oba10
               END IF
               CALL i110_get_gem02(g_oba[l_ac].oba10) 
                  RETURNING g_oba[l_ac].gem02
            ELSE
               LET g_oba[l_ac].gem02=NULL
               DISPLAY BY NAME g_oba[l_ac].gem02
            END IF
        #FUN-670032...............end
        
        #FUN-690012 add--begin
         AFTER FIELD oba11
           IF NOT cl_null(g_oba[l_ac].oba11) THEN
             CALL i110_chk_acc_entry(g_oba[l_ac].oba11)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                #Add No.FUN-B10048
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba11
                LET g_qryparam.arg1 = g_aza.aza81
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba11 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba11
                DISPLAY BY NAME g_oba[l_ac].oba11
                #End Add No.FUN-B10048
                NEXT FIELD oba11
             END IF
           END IF
        #FUN-690012 add--end 
 
        #MOD-8A0230---Begin
        AFTER FIELD oba111
           IF NOT cl_null(g_oba[l_ac].oba111) THEN
             CALL i110_chk_acc_entry1(g_oba[l_ac].oba111)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                #Add No.FUN-B10048
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba111
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba111 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba111
                DISPLAY BY NAME g_oba[l_ac].oba111
                #End Add No.FUN-B10048
                NEXT FIELD oba111
             END IF
           END IF
        #MOD-8A0230---End  
        
        #FUN-BB0038 add--begin
         AFTER FIELD oba16
           IF NOT cl_null(g_oba[l_ac].oba16) THEN
             CALL i110_chk_acc_entry(g_oba[l_ac].oba16)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba16
                LET g_qryparam.arg1 = g_aza.aza81
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba16 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba16
                DISPLAY BY NAME g_oba[l_ac].oba16
                NEXT FIELD oba16
             END IF
           END IF
        #FUN-BB0038 add--end
             
        #FUN-BB0038 add--begin
         AFTER FIELD oba161
           IF NOT cl_null(g_oba[l_ac].oba161) THEN
             CALL i110_chk_acc_entry1(g_oba[l_ac].oba161)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba161
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba161 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba161
                DISPLAY BY NAME g_oba[l_ac].oba161
                NEXT FIELD oba161
             END IF
           END IF
        #FUN-BB0038 add--end
        
        #FUN-C90078--ADD---STR
        AFTER FIELD oba17
           IF NOT cl_null(g_oba[l_ac].oba17) THEN
             CALL i110_chk_acc_entry(g_oba[l_ac].oba17)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba17
                LET g_qryparam.arg1 = g_aza.aza81
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba17 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba17
                DISPLAY BY NAME g_oba[l_ac].oba17
                NEXT FIELD oba17
             END IF
           END IF

        AFTER FIELD oba171
           IF NOT cl_null(g_oba[l_ac].oba171) THEN
             CALL i110_chk_acc_entry1(g_oba[l_ac].oba171)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_oba[l_ac].oba171
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag09='Y' AND aag01 LIKE '",g_oba[l_ac].oba171 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba171
                DISPLAY BY NAME g_oba[l_ac].oba171
                NEXT FIELD oba171
             END IF
           END IF
        #FUN-C90078--ADD---END

       #FUN-D20020--add--str---
        AFTER FIELD obaacti
           IF g_oba[l_ac].obaacti = 'N' THEN
              LET l_n2 = 0
              SELECT COUNT(*) INTO l_n2 FROM oba_file 
               WHERE oba13 = g_oba[l_ac].oba01 AND obaacti = 'Y'
              IF l_n2 > 0 THEN
                 CALL cl_err('','axm1178',0)
                 LET g_oba[l_ac].obaacti = g_oba_t.obaacti
                 DISPLAY BY NAME g_oba[l_ac].obaacti
                 NEXT FIELD obaacti
              END IF
           END IF
       #FUN-D20020--add--end---
                     
        BEFORE DELETE                            #是否取消單身
            IF g_oba_t.oba01 IS NOT NULL THEN
               #TQC-B30004 mark begin-----------------
               ##FUN-870100---begin
               #IF g_aza.aza88='Y' THEN
               #   IF NOT (g_oba[l_ac].obaacti='N' AND g_oba[l_ac].obapos='Y') THEN
               #     #CALL cl_err('', 'aim-944', 1)   #FUN-A30030 MARK
               #      CALL cl_err('', 'art-648', 1)   #ADD
               #      CANCEL DELETE
               #   END IF
               #END IF
               ##FUN-870100---end
               #TQC-B30004 mark end-------------------
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
     
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
      
               #FUN-870100  --BEGIN
                IF g_azw.azw04='2' THEN
                   IF g_oba[l_ac].oba14<>0 THEN 
                      CALL cl_err("",'abx-048',1)
                      CANCEL DELETE
                   END IF
                END IF
               #FUN-870100  --END
 
                DELETE FROM oba_file WHERE oba01 = g_oba_t.oba01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oba_t.oba01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","oba_file",g_oba_t.oba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                #FUN-870100  --BEGIN 
                IF g_azw.azw04='2' THEN 
                   IF g_oba_t.oba13 IS NOT NULL THEN
                      UPDATE oba_file SET oba14=oba14-1 WHERE oba01=g_oba_t.oba13
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","oba_file",g_oba_t.oba13,"",SQLCA.sqlcode,"","",1)
                      END IF
                   END IF
                   FOR i=1 TO g_rec_b                                                                                               
                        IF g_oba[l_ac].oba13=g_oba[i].oba01 THEN                                                                    
                           LET g_oba[i].oba14=g_oba[i].oba14-1                                                                      
                        END IF                                                                                                      
                   END FOR    
                END IF
                #FUN-870100  --END
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i110_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oba[l_ac].* = g_oba_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #FUN-870100---start
            IF g_oba[l_ac].oba02<>g_oba_t.oba02 OR g_oba[l_ac].oba12<>g_oba_t.oba12 
               OR g_oba[l_ac].oba13<>g_oba_t.oba13 OR g_oba[l_ac].oba14<>g_oba_t.oba14
               OR g_oba[l_ac].oba15<>g_oba_t.oba15 OR g_oba[l_ac].oba11<>g_oba_t.oba11 
               OR g_oba[l_ac].oba16<>g_oba_t.oba16 OR g_oba[l_ac].oba17<>g_oba_t.oba17  #FUN-BB0038  #FUN-C90078 add-oba17
               OR g_oba[l_ac].obaacti<>g_oba_t.obaacti THEN  
               #IF g_aza.aza88='Y' THEN     #FUN-A30030 ADD #FUN-B50042 mark
               #   LET g_oba[l_ac].obapos = 'N'             #FUN-B50042 mark
               #   DISPLAY BY NAME g_oba[l_ac].obapos       #FUN-B50042 mark
               #END IF                                      #FUN-B50042 mark
               SELECT oba13 INTO l_oba13 FROM oba_file WHERE oba01=g_oba[l_ac].oba01
               #UPDATE oba_file SET obapos='N' WHERE oba01=l_oba13  #FUN-B50042 mark
               IF g_oba[l_ac].oba02<>g_oba_t.oba02 THEN
                  SELECT COUNT(*) INTO l_n FROM oba_file WHERE oba13=g_oba[l_ac].oba01
                  IF l_n>0 THEN
                     #UPDATE oba_file SET obapos='N' WHERE oba13=g_oba[l_ac].oba01  #FUN-B50042 mark
                  END IF
               END IF
            END IF
           #FUN-D30093--add--str---
            IF g_oba[l_ac].oba02<>g_oba_t.oba02 THEN
               UPDATE rzj_file SET rzj04 = g_oba[l_ac].oba02
                WHERE rzj01 IN (SELECT DISTINCT rzi01 FROM rzi_file WHERE rzi09 = '1')
                  AND rzj03 = g_oba[l_ac].oba01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzj_file",g_oba_t.oba02,"",SQLCA.sqlcode,"","",1)
                  LET g_oba[l_ac].* = g_oba_t.*
               END IF
               UPDATE rzi_file SET rzipos = '2' 
                WHERE rzi01 IN (SELECT DISTINCT rzj01 FROM rzj_file WHERE rzj03 = g_oba[l_ac].oba01)
                  AND rzipos IN ('3','4') 
                  AND rzi09 = '1'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rzi_file",g_oba[l_ac].oba01,"",SQLCA.sqlcode,"","",1)
                  LET g_oba[l_ac].* = g_oba_t.*
               END IF  
            END IF
           #FUN-D30093--add--end---
            #FUN-870100---end
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oba[l_ac].oba01,-263,1)
               LET g_oba[l_ac].* = g_oba_t.*
            ELSE
#NO.A112
               UPDATE oba_file SET
                   oba01=g_oba[l_ac].oba01,oba02=g_oba[l_ac].oba02,
#                   oba03=g_oba[l_ac].oba03,oba04=g_oba[l_ac].oba04,   #MOD-AA0085 del oba03,oba04,oba05,oba06,
#                   oba05=g_oba[l_ac].oba05,oba06=g_oba[l_ac].oba06,   #MOD-AA0085 del oba03,oba04,oba05,oba06,
                   #oba08=g_oba[l_ac].oba08,oba09=g_oba[l_ac].oba09,   #MOD-BC0304 mark
                   oba10=g_oba[l_ac].oba10,oba11=g_oba[l_ac].oba11  #FUN-670032  #FUN-690012
                   ,oba111=g_oba[l_ac].oba111,                       #MOD-8A0230 add
                   oba12=g_oba[l_ac].oba12,oba13=g_oba[l_ac].oba13, #FUN-870100
                   oba14=g_oba[l_ac].oba14,oba15=g_oba[l_ac].oba15, #FUN-870100 
                   oba16=g_oba[l_ac].oba16,oba161=g_oba[l_ac].oba161,  #FUN-BB0038
                   oba17=g_oba[l_ac].oba17,oba171=g_oba[l_ac].oba171,  #FUN-C90078
                   obaacti=g_oba[l_ac].obaacti                      #FUN-870100 #FUN-B50042 remove POS
               WHERE oba01 = g_oba_t.oba01
 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","oba_file",g_oba_t.oba01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_oba[l_ac].* = g_oba_t.*
               ELSE
 
                 #FUN-870100  --BEGIN
                 IF g_azw.azw04='2' THEN
                    IF g_oba_t.oba13 IS NOT NULL THEN 
                       UPDATE oba_file SET oba14=COALESCE(oba14,0)-1 WHERE oba01=g_oba_t.oba13
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","oba_file",g_oba_t.oba01,"",SQLCA.sqlcode,"","",1)
                       END IF
                    END IF
                    IF g_oba[l_ac].oba13 IS NOT NULL THEN
                       UPDATE oba_file SET oba14=COALESCE(oba14,0)+1 WHERE oba01=g_oba[l_ac].oba13
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","oba_file",g_oba[l_ac].oba01,"",SQLCA.sqlcode,"","",1)
                       END IF
                    END IF
                       FOR i=1 TO g_rec_b                                                                                      
                        IF g_oba[l_ac].oba13=g_oba[i].oba01 THEN                                                                    
                           LET g_oba[i].oba14=g_oba[i].oba14+1                                                                      
                        END IF                                
                        IF g_oba_t.oba13=g_oba[i].oba01 THEN
                           LET g_oba[i].oba14=g_oba[i].oba14-1
                       END IF                                                                       
                      END FOR        
                 END IF
                 #FUN-870100  --END
                  MESSAGE 'UPDATE O.K'
                  CLOSE i110_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oba[l_ac].* = g_oba_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oba.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i110_bcl
            COMMIT WORK
 
        #FUN-670032...............begin
        ON ACTION CONTROLP
           CASE
             #FUN-870100  --BEGIN
              WHEN INFIELD(oba13)
                 IF g_azw.azw04='2' THEN  
                    CALL cl_init_qry_var()                                                                                 
                    IF NOT cl_null(g_oba[l_ac].oba12) THEN          #FUN-AA0079  add
                       LET g_qryparam.form ="q_oba13_1"
                       LET g_qryparam.arg1 = g_oba[l_ac].oba12
                    ELSE                                            #FUN-AA0079  add
                       LET g_qryparam.form ="q_oba13_2"             #FUN-AA0079  add
                    END IF                                          #FUN-AA0079  add 
                    LET g_qryparam.where = " obaacti = 'Y' "
                    CALL cl_create_qry() RETURNING g_oba[l_ac].oba13                                                        
                    DISPLAY BY NAME g_oba[l_ac].oba13                                                                     
                    NEXT FIELD oba13
                 END IF
             #FUN-870100  --END  
              WHEN INFIELD(oba10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_oba[l_ac].oba10
                 DISPLAY BY NAME g_oba[l_ac].oba10
                 NEXT FIELD oba10
            #FUN-690012--begin
              WHEN INFIELD(oba11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba11
                LET g_qryparam.arg1 = g_aza.aza81               #No.FUN-730048
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba11
                DISPLAY BY NAME g_oba[l_ac].oba11
            #FUN-690012--end
            
            #MOD-8A0230---Begin
              WHEN INFIELD(oba111)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba111
                LET g_qryparam.arg1 = g_aza.aza82               
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba111
                DISPLAY BY NAME g_oba[l_ac].oba111            
            #MOD-8A0230---End  
             
            #FUN-BB0038---Begin
              WHEN INFIELD(oba16)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba16
                LET g_qryparam.arg1 = g_aza.aza81               
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba16
                DISPLAY BY NAME g_oba[l_ac].oba16           
            #FUN-BB0038---End
                         
             #FUN-BB0038---Begin
              WHEN INFIELD(oba161)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba161
                LET g_qryparam.arg1 = g_aza.aza82               
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba161
                DISPLAY BY NAME g_oba[l_ac].oba161            
            #FUN-BB0038---End 
             #FUN-C90078--add---str
             WHEN INFIELD(oba17)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba17
                LET g_qryparam.arg1 = g_aza.aza81
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba17
                DISPLAY BY NAME g_oba[l_ac].oba17

              WHEN INFIELD(oba171)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.default1 = g_oba[l_ac].oba171
                LET g_qryparam.arg1 = g_aza.aza82
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
                CALL cl_create_qry() RETURNING g_oba[l_ac].oba171
                DISPLAY BY NAME g_oba[l_ac].oba171
            #FUN-C90078--add---end 
 #              #No.FUN-870100---begin
#              WHEN INFIELD(oba13)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_oba"
#                 CALL cl_create_qry() RETURNING g_oba[l_ac].oba13
#                 DISPLAY BY NAME g_oba[l_ac].oba13
#                 CALL i110_oba13('a')
#                 NEXT FIELD oba13
#              #No.FUN-870100---end 
           END CASE 
        #FUN-670032...............end
              
 
        ON ACTION CONTROLN
            CALL i110_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oba01) AND l_ac > 1 THEN
                LET g_oba[l_ac].* = g_oba[l_ac-1].*
                NEXT FIELD oba01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i110_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i110_b_askkey()
    CLEAR FORM
    CALL g_oba.clear()
    CONSTRUCT g_wc2 ON oba01,oba02,oba12,oba13,oba14,oba15,oba10,oba11,oba111,oba16,oba161,oba17,oba171,obaacti  #MOD-8A0230 add oba111  #FUN-670032 add oba10  #FUN-690012 add oba11 #FUN-870100#FUN-BB0038 #FUN-C90078-add-oba17,171
            FROM s_oba[1].oba01,s_oba[1].oba02,s_oba[1].oba12,s_oba[1].oba13,s_oba[1].oba14,s_oba[1].oba15,s_oba[1].oba10,
                 s_oba[1].oba11,s_oba[1].oba111,s_oba[1].oba16,s_oba[1].oba161,s_oba[1].oba17,s_oba[1].oba171,s_oba[1].obaacti           #MOD-8A0230 add oba111 #FUN-690012 #FUN-B50042 remove POS #FUN-BB0038 #FUN-C90078-add-oba17,171
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      #FUN-670032...............begin
      ON ACTION CONTROLP
         CASE
           #FUN-870100  --BEGIN
            WHEN INFIELD(oba01)          #add by cockroach 090901--                                                                                           
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form  = "q_oba_1"                                                                                  
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO oba01                                                                              
                  NEXT FIELD oba01                                                                                                  
            WHEN INFIELD(oba13)
               IF g_azw.azw04='2' THEN      
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_oba13"
                  LET g_qryparam.state = "c"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oba13 
                  NEXT FIELD oba13
               END IF
           #FUN-870100  --END
            WHEN INFIELD(oba10)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oba10
               NEXT FIELD oba10
 
           #FUN-690012 add--begin
            WHEN INFIELD(oba11)
                CALL cl_init_qry_var()     #No.MOD-8A0253 add
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba11
 
           #FUN-690012 add--end
           
           #MOD-8A0230---Begin
           WHEN INFIELD(oba111)
                CALL cl_init_qry_var()     #No.MOD-8A0253 add
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba111
           #MOD-8A0230---End 

           #FUN-BB0038---Begin
           WHEN INFIELD(oba16)
                CALL cl_init_qry_var()    
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba16
           #FUN-BB0038---End

           #FUN-BB0038---Begin
           WHEN INFIELD(oba161)
                CALL cl_init_qry_var()  
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' " 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba161
           #FUN-BB0038---End
             
           #FUN-C90078---ADD---STR
           WHEN INFIELD(oba17)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba17

           WHEN INFIELD(oba171)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oba171
           #FUN-C90078--ADD---END 
#           #No.FUN-870100---begin
#           WHEN INFIELD(oba13)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_oba13"
#               LET g_qryparam.state = "c"   #多選
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO oba13
#               CALL i110_oba13('a')
#               NEXT FIELD oba13
#           #No.FUN-870100---end
         END CASE 
      #FUN-670032...............end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		     CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i110_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(200) 
 
#NO.A112
    LET g_sql =
        #"SELECT oba01,oba02,oba12,oba13,'',oba14,oba15,oba08,oba09,oba10,'',oba11,oba111,oba16,oba161,obaacti,obapos", #MOD-8A0230 add oba111 #FUN-690012 add oba11 #FUN-870100  #MOD-AA0085 del oba03,oba04,oba05,oba06,#FUN-BB0038 #MOD-BC0304 mark
        "SELECT oba01,oba02,oba12,oba13,'',oba14,oba15,oba10,'',oba11,oba111,oba16,oba161,oba17,oba171,obaacti,obapos", #MOD-8A0230 add oba111 #FUN-690012 add oba11 #FUN-870100  #MOD-AA0085 del oba03,oba04,oba05,oba06,#FUN-BB0038 #MOD-BC0304 add #FUN-C90078 add-oba17,171
        " FROM oba_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
####
    PREPARE i110_pb FROM g_sql
    DECLARE oba_curs CURSOR FOR i110_pb
 
    CALL g_oba.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oba_curs INTO g_oba[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#       SELECT oba02 INTO g_oba[g_cnt].oba13_desc FROM oba_file WHERE oba01 = g_oba[g_cnt].oba13 AND obaacti = 'Y'
        IF g_azw.azw04='2' THEN                               #No.FUN-870100  
           CALL i110_get_oba13_desc(g_oba[g_cnt].oba13)       #No.FUN-870100
                 RETURNING g_oba[g_cnt].oba13_desc            #No.FUN-870100
        END IF                                                #No.FUN-870100 
        CALL i110_get_gem02(g_oba[g_cnt].oba10)
           RETURNING g_oba[g_cnt].gem02   #FUN-670032
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oba.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   #MOD-8A0230---Begin
   IF g_aza.aza63 = 'N' THEN  
      CALL cl_set_comp_visible("oba111,oba161,oba171",FALSE)  #FUN-BB0038  #FUN-C90078
   ELSE 
   	  CALL cl_set_comp_visible("oba111,oba161,oba171",TRUE)  #FUN-BB0038   
   END IF
   #MOD-8A0230---End
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oba TO s_oba.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-810099--start-- 
FUNCTION i110_out()
#    DEFINE
#        l_oba           RECORD LIKE oba_file.*,
#        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#        l_za05          LIKE type_file.chr1000                #        #No.FUN-680137 VARCHAR(40)
#   
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-810099 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN END IF
    LET l_cmd = 'p_query "axmi110" "',g_wc2 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)                                                                                                          
    RETURN
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#
#   LET g_sql="SELECT * FROM oba_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i110_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i110_co                         # CURSOR
#        CURSOR FOR i110_p1
#
#    LET g_rlang = g_lang                               #FUN-4C0096 add
#    CALL cl_outnam('axmi110') RETURNING l_name         #FUN-4C0096 add
#    #FUN-670032...............begin
#    IF g_aaz.aaz90<>'Y' THEN
#       LET g_zaa[39].zaa06='Y'
#       LET g_zaa[40].zaa06='Y'
#    END IF
#    #FUN-670032...............end
#    START REPORT i110_rep TO l_name
#
#    FOREACH i110_co INTO l_oba.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#           EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i110_rep(l_oba.*)
#    END FOREACH
#
#    FINISH REPORT i110_rep
#
#    CLOSE i110_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i110_rep(sr)
#    DEFINE
#        l_last_sw    LIKE type_file.chr1,         #No.FUN-680137  VARCHAR(1)
#        l_desc       LIKE type_file.chr20,    #add 0402 NO.A112   #No.FUN-680137 VARCHAR(20)
#        sr RECORD LIKE oba_file.*,
#        l_gem02   LIKE gem_file.gem02 #FUN-670032
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.oba01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED, pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],  #FUN-670032
#                  g_x[41]  #TQC-790076
#            PRINT g_dash1
#            LET l_last_sw = 'n'
#
#        ON EVERY ROW
#            CASE sr.oba08                                                       
#                 WHEN '1' LET l_desc = g_x[9] CLIPPED
#                 WHEN '2' LET l_desc = g_x[10] CLIPPED
#                 WHEN '3' LET l_desc = g_x[11] CLIPPED
#                 OTHERWISE 
#                          LET l_desc = ''
#            END CASE
#            #FUN-670032...............begin
#            IF g_zaa[40].zaa06<>'Y' THEN
#               SELECT gem02 INTO l_gem02 FROM gem_file
#                                        WHERE gem01=sr.oba10
#               IF SQLCA.sqlcode THEN
#                  LET l_gem02=NULL
#               END IF
#            END IF                                                            
#            #FUN-670032...............end
#            PRINT COLUMN g_c[31],sr.oba01,                                           
#                  COLUMN g_c[32],sr.oba02,                                           
#                  COLUMN g_c[33],sr.oba03,                                           
#                  COLUMN g_c[34],sr.oba04,                                           
#                  COLUMN g_c[35],sr.oba05,                                           
#                  COLUMN g_c[36],sr.oba06,                                           
#                  COLUMN g_c[37],l_desc CLIPPED,                                     
#                  COLUMN g_c[38],sr.oba09 USING "-------&",
#                  COLUMN g_c[39],sr.oba10, #FUN-670032
#                  COLUMN g_c[40],l_gem02,  #FUN-670032
#                  COLUMN g_c[41],sr.oba11  #FUN-690012
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_last_sw = 'y'
#
#        PAGE TRAILER
#            IF l_last_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
##                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-810099--end-- 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i110_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                         #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oba01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i110_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                        #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oba01",FALSE)                                                                                          
   END IF
  #FUN-D20020--add--str---                                                                                                                           
   IF (p_cmd = 'a' AND ( NOT g_before_input_done )) OR 
      (p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N') THEN
      CALL cl_set_comp_entry("oba12",FALSE)
   END IF
  #FUN-D20020--add--end---
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--
 
#FUN-670032
FUNCTION i110_get_gem02(p_oba10)
DEFINE p_oba10 LIKE oba_file.oba10,
       l_gem02 LIKE gem_file.gem02
 
   SELECT gem02 INTO l_gem02 FROM gem_file
                            WHERE gem01=p_oba10
   IF SQLCA.sqlcode THEN
      LET l_gem02=NULL
   END IF
   RETURN l_gem02
END FUNCTION

#FUN-D20020--add--str---
FUNCTION i110_oba13_oba12(p_oba01,p_oba12)
DEFINE p_oba01       LIKE oba_file.oba01
DEFINE p_oba12       LIKE oba_file.oba12
DEFINE l_oba01       LIKE oba_file.oba01
DEFINE l_oba12       LIKE oba_file.oba12
DEFINE l_i           SMALLINT
DEFINE l_oba_oba12   DYNAMIC ARRAY OF RECORD
                     oba01 LIKE oba_file.oba01
                     END RECORD
DEFINE l_sql         STRING

   LET l_sql = " SELECT oba01 FROM oba_file WHERE oba13 = '",p_oba01,"' "
   PREPARE sel_oba01_pre FROM l_sql
   DECLARE sel_oba01_cs  CURSOR FOR sel_oba01_pre
   LET l_i = 1
   FOREACH sel_oba01_cs  INTO l_oba_oba12[l_i].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         RETURN
      END IF
      LET l_i = l_i + 1
   END FOREACH

   CALL l_oba_oba12.deleteElement(l_i)

   FOR l_i = 1 TO l_oba_oba12.getLength()
      LET l_oba01 = l_oba_oba12[l_i].oba01
      UPDATE oba_file SET oba12 = p_oba12 WHERE oba01 = l_oba01
      IF STATUS OR SQLCA.sqlcode THEN
         CALL cl_err('upd',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      LET l_oba12 = p_oba12 + 1
      CALL i110_oba13_oba12(l_oba01,l_oba12)
   END FOR

END FUNCTION

FUNCTION i110_oba13_oba15(p_oba01,p_oba15)
DEFINE p_oba01       LIKE oba_file.oba01
DEFINE p_oba15       LIKE oba_file.oba15
DEFINE l_oba01       LIKE oba_file.oba01
DEFINE l_oba15       LIKE oba_file.oba15
DEFINE l_i           SMALLINT
DEFINE l_oba_oba15   DYNAMIC ARRAY OF RECORD
                     oba01 LIKE oba_file.oba01
                     END RECORD
DEFINE l_sql         STRING

   LET l_sql = " SELECT oba01 FROM oba_file WHERE oba13 = '",p_oba01,"' "
   PREPARE sel_oba01_pre1 FROM l_sql
   DECLARE sel_oba01_cs1  CURSOR FOR sel_oba01_pre1
   LET l_i = 1
   FOREACH sel_oba01_cs1  INTO l_oba_oba15[l_i].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         RETURN
      END IF
      LET l_i = l_i + 1
   END FOREACH

   CALL l_oba_oba15.deleteElement(l_i)

   FOR l_i = 1 TO l_oba_oba15.getLength()
      LET l_oba01 = l_oba_oba15[l_i].oba01
      UPDATE oba_file SET oba15 = p_oba15 WHERE oba01 = l_oba01
      IF STATUS OR SQLCA.sqlcode THEN
         CALL cl_err('upd',SQLCA.sqlcode,1)
         EXIT FOR
      END IF
      LET l_oba15 = p_oba15
      CALL i110_oba13_oba15(l_oba01,l_oba15)
   END FOR

END FUNCTION
#FUN-D20020--add--end---
 
#No.FUN-870100  --BEGIN
FUNCTION i110_get_oba13_desc(p_oba13)
DEFINE p_oba13 LIKE oba_file.oba13,
       l_oba13_desc LIKE oba_file.oba02
 
   SELECT oba02 INTO l_oba13_desc FROM oba_file
                                 WHERE oba01=p_oba13
                                   AND obaacti='Y'   
   IF SQLCA.sqlcode THEN
      LET l_oba13_desc = NULL
   END IF
   RETURN l_oba13_desc
END FUNCTION
#FUN-870100  --END
 
#FUN-870100---begin
#FUNCTION i110_oba13(p_cmd)
#DEFINE
#    p_cmd           LIKE type_file.chr1,
#    l_obaacti       LIKE oba_file.obaacti,
#    l_oba13_desc    LIKE oba_file.oba02
 
#    LET g_errno = ' '
#    SELECT oba02,obaacti INTO l_oba13_desc,l_obaacti
#        FROM oba_file
#        WHERE oba01 = g_oba[l_ac].oba13
#    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-937'
#                            LET g_oba[l_ac].oba02 = NULL
#         WHEN l_obaacti='N' LET g_errno = '9028'
#         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    LET g_oba[l_ac].oba13_desc=l_oba13_desc
#    DISPLAY BY NAME g_oba[l_ac].oba13_desc
#END FUNCTION
#FUN-870100---end
 
#FUN-690012 add--begin check 科目
FUNCTION i110_chk_acc_entry(p_code)
 DEFINE p_code     LIKE aag_file.aag01
 DEFINE l_aagacti  LIKE aag_file.aagacti
 DEFINE l_aag07    LIKE aag_file.aag07
 DEFINE l_aag09    LIKE aag_file.aag09
 DEFINE l_aag03    LIKE aag_file.aag03
 
  SELECT aag03,aag07,aag09,aagacti
     INTO l_aag03,l_aag07,l_aag09,l_aagacti
     FROM aag_file
     WHERE aag01=p_code
     AND aag00 = g_aza.aza81             #No.FUN-730048
  CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
       WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
       OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
  END CASE
END FUNCTION
#FUN-690012 add--end
 
#MOD-8A0230---Begin
FUNCTION i110_chk_acc_entry1(p_code)
 DEFINE p_code     LIKE aag_file.aag01
 DEFINE l_aagacti  LIKE aag_file.aagacti
 DEFINE l_aag07    LIKE aag_file.aag07
 DEFINE l_aag09    LIKE aag_file.aag09
 DEFINE l_aag03    LIKE aag_file.aag03
 
  SELECT aag03,aag07,aag09,aagacti
     INTO l_aag03,l_aag07,l_aag09,l_aagacti
     FROM aag_file
     WHERE aag01=p_code
     AND aag00 = g_aza.aza82             
  CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
       WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
       OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
  END CASE
END FUNCTION
#MOD-8A0230---End
