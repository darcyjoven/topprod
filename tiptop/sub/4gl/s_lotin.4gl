# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: s_lotin.4gl
# Descriptions...: 批/序號入庫作業
# Date & Author..: No.FUN-810036 08/02/18 By Nicola
# Modify.........: No.MOD-840294 08/04/21 By Nicola s_auno傳入值修改
# Modify.........: No.FUN-840157 08/04/24 By Nicola IQC做批/序號管理
# Modify.........: No.FUN-850120 08/05/21 By rainy 1.當歸屬類別有設定時,歸屬單號應判斷存在否(訂單、工單、專案)
#                                                  2.g_argv10多一類別 "SEL" 將資料Q出來後，只可修改數量欄位
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-860080 08/06/09 By Nicola 批/序號分批入庫調整
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.MOD-870219 08/07/17 By Nicola 欄位控管修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-930272 09/03/27 By Smapmin 異動數量不可為null
# Modify.........: No.MOD-950114 09/05/13 By Pengu 增加IQC特採情況
# Modify.........: No.MOD-970232 09/08/25 By Smapmin 序號重複否的控管要check到rvbs_file
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-9C0069 09/12/11 By sherry 在asfi510 asfi520里面維護的批序號內容,在asfi511 asfi526等作業里面查不到 
# Modify.........: No:MOD-A20093 10/02/24 By Smapmin 將最大筆數的控管拿掉
# Modify.........: No.CHI-9A0022 10/03/04 By chenmoyan 添加專案管理與批序號的搭配
# Modify.........: No:CHI-A70047 10/08/16 By Smapmin QC的狀況也要能修改數量
# Modify.........: No:MOD-B70019 11/07/04 By JoHung 修改aim-014外圈判斷
# Modify.........: No:MOD-B70027 11/07/04 By JoHung barcode輸入時對應料件的批序號設定欄位開放
# Modify.........: No:MOD-B70052 11/07/07 By Carrier 序号唯一时,keyin 去掉by imgs_file检查的条件
# Modify.........: No:MOD-BA0106 11/10/17 By johung 副程式不應有transaction
# Modify.........: No:MOD-BB0002 12/06/15 By ck2yuan barcode輸入時控卡set_no_entry使用array判斷應先判斷array是否為空
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No.DEV-D40013 13/04/15 By Nina 過單用

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
    g_ounit         LIKE img_file.img09,     #No.FUN-860045
    g_sunit         LIKE img_file.img09,     #No.FUN-860045
    g_fac           LIKE img_file.img34,     #No.FUN-860045
    g_ima02         LIKE ima_file.ima02,  
    g_ima021        LIKE ima_file.ima021,  
    g_ima918        LIKE ima_file.ima918,  
    g_ima919        LIKE ima_file.ima919,  
    g_ima921        LIKE ima_file.ima921,  
    g_ima922        LIKE ima_file.ima922,  
    g_ima924        LIKE ima_file.ima924,  
    g_rvbs          DYNAMIC ARRAY of RECORD
                       rvbs022    LIKE rvbs_file.rvbs022,
                       rvbs03     LIKE rvbs_file.rvbs03,
                       rvbs04     LIKE rvbs_file.rvbs04,
                       rvbs05     LIKE rvbs_file.rvbs05,
                       rvbs06     LIKE rvbs_file.rvbs06,
                       rvbs10     LIKE rvbs_file.rvbs10,   #No.MOD-860080
                       rvbs11     LIKE rvbs_file.rvbs11,   #No.MOD-860080
                       rvbs12     LIKE rvbs_file.rvbs12,   #No.MOD-860080
                       rvbs07     LIKE rvbs_file.rvbs07,
                       rvbs08     LIKE rvbs_file.rvbs08
                    END RECORD,
    g_rvbs_t        RECORD
                       rvbs022    LIKE rvbs_file.rvbs022,
                       rvbs03     LIKE rvbs_file.rvbs03,
                       rvbs04     LIKE rvbs_file.rvbs04,
                       rvbs05     LIKE rvbs_file.rvbs05,
                       rvbs06     LIKE rvbs_file.rvbs06,
                       rvbs10     LIKE rvbs_file.rvbs10,   #No.MOD-860080
                       rvbs11     LIKE rvbs_file.rvbs11,   #No.MOD-860080
                       rvbs12     LIKE rvbs_file.rvbs12,   #No.MOD-860080
                       rvbs07     LIKE rvbs_file.rvbs07,
                       rvbs08     LIKE rvbs_file.rvbs08
                    END RECORD,
    g_sql           STRING,
    g_wc            STRING,
    g_rec_b         LIKE type_file.num5,  
    l_ac            LIKE type_file.num5, 
    g_argv1         LIKE rvbs_file.rvbs00,  
    g_argv2         LIKE rvbs_file.rvbs01,  
    g_argv3         LIKE rvbs_file.rvbs02, 
    g_argv4         LIKE rvbs_file.rvbs13,    #No.FUN-860045
    g_argv5         LIKE rvbs_file.rvbs021,
    g_argv6         LIKE img_file.img09,   #No.FUN-860045
    g_argv7         LIKE img_file.img09,   #No.FUN-860045
    g_argv8         LIKE img_file.img34,   #No.FUN-860045
    g_argv9         LIKE rvbs_file.rvbs06,
    g_argv10        LIKE type_file.chr3
   ,g_argv11        LIKE rvbs_file.rvbs08  #CHI-9A0022
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_chr           LIKE type_file.chr1 
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_msg           LIKE type_file.chr1000 
DEFINE mi_no_ask       LIKE type_file.num5 
DEFINE g_jump          LIKE type_file.num10
DEFINE g_before_input_done LIKE type_file.num5
DEFINE tm          RECORD
        # wc         LIKE type_file.chr1000,
         wc         STRING,           #NO.FUN-910082
         plant      LIKE azp_file.azp01,
         a          LIKE aba_file.aba01,
         a1         LIKE aaa_file.aaa01,
         gl_date    LIKE type_file.dat, 
         yy,mm      LIKE type_file.num5,
         gl_no      LIKE aba_file.aba01,
         gl_no1     LIKE aba_file.aba01 
                   END RECORD,
       p_row,p_col  LIKE type_file.num5,
       li_result    LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE g_barcode    LIKE type_file.chr1
DEFINE l_i          LIKE type_file.chr1   #No.FUN-860045
DEFINE n_qty        LIKE rvbs_file.rvbs06   #No.FUN-860045
 
#FUNCTION s_lotin(p_type,p_no,p_sn,p_seq,p_item,p_ounit,p_sunit,p_fac,p_oqty,p_act)#RETURNING l_i,n_qty#CHI-9A0022
#傳入參數增加歸屬單號(p_bno)
#程式代號,單據編號,單據項次,檢驗批號,料件編號,單據單位,庫存單位,轉換率,單據數量,歸屬單號,功能形態
FUNCTION s_lotin(p_type,p_no,p_sn,p_seq,p_item,p_ounit,p_sunit,p_fac,p_oqty,p_bno,p_act)#RETURNING l_i,n_qty#CHI-9A0022
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE p_type          LIKE rvbs_file.rvbs00,
          p_no            LIKE rvbs_file.rvbs01,
          p_sn            LIKE rvbs_file.rvbs02,
          p_seq           LIKE rvbs_file.rvbs13,   #No.FUN-860045  
          p_item          LIKE rvbs_file.rvbs021,
          p_ounit         LIKE img_file.img09,     #No.FUN-860045
          p_sunit         LIKE img_file.img09,     #No.FUN-860045
          p_fac           LIKE img_file.img34,     #No.FUN-860045
          p_oqty          LIKE rvbs_file.rvbs06,    #No.FUN-860045 
          p_act           LIKE type_file.chr3,
          p_bno           LIKE rvbs_file.rvbs08,   #CHI-9A0022
          p_sql           LIKE type_file.num5
   DEFINE ls_tmp STRING
   #MOD-9C0069 --begin--                                                  
   DEFINE l_sfp06     LIKE sfp_file.sfp06                            
                                                                                
  IF p_type = 'asfi510' THEN                                                   
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                    
      WHERE sfp01 = p_no                                     
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                      
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                      
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                      
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF          #FUN-C70014
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
   LET g_argv6 = p_ounit   #No.FUN-860045
   LET g_argv7 = p_sunit   #No.FUN-860045
   LET g_argv8 = p_fac     #No.FUN-860045
   LET g_argv9 = p_oqty    #No.FUN-860045 
   LET g_argv10 = p_act 
   LET g_argv11 = p_bno     #CHI-9A0022
   LET g_barcode = "N"
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_row = 2 LET p_col = 4
 
   OPEN WINDOW s_lotin_w AT p_row,p_col WITH FORM "sub/42f/s_lotin"
     ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_lotin")
 
   #-----No.MOD-860080-----
   IF g_prog = "apmt110" OR g_prog = "apmt200" THEN
      CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",TRUE)
   ELSE 
      CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",FALSE)
   END IF
   #-----No.MOD-860080 END-----
 
   LET l_i = "N"   #No.FUN-860045
   LET n_qty = 0   #No.FUN-860045
 
   CALL g_rvbs.clear()
   
   CALL s_lotin_show()
 
   CALL s_lotin_b()  #No.FUN-850100
 
   CALL s_lotin_menu()
 
   CLOSE WINDOW s_lotin_w
   
   RETURN l_i,n_qty
 
END FUNCTION
 
FUNCTION s_lotin_menu()
 
   WHILE TRUE
      CALL s_lotin_bp("G")
      CASE g_action_choice
         WHEN "detail"
            CALL s_lotin_b()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET INT_FLAG = 0
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION s_lotin_show()
 
   LET g_rvbs00 = g_argv1
   LET g_rvbs01 = g_argv2
   LET g_rvbs02 = g_argv3
   LET g_rvbs13 = g_argv4   #No.FUN-860045
   LET g_rvbs021 = g_argv5
   LET g_ounit   = g_argv6   #No.FUN-860045
   LET g_sunit   = g_argv7   #No.FUN-860045
   LET g_fac     = g_argv8   #No.FUN-860045
   LET g_oqty = g_argv9   #No.FUN-860045
   LET g_sqty = g_oqty * g_fac   #No.FUN-860045
 
   DISPLAY g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs021,g_ounit,g_sunit,g_fac,g_oqty,g_sqty   #No.FUN-860045
        TO rvbs01,rvbs02,rvbs13,rvbs021,FORMONLY.ounit,FORMONLY.sunit,FORMONLY.fac,FORMONLY.oqty,FORMONLY.sqty   #No.FUN-860045
 
   SELECT ima02,ima021,ima918,ima919,ima921,ima922,ima924
     INTO g_ima02,g_ima021,g_ima918,g_ima919,g_ima921,g_ima922,g_ima924
     FROM ima_file
    WHERE ima01 = g_rvbs021
 
   DISPLAY g_ima02,g_ima021 TO ima02,ima021
 
   CALL s_lotin_b_fill()
 
END FUNCTION
 
FUNCTION s_lotin_b_fill()

#MOD-9C0069 --begin--
DEFINE l_sfp06     LIKE sfp_file.sfp06  
DEFINE l_rvbs00    LIKE rvbs_file.rvbs00

  IF g_prog = 'asfi510' THEN 
     SELECT sfp06 INTO l_sfp06 FROM sfp_file
      WHERE sfp01 = g_rvbs01
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF 
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF 
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF 
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF   
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF          #FUN-C70014              
     LET l_rvbs00 = 'asfi510'
  ELSE
  	 IF g_prog = 'asfi511' OR g_prog = 'asfi512' OR 
  	    g_prog = 'asfi513' OR g_prog = 'asfi514' THEN 
  	    LET l_rvbs00 = 'asfi510'
  	 END IF         
  END IF   
  IF g_prog = 'asfi520' THEN 
     SELECT sfp06 INTO l_sfp06 FROM sfp_file
      WHERE sfp01 = g_rvbs01
     IF l_sfp06 = '6' THEN LET g_rvbs00 = 'asfi526' END IF 
     IF l_sfp06 = '7' THEN LET g_rvbs00 = 'asfi527' END IF 
     IF l_sfp06 = '8' THEN LET g_rvbs00 = 'asfi528' END IF 
     IF l_sfp06 = '9' THEN LET g_rvbs00 = 'asfi529' END IF                 
     LET l_rvbs00 = 'asfi520'
  ELSE
  	 IF g_prog = 'asfi526' OR g_prog = 'asfi527' OR 
  	    g_prog = 'asfi528' OR g_prog = 'asfi529' THEN 
  	    LET l_rvbs00 = 'asfi520'
  	 END IF           
  END IF 
#MOD-9C0069  --end--
 
   DECLARE rvbs_curs CURSOR FOR
           SELECT rvbs022,rvbs03,rvbs04,rvbs05,rvbs06,rvbs10,rvbs11,rvbs12,   #No.MOD-860080
                  rvbs07,rvbs08
             FROM rvbs_file
            WHERE rvbs00 = g_rvbs00
              AND rvbs01 = g_rvbs01
              AND rvbs02 = g_rvbs02
              AND rvbs13 = g_rvbs13   #No.FUN-860045
              AND rvbs09 = 1
            ORDER BY rvbs022
 
   CALL g_rvbs.clear()
 
   LET g_cnt = 1
 
   FOREACH rvbs_curs INTO g_rvbs[g_cnt].*              #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
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
 
FUNCTION s_lotin_bp(p_ud)
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
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION s_lotin_b()
   DEFINE l_ac_t          LIKE type_file.num5,
          l_row,l_col     LIKE type_file.num5,
          l_n,l_cnt       LIKE type_file.num5,
          l_i             LIKE type_file.num5,    #No.MOD-950114 add
          p_cmd           LIKE type_file.chr1,
          l_lock_sw       LIKE type_file.chr1,
          l_allow_insert  LIKE type_file.chr1,
          l_allow_delete  LIKE type_file.chr1
   DEFINE l_desc       LIKE ima_file.ima02
   DEFINE l_ima920     LIKE ima_file.ima920  #No.MOD-840294
   DEFINE l_ima923     LIKE ima_file.ima923  #No.MOD-840294
 
 
   LET g_action_choice = ""
 
   IF g_rvbs01 IS NULL THEN RETURN END IF
 
   IF g_argv10 = "QRY" THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT rvbs022,rvbs03,rvbs04,rvbs05,rvbs06,",
                      "        rvbs10,rvbs11,rvbs12,rvbs07,rvbs08",   #No.MOD-860080
                      "   FROM rvbs_file ",
                      "  WHERE rvbs00 = ? ",
                      "    AND rvbs01 = ? ",
                      "    AND rvbs02 = ? ",
                      "    AND rvbs13 = ? ",   #No.FUN-860045
                      "    AND rvbs022 = ? ",
                      "    AND rvbs09 = 1 ",
                      "    FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_lotin_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
  #FUN-850120 begin
  #IF g_argv10 = 'SEL' THEN                       #No.MOD-950114 mark
   IF g_argv10 = 'SEL' OR g_argv10 = 'IQC' THEN   #No.MOD-950114 add
   #  LET l_allow_insert = TRUE 
   #  LET l_allow_delete = TRUE 
      LET l_allow_insert = FALSE  #No.FUN-850100
      LET l_allow_delete = FALSE  #No.FUN-850100
   END IF
  #FUN-850120 end
 
  ##-----No.FUN-840157-----
  #IF g_argv10 = "QC" THEN
  #   LET l_allow_insert = FALSE
  #   LET l_allow_delete = FALSE
  #END IF
  ##-----No.FUN-840157 END-----
 
   INPUT ARRAY g_rvbs WITHOUT DEFAULTS FROM s_rvbs.*
       #ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,   #MOD-A20093
       ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,   #MOD-A20093
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success='Y'
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_rvbs_t.* = g_rvbs[l_ac].*
            OPEN s_lotin_bcl USING g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs_t.rvbs022   #No.FUN-860045
            IF STATUS THEN
               CALL cl_err("OPEN s_lotin_bcl:", STATUS, 1)
               CLOSE s_lotin_bcl
               RETURN
            ELSE
               FETCH s_lotin_bcl INTO g_rvbs[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock rvbs',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE
            CALL s_lotin_set_entry_b(p_cmd)
            CALL s_lotin_set_no_entry_b(p_cmd)
            CALL s_lotin_set_no_required()
            CALL s_lotin_set_required()
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()   
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_rvbs[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_rvbs[l_ac].* TO s_rvbs.*
            CALL g_rvbs.deleteElement(l_ac)
            EXIT INPUT
         END IF
 
         IF cl_null(g_rvbs[l_ac].rvbs03) THEN
            LET g_rvbs[l_ac].rvbs03 = " "
         END IF
 
         IF cl_null(g_rvbs[l_ac].rvbs04) THEN
            LET g_rvbs[l_ac].rvbs04 = " "
         END IF
 
         IF cl_null(g_rvbs[l_ac].rvbs08) THEN
            LET g_rvbs[l_ac].rvbs08 = " "
         END IF
 
         #-----No.MOD-860080-----
         IF cl_null(g_rvbs[l_ac].rvbs10) THEN
            LET g_rvbs[l_ac].rvbs10 = 0
         END IF
 
         IF cl_null(g_rvbs[l_ac].rvbs11) THEN
            LET g_rvbs[l_ac].rvbs11 = 0
         END IF
 
         IF cl_null(g_rvbs[l_ac].rvbs12) THEN
            LET g_rvbs[l_ac].rvbs12 = 0
         END IF
         #-----No.MOD-860080 END-----
 
#CHI-9A0022 --Begin
         IF NOT cl_null(g_argv11) THEN
            LET g_rvbs[l_ac].rvbs07 = '3'
            LET g_rvbs[l_ac].rvbs08 = g_argv11
         END IF
#CHI-9A0022 --End
         INSERT INTO rvbs_file(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,
                               rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,
                               rvbs10,rvbs11,rvbs12,rvbs13,   #No.MOD-860080   #No.FUN-860045
                               rvbsplant,rvbslegal)  #FUN-980012 add
                        VALUES(g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs021,
                               g_rvbs[l_ac].rvbs022,
                               g_rvbs[l_ac].rvbs03,g_rvbs[l_ac].rvbs04,
                               g_rvbs[l_ac].rvbs05,g_rvbs[l_ac].rvbs06,
                               g_rvbs[l_ac].rvbs07,g_rvbs[l_ac].rvbs08,1,
                               g_rvbs[l_ac].rvbs10,g_rvbs[l_ac].rvbs11,   #No.MOD-860080
                               g_rvbs[l_ac].rvbs12,g_rvbs13,   #No.MOD-860080   #No.FUN-860045
                               g_plant,g_legal)      #FUN-980012 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file",g_rvbs01,"",STATUS,"","",1)
            LET g_success = 'N'
            CANCEL INSERT
         END IF
         IF g_success='Y' THEN
            LET g_rec_b=g_rec_b+1
            MESSAGE 'Insert Ok'
         ELSE
            CANCEL INSERT
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET g_before_input_done = FALSE
         CALL s_lotin_set_entry_b(p_cmd)
         CALL s_lotin_set_no_entry_b(p_cmd)
         CALL s_lotin_set_no_required()
         CALL s_lotin_set_required()
         LET g_before_input_done = TRUE
         LET l_n = ARR_COUNT()
         INITIALIZE g_rvbs[l_ac].* TO NULL 
         LET g_rvbs_t.* = g_rvbs[l_ac].* 
         IF l_ac > 1 THEN
            LET g_rvbs[l_ac].rvbs05 = g_rvbs[l_ac-1].rvbs05
            IF g_barcode = "Y" THEN
               SELECT MAX(rvbs022) + 1
                 INTO g_rvbs[l_ac].rvbs022
                 FROM rvbs_file
                WHERE rvbs00 = g_rvbs00
                  AND rvbs01 = g_rvbs01
                  AND rvbs02 = g_rvbs02
                  AND rvbs13 = g_rvbs13   #No.FUN-860045
               LET g_rvbs[l_ac].rvbs07 = g_rvbs[l_ac-1].rvbs07
               LET g_rvbs[l_ac].rvbs08 = g_rvbs[l_ac-1].rvbs08
            END IF
         END IF
         CALL cl_show_fld_cont()
         NEXT FIELD rvbs022
 
      BEFORE FIELD rvbs022                      #default 行序
         IF cl_null(g_rvbs[l_ac].rvbs022) OR g_rvbs[l_ac].rvbs022=0 THEN
            SELECT MAX(rvbs022) + 1
              INTO g_rvbs[l_ac].rvbs022
              FROM rvbs_file
             WHERE rvbs00 = g_rvbs00
               AND rvbs01 = g_rvbs01
               AND rvbs02 = g_rvbs02
               AND rvbs13 = g_rvbs13   #No.FUN-860045
               AND rvbs09 = 1
            IF g_rvbs[l_ac].rvbs022 IS NULL THEN
               LET g_rvbs[l_ac].rvbs022 = 1
            END IF
         END IF
 
      AFTER FIELD rvbs022          #check是否重複
         IF NOT cl_null(g_rvbs[l_ac].rvbs022) THEN
            IF g_rvbs[l_ac].rvbs022 != g_rvbs_t.rvbs022 OR
               g_rvbs_t.rvbs022 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM rvbs_file
                WHERE rvbs00 = g_rvbs00
                  AND rvbs01 = g_rvbs01
                  AND rvbs02 = g_rvbs02
                  AND rvbs13 = g_rvbs13   #No.FUN-860045
                  AND rvbs022 = g_rvbs[l_ac].rvbs022
                  AND rvbs09 = 1
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0) 
                  NEXT FIELD rvbs022
               END IF
            END IF
         END IF
 
      BEFORE FIELD rvbs03
         IF g_ima922 = "Y" THEN
            SELECT ima923 INTO l_ima923 FROM ima_file  #No.MOD-840294
             WHERE ima01 = g_rvbs021
            #CALL s_auno(l_ima923,"6") RETURNING g_rvbs[l_ac].rvbs03,l_desc  #No.MOD-840294
            CALL s_auno(l_ima923,"6",g_rvbs021) RETURNING g_rvbs[l_ac].rvbs03,l_desc          #No.FUN-850100
            DISPLAY BY NAME g_rvbs[l_ac].rvbs03
         END IF
 
      AFTER FIELD rvbs03
         IF g_ima921 = "Y" THEN
            IF cl_null(g_rvbs[l_ac].rvbs03) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs03,"asf-597",1)
               NEXT FIELD rvbs03
            END IF
            IF g_ima924 = "Y" THEN
               IF g_rvbs[l_ac].rvbs03 <> g_rvbs_t.rvbs03
                  OR cl_null(g_rvbs_t.rvbs03) THEN
                  #No.MOD-B70052  --Begin
                  #SELECT COUNT(*) INTO l_n FROM imgs_file
                  # WHERE imgs05 = g_rvbs[l_ac].rvbs03
                  #IF l_n > 0 THEN
                  #   CALL cl_err(g_rvbs[l_ac].rvbs03,"axm-396",1)
                  #   NEXT FIELD rvbs03
                  #END IF
                  #No.MOD-B70052  --End  
                  #-----MOD-970232---------
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM rvbs_file
                   WHERE rvbs03 = g_rvbs[l_ac].rvbs03
                     AND NOT (rvbs00 = g_rvbs00
                     AND rvbs01 = g_rvbs01
                     AND rvbs02 = g_rvbs02
                     AND rvbs13 = g_rvbs13
                     AND rvbs09 = 1
                     AND rvbs022 = g_rvbs[l_ac].rvbs022) 
                  IF l_n > 0 THEN
                     CALL cl_err(g_rvbs[l_ac].rvbs03,"axm-396",1)
                     NEXT FIELD rvbs03
                  END IF
                  #-----END MOD-970232-----
               END IF
            END IF
         END IF
 
      BEFORE FIELD rvbs04
         IF g_ima919 = "Y" THEN
            SELECT ima920 INTO l_ima920 FROM ima_file  #No.MOD-840294
             WHERE ima01 = g_rvbs021
            #CALL s_auno(l_ima920,"5") RETURNING g_rvbs[l_ac].rvbs04,l_desc  #No.MOD-840294 
            CALL s_auno(l_ima920,"5",g_rvbs021) RETURNING g_rvbs[l_ac].rvbs04,l_desc  #No.MOD-840294  #No.FUN-850100
            DISPLAY BY NAME g_rvbs[l_ac].rvbs04
         END IF
 
      AFTER FIELD rvbs04
         IF g_ima918 = "Y" THEN
            IF cl_null(g_rvbs[l_ac].rvbs04) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs04,"asf-597",1)
               NEXT FIELD rvbs04
            END IF
         END IF

     
 
      BEFORE FIELD rvbs07
         CALL s_lotin_set_entry_b(p_cmd)
         CALL s_lotin_set_no_required()
 
      AFTER FIELD rvbs07
         CALL s_lotin_set_no_entry_b(p_cmd)
         CALL s_lotin_set_required()
 
      AFTER FIELD rvbs08
         IF NOT cl_null(g_rvbs[l_ac].rvbs07) THEN
            IF cl_null(g_rvbs[l_ac].rvbs08) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs08,"asf-597",1)
               NEXT FIELD rvbs08
            END IF
            #FUN-850120 begin
            CALL s_rvbs_rvbs08() 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs08,g_errno,1)
               NEXT FIELD rvbs08
            END IF
            #FUN-850120 end
         END IF
 
      BEFORE DELETE            #是否取消單身
         IF g_rvbs_t.rvbs022 > 0 AND g_rvbs_t.rvbs022 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','',"", -263, 1) 
               ELSE
                  CALL cl_err("", -263, 1)
               END IF
               CANCEL DELETE
            END IF
 
            DELETE FROM rvbs_file
             WHERE rvbs00 = g_rvbs00
               AND rvbs01 = g_rvbs01
               AND rvbs02 = g_rvbs02
               AND rvbs13 = g_rvbs13   #No.FUN-860045
               AND rvbs022 = g_rvbs_t.rvbs022
               AND rvbs09 = 1
            IF SQLCA.sqlcode THEN                            
                LET g_success = 'N'
                CALL cl_err(g_rvbs_t.rvbs022,SQLCA.sqlcode,1)
                CANCEL DELETE
            END IF
 
            IF g_success='Y'   THEN
               LET g_rec_b=g_rec_b-1
               MESSAGE 'Delete Ok'
            END IF
 
            CONTINUE INPUT
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','',9001,0)
            ELSE
               CALL cl_err('',9001,0)
            END IF
 
            LET INT_FLAG = 0
            LET g_rvbs[l_ac].* = g_rvbs_t.*
            CLOSE s_lotin_bcl
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rvbs[l_ac].rvbs022,-263,1)
            LET g_rvbs[l_ac].* = g_rvbs_t.*
         ELSE
            IF cl_null(g_rvbs[l_ac].rvbs03) THEN
               LET g_rvbs[l_ac].rvbs03 = " "
            END IF
            
            IF cl_null(g_rvbs[l_ac].rvbs04) THEN
               LET g_rvbs[l_ac].rvbs04 = " "
            END IF
 
            IF cl_null(g_rvbs[l_ac].rvbs08) THEN
               LET g_rvbs[l_ac].rvbs08 = " "
            END IF
 
            #-----No.MOD-860080-----
            IF cl_null(g_rvbs[l_ac].rvbs10) THEN
               LET g_rvbs[l_ac].rvbs10 = 0
            END IF
            
            IF cl_null(g_rvbs[l_ac].rvbs11) THEN
               LET g_rvbs[l_ac].rvbs11 = 0
            END IF
            
            IF cl_null(g_rvbs[l_ac].rvbs12) THEN
               LET g_rvbs[l_ac].rvbs12 = 0
            END IF
            #-----No.MOD-860080 END-----
 
           #----------------No.MOD-950114 add
            IF g_argv10 = "IQC" THEN
            UPDATE rvbs_file
               SET rvbs022= g_rvbs[l_ac].rvbs022,
                   rvbs03 = g_rvbs[l_ac].rvbs03,
                   rvbs04 = g_rvbs[l_ac].rvbs04,
                   rvbs05 = g_rvbs[l_ac].rvbs05,
                   rvbs06 = g_rvbs[l_ac].rvbs06,   #CHI-A70047
                   rvbs07 = g_rvbs[l_ac].rvbs07,
                   rvbs08 = g_rvbs[l_ac].rvbs08,
                   rvbs10 = g_rvbs[l_ac].rvbs06,
                   rvbs11 = g_rvbs[l_ac].rvbs11,
                   rvbs12 = g_rvbs[l_ac].rvbs12
             WHERE rvbs00 = g_rvbs00
               AND rvbs01 = g_rvbs01
               AND rvbs02 = g_rvbs02
               AND rvbs13 = g_rvbs13   #No.FUN-860045
               AND rvbs022= g_rvbs_t.rvbs022
               AND rvbs09 = 1
            ELSE
           #----------------No.MOD-950114 end
               UPDATE rvbs_file
                  SET rvbs022= g_rvbs[l_ac].rvbs022,
                      rvbs03 = g_rvbs[l_ac].rvbs03,
                      rvbs04 = g_rvbs[l_ac].rvbs04,
                      rvbs05 = g_rvbs[l_ac].rvbs05,
                      rvbs06 = g_rvbs[l_ac].rvbs06,
                      rvbs07 = g_rvbs[l_ac].rvbs07,
                      rvbs08 = g_rvbs[l_ac].rvbs08,
                      rvbs10 = g_rvbs[l_ac].rvbs10,
                      rvbs11 = g_rvbs[l_ac].rvbs11,
                      rvbs12 = g_rvbs[l_ac].rvbs12
                WHERE rvbs00 = g_rvbs00
                  AND rvbs01 = g_rvbs01
                  AND rvbs02 = g_rvbs02
                  AND rvbs13 = g_rvbs13   #No.FUN-860045
                  AND rvbs022= g_rvbs_t.rvbs022
                  AND rvbs09 = 1
            END IF            #No.MOD-950114 add
 
            IF SQLCA.sqlcode THEN
               CALL cl_err('upd rvbs',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
 
            IF g_success='Y' THEN
               MESSAGE 'UPDATE O.K'
            END IF
 
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','',9001,0)
            ELSE
               CALL cl_err('',9001,0)
            END IF
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_rvbs[l_ac].* = g_rvbs_t.*
            END IF
            CLOSE s_lotin_bcl
            EXIT INPUT
         END IF
         CLOSE s_lotin_bcl
         CALL g_rvbs.deleteElement(g_rec_b+1)
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
      ON ACTION barcode
         IF g_barcode = "N" THEN
            LET g_barcode="Y"
            CALL s_lotin_set_no_entry_b(p_cmd)
            CALL cl_set_act_visible("barcode",FALSE)
            CALL cl_set_act_visible("barcode_cancel",TRUE)
         END IF
 
      ON ACTION barcode_cancel
         IF g_barcode = "Y" THEN
            LET g_barcode="N"
            CALL s_lotin_set_entry_b(p_cmd)
            CALL cl_set_act_visible("barcode",TRUE)
            CALL cl_set_act_visible("barcode_cancel",FALSE)
         END IF
 
      ON ACTION controlo
         IF INFIELD(rvbs022) AND l_ac > 1 THEN
            LET g_rvbs[l_ac].* = g_rvbs[l_ac-1].*
            LET g_rvbs[l_ac].rvbs022 = NULL
            NEXT FIELD rvbs022
         END IF
 
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
 
  #-----------No.MOD-950114 add
   FOR l_i =1 TO g_rec_b
       IF g_argv10 = "IQC" THEN
          UPDATE rvbs_file
             SET rvbs10 = g_rvbs[l_i].rvbs06
           WHERE rvbs00 = g_rvbs00
             AND rvbs01 = g_rvbs01
             AND rvbs02 = g_rvbs02
             AND rvbs13 = g_rvbs13
             AND rvbs022= g_rvbs[l_i].rvbs022
             AND rvbs09 = 1
       END IF
   END FOR
  #-----------No.MOD-950114 end
   CLOSE s_lotin_bcl
 
   CALL s_lotin_chkqty()
 
 
END FUNCTION

FUNCTION s_lotin_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rvbs08",TRUE)
   END IF
 
   IF g_barcode = "N" THEN
#     CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",TRUE)#CHI-9A0022
      CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05",TRUE)              #CHI-9A0022
   END IF
#CHI-9A0022 --Begin
   IF cl_null(g_argv11) THEN
      CALL cl_set_comp_entry("rvbs07,rvbs08",TRUE)
   END IF
#CHI-9A0022 --End
 
END FUNCTION
 
FUNCTION s_lotin_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF g_rvbs.getLength() > 0 THEN   #MOD-BB0002 add
      IF cl_null(g_rvbs[l_ac].rvbs07) THEN
         CALL cl_set_comp_entry("rvbs08",FALSE)
      END IF
   END IF   #MOD-BB0002 add
 
  #-----No.MOD-870219 Mark-----
  #IF g_rvbs00 = "apmt720" OR g_rvbs00 = "apmt730" THEN
  #   CALL cl_set_comp_entry("rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE)
  #END IF
  #-----No.MOD-870219 Mark END-----
 
   IF g_barcode = "Y" THEN
      CALL cl_set_comp_entry("rvbs022,rvbs05,rvbs07,rvbs08",FALSE)
      IF g_ima918 = "N" THEN
#        CALL cl_set_comp_entry("rvbs03",FALSE)   #MOD-B70027 mark
         CALl cl_set_comp_entry("rvbs04",FALSE)   #MOD-B70027
      END IF
      IF g_ima921 = "N" THEN
#        CALL cl_set_comp_entry("rvbs04",FALSE)   #MOD-B70027 mark
         CALL cl_set_comp_entry("rvbs03",FALSE)   #MOD-B70027
      END IF
   END IF
 
  #FUN-850120 begin
  #IF g_argv10 = "SEL" THEN                         #No.MOD-950114 mark
   IF g_argv10 = "SEL" OR g_argv10 = "IQC" THEN     #No.MOD-950114 add
     CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE)
   END IF
  #FUN-850120 end
#CHI-9A0022 --Begin
   IF NOT cl_null(g_argv11) THEN
      CALL cl_set_comp_entry("rvbs07,rvbs08",FALSE)
   END IF
#CHI-9A0022 --End
 
END FUNCTION
 
FUNCTION s_lotin_set_no_required()
 
   CALL cl_set_comp_required("rvbs03,rvbs04,rvbs08",FALSE)
 
END FUNCTION
 
FUNCTION s_lotin_set_required()
 
   IF NOT cl_null(g_rvbs[l_ac].rvbs07) THEN
      CALL cl_set_comp_required("rvbs08",TRUE)
   END IF
 
   IF g_ima918 = 'Y' THEN
      CALL cl_set_comp_required("rvbs04",TRUE)
   END IF
 
   IF g_ima921 = 'Y' THEN
      CALL cl_set_comp_required("rvbs03",TRUE)
   END IF
 
   CALL cl_set_comp_required("rvbs06",TRUE)   #MOD-930272
 
END FUNCTION
 
FUNCTION s_lotin_del(p_type,p_no,p_sn,p_seq,p_item,p_act)
   DEFINE p_type          LIKE rvbs_file.rvbs00,
          p_no            LIKE rvbs_file.rvbs01,
          p_sn            LIKE rvbs_file.rvbs02,
          p_seq           LIKE rvbs_file.rvbs13,   #No.FUN-860045
          p_item          LIKE rvbs_file.rvbs021,
          p_act           LIKE type_file.chr3
   #MOD-9C0069 --begin--                                                            
   DEFINE l_sfp06     LIKE sfp_file.sfp06                                       
                                                                                
  IF p_type = 'asfi510' THEN                                                    
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                    
      WHERE sfp01 = p_no                                                        
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                      
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                      
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                      
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF     
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF          #FUN-C70014                 
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
 
  #BEGIN WORK   #MOD-BA0106 mark
 
   DELETE FROM rvbs_file 
    WHERE rvbs00 = g_argv1
      AND rvbs01 = g_argv2
      AND rvbs02 = g_argv3
      AND rvbs13 = g_argv4
      AND rvbs09 = 1
 
   IF STATUS THEN             
     #ROLLBACK WORK   #MOD-BA0106 mark
      RETURN FALSE
   END IF
 
  #COMMIT WORK   #MOD-BA0106 mark
   RETURN TRUE
 
END FUNCTION
 
FUNCTION s_lotin_chkqty()
   DEFINE l_qty   LIKE rvbs_file.rvbs06
   DEFINE l_r     LIKE type_file.num5   #No.FUN-860045
   DEFINE l_fac   LIKE img_file.img34   #No.FUN-860045
 
   LET l_qty = 0
 
  #----------------No.MOD-950114 add
   IF g_argv10 = "IQC" THEN
    SELECT SUM(rvbs10) INTO l_qty
      FROM rvbs_file
     WHERE rvbs00 = g_rvbs00
       AND rvbs01 = g_rvbs01
       AND rvbs02 = g_rvbs02
       AND rvbs13 = g_rvbs13
       AND rvbs09 = 1
   ELSE
  #----------------No.MOD-950114 end
      SELECT SUM(rvbs06) INTO l_qty 
        FROM rvbs_file
       WHERE rvbs00 = g_rvbs00
         AND rvbs01 = g_rvbs01
         AND rvbs02 = g_rvbs02
         AND rvbs13 = g_rvbs13
         AND rvbs09 = 1
   END IF          #No.MOD-950114 add
 
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
 
   #-----No.FUN-860045-----
#  IF g_sqty <> l_qty THEN                        #MOD-B70019
   IF (g_sqty <> l_qty) OR cl_null(g_sqty) THEN   #MOD-B70019
      #-----CHI-A70047---------
      IF g_prog[1,7] = 'aqct110' OR 
         g_prog[1,7] = 'aqct700' OR
         g_prog[1,7] = 'aqct800' THEN 
         CALL cl_err('','aim-021',1)
         CALL s_lotin_b()
      ELSE
      #-----END CHI-A70047-----
         IF g_sqty < l_qty THEN
            CALL cl_err('','aim-013',1)
            CALL s_lotin_b()
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
      END IF   #CHI-A70047
   END IF
   #-----No.FUN-860045 END-----
 
END FUNCTION
 
#FUN-850120 begin
FUNCTION s_rvbs_rvbs08()
  DEFINE l_sql  STRING  
  DEFINE l_cnt  LIKE type_file.num5
  
  LET l_cnt = 0
  LET g_errno = NULL
  CASE g_rvbs[l_ac].rvbs07 
    WHEN "1" #訂單
      LET l_sql = "SELECT COUNT(*) FROM oea_file WHERE oea01 =?"
    WHEN "2" #工單
      LET l_sql = "SELECT COUNT(*) FROM sfb_file WHERE sfb01 =?"
    WHEN "3" #專案
      LET l_sql = "SELECT COUNT(*) FROM pja_file WHERE pja01 =?"
  END CASE
 
  PREPARE rvbs08_pre FROM l_sql
  EXECUTE rvbs08_pre USING g_rvbs[l_ac].rvbs08 INTO l_cnt 
  IF l_cnt = 0 THEN
    CASE  g_rvbs[l_ac].rvbs07
       WHEN "1" #訂單
         LET g_errno ='asf-959'
       WHEN "2" #工單
         LET g_errno ='mfg2647'
       WHEN "3" #專案
         LET g_errno ='abg-500'
    END CASE
  END IF
END FUNCTION
#FUN-850120 end
#DEV-D40013 add

 
