# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# 
# Pattern name...: s_lotout.4gl 
# Descriptions...: 批/序號出庫作業 
# Date & Author..: No.FUN-810036 08/02/18 By Nicola 
# Modify.........: No.FUN-850120 08/05/21 By rainy  g_argv6多一類別 "SEL" 將資料Q出來後，只可修改數量欄位 
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量 
# Modify.........: No.CHI-870027 08/07/16 By Nicola 歸屬單號修改 
# Modify.........: No.MOD-870202 08/07/16 By Nicola 加程式 
# Modify.........: No.MOD-8B0277 08/11/26 By Smapmin 批序號管理的排序方式錯誤 
# Modify.........: No.CHI-910018 09/01/08 By xiaofeizhu s_lotout的g_argv10多一個"APP"的狀態 
# Modify.........: No.CHI-910023 09/01/12 By xiaofeizhu s_lotout APP狀態時，應依aimi100參數判斷，批/序號欄位是否必輸 
# Modify.........: No.MOD-940047 09/05/25 By Pengu 成是用INT_FLAG判斷時未再恢復INT_FLAG的值 
# Modify.........: No.MOD-960114 09/06/22 By liuxqa CONSTRUCT查詢時，欄位對不上。 
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法 
# Modify.........: No:MOD-9A0161 09/10/26 By Smapmin 重新擷取時資料有誤 
# Modify.........: No:MOD-9C0043 09/12/03 By lilingyu 在asfi528一般退料中維護的批序號內容,在asfi520中無法查詢到 
# Modify.........: No:TQC-9C0039 09/12/03 By lilingyu 在asfi510 asfi520里面維護的批序號內容,在asfi511 asfi526等作業里面查不到 
# Modify.........: No:MOD-9C0069 09/12/11 By sherry 修正TQC-9C0039的問題 
# Modify.........: No:CHI-A10016 10/01/18 By Dido 副程式不可使用 transction 語法 
# Modify.........: No:MOD-A20093 10/02/24 By Smapmin 將最大筆數的控管拿掉
# Modify.........: No.CHI-9A0022 10/03/05 By chenmoyan 增加參數:歸屬單號
# Modify.........: No:MOD-AA0032 10/10/07 By sabrina ima925='2時排序方式應抓取imgs06
# Modify.........: No:CHI-A90011 10/10/12 By Summer 增加顯示單身合計數量
# Modify.........: No:MOD-AB0042 10/11/04 By Smapmin 避免新增只有項次沒有批序號與數量的資料
# Modify.........: No:MOD-B70019 11/07/04 By JoHung 修改aim-014外圈判斷
# Modify.........: No:MOD-C10148 12/01/17 By bart 當g_argv13為QRY時，將資料擷取的action隱藏

DATABASE ds 
  #No.FUN-810036 
GLOBALS "../../config/top.global" 
  
DEFINE 
    g_rvbs00        LIKE rvbs_file.rvbs00,   
    g_rvbs01        LIKE rvbs_file.rvbs01,   
    g_rvbs02        LIKE rvbs_file.rvbs02,   
    g_rvbs021       LIKE rvbs_file.rvbs021,   
    g_rvbs13        LIKE rvbs_file.rvbs13,   #No.FUN-860045   
    g_oqty          LIKE rvbs_file.rvbs06,     #No.FUN-860045 
    g_sqty          LIKE rvbs_file.rvbs06,     #No.FUN-860045 
    g_lqty          LIKE rvbs_file.rvbs06,   #CHI-A90011 add
    g_ounit         LIKE img_file.img09,     #No.FUN-860045 
    g_sunit         LIKE img_file.img09,     #No.FUN-860045 
    g_fac           LIKE img_file.img34,     #No.FUN-860045 
    g_imgs02        LIKE imgs_file.imgs02,   
    g_imgs03        LIKE imgs_file.imgs03,   
    g_imgs04        LIKE imgs_file.imgs04,   
    g_ima02         LIKE ima_file.ima02,   
    g_ima021        LIKE ima_file.ima021,   
    g_rvbs          DYNAMIC ARRAY of RECORD  
                       rvbs022    LIKE rvbs_file.rvbs022, 
                       sel        LIKE type_file.chr1, 
                       rvbs03     LIKE rvbs_file.rvbs03, 
                       rvbs04     LIKE rvbs_file.rvbs04, 
                       rvbs05     LIKE rvbs_file.rvbs05, 
                       imgs08     LIKE imgs_file.imgs08, 
                       rvbs07     LIKE rvbs_file.rvbs07, 
                       rvbs08     LIKE rvbs_file.rvbs08, 
                       rvbs06     LIKE rvbs_file.rvbs06,  
                       rvbs10     LIKE rvbs_file.rvbs10,   #No.FUN-860045 
                       rvbs11     LIKE rvbs_file.rvbs11,   #No.FUN-860045 
                       rvbs12     LIKE rvbs_file.rvbs12   #No.FUN-860045 
                    END RECORD, 
    g_sql           STRING, 
    g_wc            STRING, 
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5,  
    l_n             LIKE type_file.num5,  
    g_argv1         LIKE rvbs_file.rvbs00,   
    g_argv2         LIKE rvbs_file.rvbs01,   
    g_argv3         LIKE rvbs_file.rvbs02,  
    g_argv4         LIKE rvbs_file.rvbs13,    #No.FUN-860045 
    g_argv5         LIKE rvbs_file.rvbs021, 
    g_argv6         LIKE imgs_file.imgs02, 
    g_argv7         LIKE imgs_file.imgs03, 
    g_argv8         LIKE imgs_file.imgs04, 
    g_argv9         LIKE img_file.img09,   #No.FUN-860045 
    g_argv10        LIKE img_file.img09,   #No.FUN-860045 
    g_argv11        LIKE img_file.img34,   #No.FUN-860045 
    g_argv12        LIKE rvbs_file.rvbs06, 
    g_argv13        LIKE type_file.chr3 
   ,g_argv14        LIKE rvbs_file.rvbs08  #No.CHI-9A0022
DEFINE g_curs_index    LIKE type_file.num10 
DEFINE g_row_count     LIKE type_file.num10 
DEFINE g_chr           LIKE type_file.chr1  
DEFINE g_cnt           LIKE type_file.num10 
DEFINE g_msg           LIKE type_file.chr1000  
DEFINE mi_no_ask       LIKE type_file.num5  
DEFINE g_jump          LIKE type_file.num10 
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE tm          RECORD 
         wc         LIKE type_file.chr1000 
                   END RECORD, 
       p_row,p_col  LIKE type_file.num5, 
       li_result    LIKE type_file.num5 
DEFINE g_forupd_sql STRING 
DEFINE g_barcode    LIKE type_file.chr1 
DEFINE l_i          LIKE type_file.chr1     #No.FUN-860045 
DEFINE n_qty        LIKE rvbs_file.rvbs06   #No.FUN-860045 
DEFINE g_cnt_1      LIKE type_file.num5     #No.CHI-910018 
DEFINE g_ima918     LIKE ima_file.ima918    #No.CHI-910023 
DEFINE g_ima921     LIKE ima_file.ima921    #No.CHI-910023 
  
#FUNCTION s_lotout(p_type,p_no,p_sn,p_seq,p_item,p_stock,p_locat,p_lot,p_ounit,p_sunit,p_fac,p_oqty,p_act) #CHI-9A0022
#傳入參數:程式代號,單据編號,單据項次,檢驗批號,倉庫,儲位,批號,單據單位,庫存單位,轉換率,單據數量,歸屬單號,功能形態
FUNCTION s_lotout(p_type,p_no,p_sn,p_seq,p_item,p_stock,p_locat,p_lot,p_ounit,p_sunit,p_fac,p_oqty,p_bno,p_act) #CHI-9A0022
   DEFINE p_row,p_col     LIKE type_file.num5 
   DEFINE p_type          LIKE rvbs_file.rvbs00, 
          p_no            LIKE rvbs_file.rvbs01, 
          p_sn            LIKE rvbs_file.rvbs01, 
          p_seq           LIKE rvbs_file.rvbs13,   #No.FUN-860045   
          p_item          LIKE rvbs_file.rvbs021, 
          p_stock         LIKE imgs_file.imgs02, 
          p_locat         LIKE imgs_file.imgs03, 
          p_lot           LIKE imgs_file.imgs04, 
          p_ounit         LIKE img_file.img09,     #No.FUN-860045 
          p_sunit         LIKE img_file.img09,     #No.FUN-860045 
          p_fac           LIKE img_file.img34,     #No.FUN-860045 
          p_oqty          LIKE rvbs_file.rvbs06,    #No.FUN-860045  
          p_bno           LIKE rvbs_file.rvbs08,   #No.CHI-9A0022
          p_act           LIKE type_file.chr3, 
          p_sql           LIKE type_file.num5 
   DEFINE ls_tmp STRING 
   #MOD-9C0069---Begin                                                   
   DEFINE l_sfp06     LIKE sfp_file.sfp06                             
                                                                                 
   IF p_type = 'asfi510' THEN                                                    
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                     
      WHERE sfp01 = p_no                                      
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                       
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                       
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                       
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF          
     LET p_type = g_rvbs00              
   END IF    
   IF p_type = 'asfi520' THEN 
     SELECT sfp06 INTO l_sfp06 FROM sfp_file 
      WHERE sfp01 = p_no 
     IF l_sfp06 = '6' THEN LET g_rvbs00 = 'asfi526' END IF 
     IF l_sfp06 = '7' THEN LET g_rvbs00 = 'asfi527' END IF 
     IF l_sfp06 = '8' THEN LET g_rvbs00 = 'asfi528' END IF 
     IF l_sfp06 = '9' THEN LET g_rvbs00 = 'asfi529' END IF 
     LET p_type = g_rvbs00 
    END IF        
   #MOD-9C0069---end 
  
   IF p_no IS NULL THEN RETURN "N",0 END IF 
  
   LET g_argv1 = p_type 
   LET g_argv2 = p_no 
   LET g_argv3 = p_sn  
   LET g_argv4 = p_seq   #No.FUN-860045 
   LET g_argv5 = p_item 
   LET g_argv6 = p_stock 
   LET g_argv7 = p_locat 
   LET g_argv8 = p_lot  
   LET g_argv9 = p_ounit    #No.FUN-860045 
   LET g_argv10 = p_sunit   #No.FUN-860045 
   LET g_argv11 = p_fac     #No.FUN-860045 
   LET g_argv12 = p_oqty    #No.FUN-860045 
   LET g_argv13 = p_act  
   LET g_argv14 = p_bno     #No.CHI-9A0022
   LET g_barcode = "N" 
  
   WHENEVER ERROR CALL cl_err_msg_log 
  
   LET p_row = 2 LET p_col = 4 
 
   OPEN WINDOW s_lotout_w AT p_row,p_col WITH FORM "sub/42f/s_lotout" 
     ATTRIBUTE( STYLE = g_win_style ) 
   CALL cl_ui_locale("s_lotout") 
  
   CALL g_rvbs.clear() 
  
   LET l_i = "N"   #No.FUN-860045 
   LET n_qty = 0   #No.FUN-860045 
  
  ##-----No.MOD-860080----- 
  #IF g_prog = "axmt610" OR g_prog = "axmt620" THEN 
  #   CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",TRUE) 
  #ELSE  
      CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",FALSE) 
  #END IF 
   #-----No.MOD-860080 END----- 
   #-----No.MOD-C10148 BEGIN-----
   IF g_argv13 = "QRY" THEN
      CALL cl_set_act_visible("gen_data",FALSE)
   ELSE
      CALL cl_set_act_visible("gen_data",TRUE)
   END IF
   #-----No.MOD-C10148 END----- 
   #IF g_argv13 = "QRY" THEN                    #FUN-850120  
   IF g_argv13 = "QRY" OR g_argv13= 'SEL' OR g_argv13= 'APP' THEN   #FUN-850120      #CHI-910018 Add g_argv13= 'APP'               
      CALL cl_set_comp_visible("sel,imgs08",FALSE) 
      CALL s_lotout_show() 
   ELSE 
      SELECT COUNT(*) INTO l_n FROM rvbs_file 
       WHERE rvbs00 = g_argv1 
         AND rvbs01 = g_argv2 
         AND rvbs02 = g_argv3 
         AND rvbs13 = g_argv4 
         AND rvbs09 = -1 
      IF l_n = 0 THEN 
         CALL cl_set_comp_visible("rvbs022",FALSE) 
         CALL s_lotout_gen() 
      ELSE 
         CALL cl_set_comp_visible("imgs08,rvbs022",FALSE) 
         CALL s_lotout_show() 
      END IF 
   END IF 
  
  #FUN-850120 add 
   IF g_argv13='SEL' OR g_argv13= 'APP' THEN        #CHI-910018 Add OR g_argv13= 'APP' 
     CALL s_lotout_b() 
   END IF 
  #FUN-850120 end 
  
   CALL s_lotout_menu() 
  
   CLOSE WINDOW s_lotout_w 
    
   RETURN l_i,n_qty 
  
END FUNCTION 
  
FUNCTION s_lotout_menu() 
  
   WHILE TRUE 
      CALL s_lotout_bp("G") 
      CASE g_action_choice 
         WHEN "detail" 
            CALL s_lotout_b() 
         WHEN "help" 
            CALL cl_show_help() 
         WHEN "exit" 
            LET INT_FLAG = 0 
            EXIT WHILE 
         WHEN "controlg" 
            CALL cl_cmdask() 
         WHEN "gen_data" 
            CALL s_lotout_gen() 
      END CASE 
   END WHILE 
  
END FUNCTION 
  
FUNCTION s_lotout_show() 
  
   LET g_rvbs00 = g_argv1 
   LET g_rvbs01 = g_argv2 
   LET g_rvbs02 = g_argv3 
   LET g_rvbs13 = g_argv4   #No.FUN-860045 
   LET g_rvbs021 = g_argv5 
   LET g_ounit   = g_argv9   #No.FUN-860045 
   LET g_sunit   = g_argv10  #No.FUN-860045 
   LET g_fac     = g_argv11  #No.FUN-860045 
   LET g_oqty = g_argv12     #No.FUN-860045 
   LET g_sqty = g_oqty * g_fac   #No.FUN-860045 

   #CHI-A90011 add --start--
   LET g_lqty = 0
   SELECT SUM(rvbs06) INTO g_lqty 
     FROM rvbs_file
    WHERE rvbs00 = g_rvbs00
      AND rvbs01 = g_rvbs01
      AND rvbs02 = g_rvbs02
      AND rvbs13 = g_rvbs13
      AND rvbs09 = -1

   IF cl_null(g_lqty) THEN
      LET g_lqty = 0
   END IF
   #CHI-A90011 add --end--
  
   DISPLAY g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs021,g_ounit,g_sunit,g_fac,g_oqty,g_sqty   #No.FUN-860045 
          ,g_lqty #CHI-A90011 add
        TO rvbs01,rvbs02,rvbs13,rvbs021,FORMONLY.ounit,FORMONLY.sunit,FORMONLY.fac,FORMONLY.oqty,FORMONLY.sqty   #No.FUN-860045 
          ,FORMONLY.lqty #CHI-A90011 add
  
   SELECT ima02,ima021,ima918,ima921             #CHI-910023 Add ima918,ima921 
     INTO g_ima02,g_ima021,g_ima918,g_ima921     #CHI-910023 Add g_ima918,g_ima921 
     FROM ima_file 
    WHERE ima01 = g_rvbs021 
  
   DISPLAY g_ima02,g_ima021 TO ima02,ima021 
  
   CALL s_lotout_b_fill() 
  
END FUNCTION 
  
FUNCTION s_lotout_b_fill() 
#MOD-9C0043 --begin-- 
DEFINE l_sfp06     LIKE sfp_file.sfp06   
DEFINE l_rvbs00    LIKE rvbs_file.rvbs00  #TQC-9C0039 
 
  IF g_prog = 'asfi510' THEN  
     SELECT sfp06 INTO l_sfp06 FROM sfp_file 
      WHERE sfp01 = g_rvbs01 
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF  
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF  
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF  
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF                  
#TQC-9C0039 --begin-- 
     LET l_rvbs00 = 'asfi510' 
 ELSE 
         IF g_prog = 'asfi511' OR g_prog = 'asfi512' OR 
            g_prog = 'asfi513' OR g_prog = 'asfi514' THEN 
            LET l_rvbs00 = 'asfi510' 
         END IF 
#TQC-9C0039  --end-- 
  END IF    
  IF g_prog = 'asfi520' THEN  
     SELECT sfp06 INTO l_sfp06 FROM sfp_file 
      WHERE sfp01 = g_rvbs01 
     IF l_sfp06 = '6' THEN LET g_rvbs00 = 'asfi526' END IF  
     IF l_sfp06 = '7' THEN LET g_rvbs00 = 'asfi527' END IF  
     IF l_sfp06 = '8' THEN LET g_rvbs00 = 'asfi528' END IF  
     IF l_sfp06 = '9' THEN LET g_rvbs00 = 'asfi529' END IF                  
#TQC-9C0039 --begin-- 
     LET l_rvbs00 = 'asfi520' 
   ELSE 
         IF g_prog = 'asfi526' OR g_prog = 'asfi527' OR 
            g_prog = 'asfi528' OR g_prog = 'asfi529' THEN 
            LET l_rvbs00 = 'asfi520' 
         END IF 
#TQC-9C0039  --end-- 
  END IF  
#MOD-9C0043 --end--   
  
   DECLARE rvbs_curs CURSOR FOR 
           SELECT rvbs022,'Y',rvbs03,rvbs04,rvbs05,0,rvbs07,rvbs08,rvbs06, 
                  rvbs10,rvbs11,rvbs12   #No.FUN-860045 
             FROM rvbs_file 
            WHERE rvbs00 = g_rvbs00                                 #TQC-9C0039 #MOD-9C0069 remark 
            #WHERE (rvbs00 = g_rvbs00 OR rvbs00 = l_rvbs00)          #TQC-9C0039 #MOD-9C0069 mark 
              AND rvbs01 = g_rvbs01 
              AND rvbs02 = g_rvbs02 
              AND rvbs13 = g_rvbs13   #No.FUN-860045 
              AND rvbs09 = -1 
            ORDER BY rvbs022 
  
   CALL g_rvbs.clear() 
  
   LET g_cnt = 1 
  
   FOREACH rvbs_curs INTO g_rvbs[g_cnt].*              #單身 ARRAY 填充 
      IF STATUS THEN  
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF 
  
      SELECT imgs08 INTO g_rvbs[g_cnt].imgs08 
        FROM imgs_file 
       WHERE imgs01 = g_rvbs021 
         AND imgs02 = g_argv6 
         AND imgs03 = g_argv7 
         AND imgs04 = g_argv8 
         AND imgs05 = g_rvbs[g_cnt].rvbs03 
         AND imgs06 = g_rvbs[g_cnt].rvbs04 
  
      IF cl_null(g_rvbs[g_cnt].imgs08) THEN 
         LET g_rvbs[g_cnt].imgs08 = 0 
      END IF 
  
      LET g_cnt = g_cnt + 1 
  
      #-----MOD-A20093---------
      #IF g_cnt > g_max_rec THEN 
      #   CALL cl_err( '', 9035, 0 ) 
      #   EXIT FOREACH 
      #END IF 
      #-----END MOD-A20093-----
   END FOREACH 
  
   CALL g_rvbs.deleteElement(g_cnt) 
  
   LET g_rec_b= g_cnt-1 
  
END FUNCTION 
  
FUNCTION s_lotout_bp(p_ud) 
   DEFINE p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01) 
  
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN 
      RETURN 
   END IF 
  
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b) 
  
      BEFORE ROW 
         LET l_ac = ARR_CURR() 
         CALL cl_show_fld_cont()  
  
      ON ACTION detail 
         LET g_action_choice="detail" 
         LET l_ac = 1 
         EXIT DISPLAY 
  
      ON ACTION locale 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont() 
  
      ON ACTION help 
         LET g_action_choice="help" 
         EXIT DISPLAY 
  
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE DISPLAY 
  
      AFTER DISPLAY 
         CONTINUE DISPLAY 
  
      ON ACTION controls 
         LET g_action_choice="controls" 
         EXIT DISPLAY 
  
      ON ACTION gen_data 
         LET g_action_choice="gen_data" 
         EXIT DISPLAY 
  
   END DISPLAY 
  
   CALL cl_set_act_visible("accept,cancel", TRUE) 
  
END FUNCTION 
  
FUNCTION s_lotout_b() 
   DEFINE l_ac_t          LIKE type_file.num5, 
          l_row,l_col     LIKE type_file.num5, 
          l_n,l_cnt       LIKE type_file.num5, 
          p_cmd           LIKE type_file.chr1, 
          l_lock_sw       LIKE type_file.chr1, 
          l_allow_insert  LIKE type_file.chr1, 
          l_allow_delete  LIKE type_file.chr1 
   DEFINE l_desc       LIKE ima_file.ima02 
  
   LET g_action_choice = "" 
  
   IF g_rvbs01 IS NULL THEN RETURN END IF 
  
   IF g_argv13 = "QRY" THEN 
      RETURN 
   END IF 
  
   IF g_argv13 <> 'SEL' AND g_argv13 <> 'APP'  THEN   #FUN-850120 add   #CHI-910018 Add g_argv13 <> 'APP' 
      CALL cl_set_comp_visible("sel,imgs08",TRUE) 
   ELSE 
      CALL cl_set_comp_visible("sel,imgs08",FALSE) 
   END IF 
    
  
   CALL cl_opmsg('b') 
  
   LET l_ac_t = 0 
  
   #CHI-910018--Begin--# 
   LET g_cnt_1 = 0    
   IF g_argv13 = 'APP' THEN 
      LET l_allow_insert = cl_detail_input_auth("insert") 
      LET l_allow_delete = cl_detail_input_auth("delete") 
   ELSE 
      LET l_allow_insert = FALSE 
      LET l_allow_delete = FALSE   	   
   END IF    
   #CHI-910018--End--# 
  
   INPUT ARRAY g_rvbs WITHOUT DEFAULTS FROM s_rvbs.* 
       #ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,    #MOD-A20093
       ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,    #MOD-A20093
#                INSERT ROW=FALSE,DELETE ROW=FALSE,                               #CHI-910018 Mark 
#                APPEND ROW=FALSE)                                                #CHI-910018 Mark 
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,             #CHI-910018 
                 APPEND ROW=l_allow_insert)                                       #CHI-910018 
  
      BEFORE INPUT 
         IF g_rec_b != 0 THEN 
            CALL fgl_set_arr_curr(l_ac) 
         END IF 
  
      BEFORE ROW 
         LET l_ac = ARR_CURR() 
         CALL s_lotout_set_entry_b(p_cmd) 
         CALL s_lotout_set_no_entry_b(p_cmd) 
         CALL s_lotout_set_no_required()                                           #CHI-910023	  
         CALL s_lotout_set_required()                                              #CHI-910023 
       
      #CHI-910018--Begin--#    
      BEFORE FIELD rvbs022 
         IF g_argv13 = "APP" THEN                                                  
            LET l_cnt = l_ac-1                                                   
            IF l_cnt <> 0  THEN                                                   
               IF NOT cl_null(g_rvbs[l_cnt].rvbs022) THEN                          
                   LET g_rvbs[l_ac].rvbs022 = g_rvbs[l_cnt].rvbs022 + 1            
               END IF                                                              
            ELSE                                                                  
            	 LET g_rvbs[l_ac].rvbs022 = 1                                        
            END IF                                                                
            LET g_rvbs[l_ac].sel = "Y" 
            #LET g_cnt_1 = g_cnt_1 + 1    #MOD-AB0042                                          
         END IF                                                                    
      #CHI-910018--End--#                          
          
      BEFORE FIELD sel 
         CALL s_lotout_set_entry_b(p_cmd)        
  
      ON CHANGE sel 
         IF g_argv13 = "MOD" THEN   #No.FUN-860045 
            IF g_rvbs[l_ac].sel = "Y" THEN 
               LET g_rvbs[l_ac].rvbs06 = g_rvbs[l_ac].imgs08 
            ELSE 
               LET g_rvbs[l_ac].rvbs06 = 0 
            END IF 
         END IF 
         CALL s_lotout_lqty() #CHI-A90011 add
  
      AFTER FIELD sel 
         CALL s_lotout_set_no_entry_b(p_cmd) 
  
      AFTER FIELD rvbs06 
         IF g_argv13 = "MOD" THEN   #No.FUN-860045 
            IF g_rvbs[l_ac].rvbs06 > g_rvbs[l_ac].imgs08 THEN  
               CALL cl_err(g_rvbs[l_ac].rvbs06,"axm-280",1) 
               NEXT FIELD rvbs06 
            END IF 
         END IF 
       
      #CHI-910018--Begin--# 
      AFTER FIELD rvbs07 
         IF g_argv13 = "APP" THEN   #No.FUN-860045 
            IF cl_null(g_rvbs[l_ac].rvbs07) THEN  
               CALL cl_set_comp_entry("rvbs08",FALSE) 
            END IF 
            CALL s_lotout_set_required()                                  #CHI-910023 
         END IF 
      #CHI-910018--End--#             
  
      AFTER ROW 
         IF INT_FLAG THEN 
            LET INT_FLAG = 0    #No.MOD-940047 add 
            EXIT INPUT 
         END IF 
         CALL s_lotout_lqty() #CHI-A90011 add

      AFTER INSERT    #MOD-AB0042
         LET g_cnt_1 = g_cnt_1 + 1     #MOD-AB0042                                       
  
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入 
         IF INT_FLAG THEN 
            LET INT_FLAG = 0    #No.MOD-940047 add 
            EXIT INPUT   
         END IF 
  
    #FUN-850120 begin 
      ON ROW CHANGE 
        IF g_argv13 = 'SEL' THEN 
           LET g_rvbs[l_ac].sel='Y'  
        END IF 
    #FUN-850120 
  
      ON ACTION gen_data 
         CALL s_lotout_gen() 
  
      ON ACTION controlg 
         CALL cl_cmdask() 
  
      ON ACTION CONTROLR 
         CALL cl_show_req_fields() 
  
      ON ACTION controlf 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE INPUT 
  
      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO")  
  
   END INPUT 
  
   CALL s_lotout_rvbs() 
  
END FUNCTION 

#CHI-A90011 add --start--
FUNCTION s_lotout_lqty()
   DEFINE i LIKE type_file.num5

   LET g_lqty = 0
   FOR i = 1 TO g_rvbs.getlength()
       IF g_rvbs[i].sel="Y" THEN 
          LET g_lqty = g_lqty + g_rvbs[i].rvbs06
       END IF
   END FOR
   DISPLAY g_lqty TO FORMONLY.lqty

END FUNCTION
#CHI-A90011 add --end--
  
FUNCTION s_lotout_set_entry_b(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1 
  
   CALL cl_set_comp_entry("rvbs06",TRUE) 
   #CHI-910018--Begin--# 
   IF g_argv13 = 'APP' THEN   
#     CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",TRUE) #CHI-9A0022
      CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05",TRUE) #CHI-9A0022
#CHI-9A0022 --Begin
      IF cl_null(g_argv14) THEN
         CALL cl_set_comp_entry("rvbs07,rvbs08",TRUE)
      END IF
#CHI-9A0022 --End
   END IF 
   #CHI-910018--End--#       
  
END FUNCTION 
  
FUNCTION s_lotout_set_no_entry_b(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1 
    
#FUN-850120 begin 
   IF g_argv13 = 'SEL' THEN  #只可修改數量 
      CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE) 
   ELSE 
      IF g_argv13 <> 'APP' THEN                               #CHI-910018 
        IF g_rvbs[l_ac].sel = "N" THEN 
           CALL cl_set_comp_entry("rvbs06",FALSE) 
        END IF    
#CHI-9A0022 --Begin                                                                                                                 
      ELSE                                                                                                                          
         IF cl_null(g_argv14) THEN                                                                                                  
            CALL cl_set_comp_entry("rvbs07,rvbs08",FALSE)                                                                           
         END IF                                                                                                                     
#CHI-9A0022 --End
     END IF                                                  #CHI-910018 
   END IF 
#FUN-850120 end    
  
  
END FUNCTION 
  
FUNCTION s_lotout_gen() 
   DEFINE l_wc   STRING 
   DEFINE l_sql  STRING 
   DEFINE l_ima925   LIKE ima_file.ima925 
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022 
   DEFINE l_imgs11   LIKE imgs_file.imgs11 
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06   #MOD-9A0161 
  
   IF g_argv13 = "SEL" THEN 
      RETURN 
   END IF 
  
   CALL cl_set_comp_visible("imgs08",TRUE) 
  
   LET g_rvbs00 = g_argv1 
   LET g_rvbs01 = g_argv2 
   LET g_rvbs02 = g_argv3 
   LET g_rvbs13 = g_argv4   #No.FUN-860045 
   LET g_rvbs021 = g_argv5 
   LET g_imgs02 = g_argv6 
   LET g_imgs03 = g_argv7 
   LET g_imgs04 = g_argv8 
   LET g_ounit  = g_argv9   #No.FUN-860045 
   LET g_sunit  = g_argv10  #No.FUN-860045 
   LET g_fac    = g_argv11  #No.FUN-860045 
   LET g_oqty = g_argv12     #No.FUN-860045 
   LET g_sqty = g_oqty * g_fac   #No.FUN-860045 
  
   IF g_imgs02 IS NULL THEN LET g_imgs02= ' ' END IF  
   IF g_imgs03 IS NULL THEN LET g_imgs03= ' ' END IF 
   IF g_imgs04 IS NULL THEN LET g_imgs04= ' ' END IF 
  
   SELECT ima02,ima021,ima925 
     INTO g_ima02,g_ima021,l_ima925 
     FROM ima_file 
    WHERE ima01 = g_rvbs021 
  
   CLEAR FORM  
  
   DISPLAY g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs021,g_ounit,g_sunit,g_fac,g_oqty,g_sqty   #No.FUN-860045 
          ,g_lqty #CHI-A90011 add
        TO rvbs01,rvbs02,rvbs13,rvbs021,FORMONLY.ounit,FORMONLY.sunit,FORMONLY.fac,FORMONLY.oqty,FORMONLY.sqty   #No.FUN-860045 
          ,FORMONLY.lqty #CHI-A90011 add
  
   DISPLAY g_ima02,g_ima021 TO ima02,ima021 
  
#   CONSTRUCT l_wc ON imgs04,imgs05,imgs09,imgs10,imgs11     #No.MOD-960114 mark 
   CONSTRUCT l_wc ON imgs05,imgs06,imgs09,imgs10,imgs11      #No.MOD-960114 mod 
                FROM s_rvbs[1].rvbs03,s_rvbs[1].rvbs04,s_rvbs[1].rvbs05, 
                     s_rvbs[1].rvbs07,s_rvbs[1].rvbs08 
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE CONSTRUCT 
  
      ON ACTION about 
         CALL cl_about() 
   
      ON ACTION help 
         CALL cl_show_help() 
   
      ON ACTION controlg 
         CALL cl_cmdask() 
  
      ON ACTION qbe_save 
         CALL cl_qbe_save() 
  
   END CONSTRUCT 
  
   IF INT_FLAG THEN 
      LET INT_FLAG = 0    #No.MOD-940047 add 
      RETURN 
   END IF 
  
   #-----No.CHI-870027----- 
#CHI-9A0022 --Begin
#  IF g_prog[1,7]='axmt610' OR g_prog[1,7]='axmt620' OR 
#     g_prog='axmt628' OR g_prog='axmt629' OR g_prog='axmt640' OR 
#     g_prog='axmt820' OR g_prog='axmt821' THEN 
#      
#     SELECT ogb31 INTO l_imgs11 FROM ogb_file 
#      WHERE ogb01 = g_rvbs01 
#        AND ogb03 = g_rvbs02  
# 
#  END IF 
# 
#  IF g_prog[1,7]='asfi510' OR g_prog[1,7]='asfi520' OR 
#     g_prog[1,7]='asfi511' OR g_prog[1,7]='asfi512' OR 
#     g_prog[1,7]='asfi526' OR g_prog[1,7]='asfi527' OR   #No.MOD-870202 
#     g_prog[1,7]='asfi528' OR g_prog[1,7]='asfi529' OR   #No.MOD-870202 
#     g_prog[1,7]='asfi513' OR g_prog[1,7]='asfi514' THEN  
#      
#     SELECT sfs03 INTO l_imgs11 FROM sfs_file 
#      WHERE sfs01 = g_rvbs01 
#        AND sfs02 = g_rvbs02  
# 
#  END IF 
   LET l_imgs11 = g_argv14
#CHI-9A0022 --End
  
   IF cl_null(l_imgs11) THEN 
      LET l_imgs11 = " " 
   END IF 
  
   #-----No.CHI-870027----- 
  
   LET l_sql = "SELECT '','N',imgs05,imgs06,imgs09,imgs08,imgs10,imgs11,0", 
               "  FROM img_file,imgs_file", 
               " WHERE img01 = imgs01", 
               "   AND img02 = imgs02", 
               "   AND img03 = imgs03", 
               "   AND img04 = imgs04", 
               "   AND imgs01 = '",g_rvbs021,"'", 
               "   AND imgs02 = '",g_imgs02,"'", 
               "   AND imgs03 = '",g_imgs03,"'", 
               "   AND imgs04 = '",g_imgs04,"'", 
              #"   AND (imgs11 = ' ' OR imgs11 = '",g_rvbs01,"')", 
               "   AND (imgs11 = ' ' OR imgs11 = '",l_imgs11,"')",  #No.CHI-870027 
               "   AND ",l_wc, 
               "   AND imgs08 > 0", 
               "   AND img10 > 0" 
  
   CASE l_ima925  #排序方式 
      WHEN "1"   #序號 
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs05"   #MOD-8B0277   imgs04-->imgs05 
      WHEN "2"   #製造批號
        #LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs04"   #MOD-8B0277   imgs05-->imgs04 #MOD-AA0032
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs06"   #MOD-AA0032 add
      WHEN "3"   #製造日期 
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs09" 
   END CASE 
  
   PREPARE imgs_pre FROM l_sql 
   DECLARE imgs_curs CURSOR FOR imgs_pre 
  
   SELECT MAX(rvbs022)+1 INTO g_cnt FROM rvbs_file  
    WHERE rvbs00 = g_argv1 
      AND rvbs01 = g_argv2 
      AND rvbs02 = g_argv3 
      AND rvbs13 = g_argv4 
      AND rvbs09 = -1 
  
   IF cl_null(g_cnt) THEN 
      LET g_cnt = 1 
   END IF 
  
   LET g_lqty = 0 #CHI-A90011 add
   FOREACH imgs_curs INTO g_rvbs[g_cnt].*              #單身 ARRAY 填充 
      IF STATUS THEN  
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF 

      LET g_lqty = g_lqty + g_rvbs[g_cnt].rvbs06 #CHI-A90011 add
  
      LET l_rvbs022 = 0 
  
      #SELECT rvbs022 INTO l_rvbs022 FROM rvbs_file   #MOD-9A0161 
      SELECT rvbs022,rvbs06 INTO l_rvbs022,l_rvbs06 FROM rvbs_file   #MOD-9A0161 
       WHERE rvbs00 = g_argv1 
         AND rvbs01 = g_argv2 
         AND rvbs02 = g_argv3 
         AND rvbs13 = g_argv4 
         AND rvbs03 = g_rvbs[g_cnt].rvbs03  
         AND rvbs04 = g_rvbs[g_cnt].rvbs04  
         AND rvbs08 = g_rvbs[g_cnt].rvbs08  
         AND rvbs09 = -1 
  
      IF l_rvbs022 <> 0 THEN 
         #-----MOD-9A0161--------- 
         LET g_rvbs[l_rvbs022].* = g_rvbs[g_cnt].* 
         LET g_rvbs[l_rvbs022].rvbs06 = l_rvbs06 
         LET g_rvbs[l_rvbs022].sel = 'Y'  
         #LET g_rvbs[l_rvbs022].imgs08 = g_rvbs[g_cnt].imgs08 
         #-----END MOD-9A0161----- 
      ELSE 
         LET g_rvbs[g_cnt].rvbs022 = g_cnt 
         LET g_cnt = g_cnt + 1 
      END IF 
  
      #-----MOD-A20093---------
      #IF g_cnt > g_max_rec THEN 
      #   CALL cl_err( '', 9035, 0 ) 
      #   EXIT FOREACH 
      #END IF 
      #-----END MOD-A20093-----
  
   END FOREACH 
   DISPLAY g_lqty TO FORMONLY.lqty #CHI-A90011 add
  
   CALL g_rvbs.deleteElement(g_cnt) 
  
   LET g_rec_b= g_cnt-1 
  
  
  
END FUNCTION 
  
FUNCTION s_lotout_del(p_type,p_no,p_sn,p_seq,p_item,p_act) 
   DEFINE p_type          LIKE rvbs_file.rvbs00, 
          p_no            LIKE rvbs_file.rvbs01, 
          p_sn            LIKE rvbs_file.rvbs01, 
          p_seq           LIKE rvbs_file.rvbs13, 
          p_item          LIKE rvbs_file.rvbs021, 
          p_act           LIKE type_file.chr3 
   #MOD-9C0069---begin                                                             
   DEFINE l_sfp06     LIKE sfp_file.sfp06                                        
                                                                                 
  IF p_type = 'asfi510' THEN                                                     
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                     
      WHERE sfp01 = p_no                                                         
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                       
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                       
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                       
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF                       
     LET p_type = g_rvbs00                                                       
  END IF                    
  IF p_type = 'asfi520' THEN                                                     
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                     
      WHERE sfp01 = p_no                                                         
     IF l_sfp06 = '6' THEN LET g_rvbs00 = 'asfi526' END IF                       
     IF l_sfp06 = '7' THEN LET g_rvbs00 = 'asfi527' END IF                       
     IF l_sfp06 = '8' THEN LET g_rvbs00 = 'asfi528' END IF                       
     IF l_sfp06 = '9' THEN LET g_rvbs00 = 'asfi529' END IF                       
     LET p_type = g_rvbs00                                                       
   END IF                                                                        
   #MOD-9C0069---end        
  
   LET g_argv1 = p_type 
   LET g_argv2 = p_no 
   LET g_argv3 = p_sn  
   LET g_argv4 = p_seq 
   LET g_argv5 = p_item 
   LET g_argv6 = p_act  
  
   IF cl_null(g_argv1) THEN 
      RETURN 
   END IF 
   
   IF g_argv6 <> "DEL" THEN 
      RETURN 
   END IF 
  
  #BEGIN WORK                #CHI-A10016 mark 
  
   DELETE FROM rvbs_file  
    WHERE rvbs00 = g_argv1 
      AND rvbs01 = g_argv2 
      AND rvbs02 = g_argv3 
      AND rvbs13 = g_argv4 
      AND rvbs09 = -1 
  
   IF STATUS THEN 
     #ROLLBACK WORK          #CHI-A10016 mark
      RETURN FALSE 
   END IF 
  
  #COMMIT WORK               #CHI-A10016 mark 
   RETURN TRUE 
  
END FUNCTION 
  
FUNCTION s_lotout_rvbs() 
   DEFINE l_cnt     LIKE type_file.num10 
   DEFINE l_success LIKE type_file.chr1 
   DEFINE l_rvbs022 LIKE rvbs_file.rvbs022 
  
   LET l_success = "Y" 
  
  #BEGIN WORK                #CHI-A10016 mark
  
   DELETE FROM rvbs_file  
    WHERE rvbs00 = g_rvbs00 
      AND rvbs01 = g_rvbs01 
      AND rvbs02 = g_rvbs02 
      AND rvbs13 = g_rvbs13 
      AND rvbs09 = -1 
  
   IF STATUS THEN 
      LET l_success = "N" 
      CALL cl_err3("del","rvbs_file",g_rvbs01,"",SQLCA.sqlcode,"","del_rvbs",1) 
   END IF 
  
   LET l_rvbs022 = 1 
    
   #CHI-910018--Begin--#  
   IF g_argv13 = 'APP' THEN 
      IF cl_null(g_rec_b) OR g_rec_b = 0 THEN 
         LET g_rec_b = g_cnt_1 
      ELSE 
      	 LET g_rec_b = g_rec_b + g_cnt_1 
      END IF	     
   END IF 
   #CHI-910018--End--#  
  
    FOR l_cnt = 1 TO g_rec_b 
     
      #CHI-910018--Begin--#    
      IF cl_null(g_rvbs[l_cnt].rvbs08) THEN 
         LET g_rvbs[l_cnt].rvbs08 = ' ' 
      END IF 
      IF cl_null(g_rvbs[l_cnt].rvbs03) THEN                                                                                          
         LET g_rvbs[l_cnt].rvbs03 = ' '                                                                                              
      END IF 
      IF cl_null(g_rvbs[l_cnt].rvbs04) THEN                                                                                          
         LET g_rvbs[l_cnt].rvbs04 = ' '                                                                                              
      END IF    
      #CHI-910018--End--# 
      
      IF g_rvbs[l_cnt].sel = "Y" THEN 
#No.CHI-9A0022 --Begin
      IF g_rvbs13 = 'APP' THEN
         IF NOT cl_null(g_argv14) THEN
            LET g_rvbs[l_cnt].rvbs07 = '3'
            LET g_rvbs[l_cnt].rvbs08 = g_argv14
         END IF
      END IF
#No.CHI-9A0022 --End
  
         INSERT INTO rvbs_file(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03, 
                               rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09, 
                               rvbs10,rvbs11,rvbs12,rvbs13,   #No.FUN-860045 
                               rvbsplant,rvbslegal)    #FUN-980012 add 
                        VALUES(g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs021,l_rvbs022, 
                               g_rvbs[l_cnt].rvbs03,g_rvbs[l_cnt].rvbs04, 
                               g_rvbs[l_cnt].rvbs05,g_rvbs[l_cnt].rvbs06, 
                               g_rvbs[l_cnt].rvbs07,g_rvbs[l_cnt].rvbs08,-1, 
                               0,0,0,g_rvbs13, 
                               g_plant,g_legal)    #FUN-980012 add 
  
         LET l_rvbs022 = l_rvbs022 + 1 
  
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","rvbs_file",g_rvbs01,"",STATUS,"","",1) 
            LET l_success = 'N' 
         END IF 
  
      END IF 
  
    END FOR 
  
   IF l_success = "Y" THEN 
     #COMMIT WORK            #CHI-A10016 mark
      LET g_success = 'Y'    #CHI-A10016
   ELSE 
     #ROLLBACK WORK          #CHI-A10016 mark
      LET g_success = 'N'    #CHI-A10016
   END IF 
  
   CALL s_lotout_chkqty() 
  
END FUNCTION 
  
FUNCTION s_lotout_chkqty() 
   DEFINE l_qty   LIKE rvbs_file.rvbs06 
   DEFINE l_r     LIKE type_file.num5   #No.FUN-860045 
   DEFINE l_fac   LIKE img_file.img34   #No.FUN-860045 
  
   LET l_qty = 0 
  
   SELECT SUM(rvbs06) INTO l_qty  
     FROM rvbs_file 
    WHERE rvbs00 = g_rvbs00 
      AND rvbs01 = g_rvbs01 
      AND rvbs02 = g_rvbs02 
      AND rvbs13 = g_rvbs13 
      AND rvbs09 = -1 
  
   IF cl_null(l_qty) THEN 
      LET l_qty = 0 
   END IF 
  
   #-----No.FUN-860045----- 
#  IF g_sqty <> l_qty THEN                        #MOD-B70019 mark
   IF (g_sqty <> l_qty) OR cl_null(g_sqty) THEN   #MOD-B70019
      IF g_sqty < l_qty THEN 
         CALL cl_err('','aim-013',1) 
         CALL s_lotout_b() 
      ELSE 
         IF cl_confirm('aim-014') THEN 
            LET l_i = "Y" 
            CALL s_umfchk(g_rvbs021,g_sunit,g_ounit) 
                RETURNING l_r,l_fac 
            IF l_r = 1 THEN LET l_fac = 1 END IF 
            LET n_qty = l_qty * l_fac  
         ELSE  
            LET l_i = "N" 
            LET n_qty = 0 
         END IF 
      END IF 
   END IF 
   #-----No.FUN-860045 END----- 
  
END FUNCTION 
  
#CHI-910023--Begin--# 
FUNCTION s_lotout_set_no_required() 
  
  IF g_argv13 = 'APP' THEN   
     CALL cl_set_comp_required("rvbs03,rvbs04,rvbs08",FALSE) 
  END IF 
    
END FUNCTION 
  
FUNCTION s_lotout_set_required() 
  
  IF g_argv13 = 'APP' THEN 
     IF NOT cl_null(g_rvbs[l_ac].rvbs07) THEN 
        CALL cl_set_comp_required("rvbs08",TRUE) 
     END IF 
  
     IF g_ima918 = 'Y' THEN 
        CALL cl_set_comp_required("rvbs04",TRUE) 
     END IF 
  
     IF g_ima921 = 'Y' THEN 
        CALL cl_set_comp_required("rvbs03",TRUE) 
     END IF 
  END IF    
  
END FUNCTION 
#CHI-910023--END--# 
  
