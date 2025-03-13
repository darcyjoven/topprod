# Prog. Version..: '5.30.06-13.04.22(00009)'     #
# 
# Pattern name...: s_mod_lot.4gl 
# Descriptions...: 批/序號處理作業 
# Date & Author..: No.TQC-B90236 11/10/24 By yuhuabao 
# Modify.........: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify.........: No.TQC-C20305 12/02/23 By yuhuabao 處理gen_data隱藏不掉bug
# Modify.........: No.TQC-C20462 12/02/23 By yuhuabao 無特性的料件會多出特性欄位
# Modify.........: No.TQC-C20344 12/02/29 By yuhuabao 自動帶出之批序號資料加上過瀘歸屬批號的條件
# Modify.........: No.TQC-C20312 12/03/07 By yuhuabao 改無法更新inj_file
# Modify.........: No.TQC-C40031 12/04/06 By yuhuabao 單身項次加相應的控管
# Modify.........: No.CHI-C30062 12/07/02 By Sakura 刪除批序號資料時，檢查其他單據是否有使用此料號+製造批號，無的話，一併刪除特性明細資料(inj_file)
# Modify.........: No.MOD-C60216 12/07/02 By SunLM  大陸版產生簽退單的rvbs時候,調用s_mod_lot時候,已經開啟事務,故此處關閉事務
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:TQC-C70056 12/09/05 By zhuhao l_sql傳參
# Modify.........: No:MOD-CB0031 12/11/23 By Elise 入庫單且為重工工單，不控卡axm-396
# Modify.........: No:CHI-CB0056 12/11/26 By suncx 增加工單退料時對批序號退料數量的管控
# Modify.........: No:MOD-CC0047 13/01/11 By Elise MOD-CB0031應考慮重工委外工單
# Modify.........: No:FUN-CC0006 12/12/17 By Sakura 新增特性料件依oeba07設定的條件進行資料篩選動作
# Modify.........: No:CHI-C50022 13/04/01 By Alberti 當入庫時(apmt720)且有檢驗時,許去檢核rvbs,避免入錯製造批序號
# Modify.........: No.DEV-D40013 13/04/15 By Nina 純過單
# Modify.........: No.MOD-D90093 13/09/18 By suncx s_lot_del()函数返回值有问题

#共享變量定義---begin
DATABASE ds 
GLOBALS "../../config/top.global" 
  
DEFINE 
    g_rvbs00        LIKE rvbs_file.rvbs00,   
    g_rvbs01        LIKE rvbs_file.rvbs01,   
    g_rvbs02        LIKE rvbs_file.rvbs02,   
    g_rvbs021       LIKE rvbs_file.rvbs021,   
    g_rvbs13        LIKE rvbs_file.rvbs13,     
    g_oqty          LIKE rvbs_file.rvbs06,      
    g_sqty          LIKE rvbs_file.rvbs06,    
    g_lqty          LIKE rvbs_file.rvbs06, 
    g_ounit         LIKE img_file.img09,
    g_sunit         LIKE img_file.img09,
    g_fac           LIKE img_file.img34, 
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
                       rvbs10     LIKE rvbs_file.rvbs10,   
                       rvbs11     LIKE rvbs_file.rvbs11, 
                       rvbs12     LIKE rvbs_file.rvbs12,
                       att01      LIKE imac_file.imac05,
                       att02      LIKE imac_file.imac05,
                       att03      LIKE imac_file.imac05,
                       att04      LIKE imac_file.imac05,
                       att05      LIKE imac_file.imac05,
                       att06      LIKE imac_file.imac05,
                       att07      LIKE imac_file.imac05,
                       att08      LIKE imac_file.imac05,
                       att09      LIKE imac_file.imac05,
                       att10      LIKE imac_file.imac05
                    END RECORD,
    g_rvbs_t        RECORD  
                       rvbs022    LIKE rvbs_file.rvbs022, 
                       sel        LIKE type_file.chr1, 
                       rvbs03     LIKE rvbs_file.rvbs03, 
                       rvbs04     LIKE rvbs_file.rvbs04, 
                       rvbs05     LIKE rvbs_file.rvbs05, 
                       imgs08     LIKE imgs_file.imgs08, 
                       rvbs07     LIKE rvbs_file.rvbs07, 
                       rvbs08     LIKE rvbs_file.rvbs08, 
                       rvbs06     LIKE rvbs_file.rvbs06,  
                       rvbs10     LIKE rvbs_file.rvbs10,   
                       rvbs11     LIKE rvbs_file.rvbs11, 
                       rvbs12     LIKE rvbs_file.rvbs12,
                       att01      LIKE imac_file.imac05,
                       att02      LIKE imac_file.imac05,
                       att03      LIKE imac_file.imac05,
                       att04      LIKE imac_file.imac05,
                       att05      LIKE imac_file.imac05,
                       att06      LIKE imac_file.imac05,
                       att07      LIKE imac_file.imac05,
                       att08      LIKE imac_file.imac05,
                       att09      LIKE imac_file.imac05,
                       att10      LIKE imac_file.imac05
                    END RECORD, 
    g_sql           STRING, 
    g_wc            STRING, 
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5,  
    l_n             LIKE type_file.num5,  
    g_argv1         LIKE rvbs_file.rvbs00,   
    g_argv2         LIKE rvbs_file.rvbs01,   
    g_argv3         LIKE rvbs_file.rvbs02,  
    g_argv4         LIKE rvbs_file.rvbs13,
    g_argv5         LIKE rvbs_file.rvbs021, 
    g_argv6         LIKE imgs_file.imgs02, 
    g_argv7         LIKE imgs_file.imgs03, 
    g_argv8         LIKE imgs_file.imgs04, 
    g_argv9         LIKE img_file.img09,  
    g_argv10        LIKE img_file.img09,
    g_argv11        LIKE img_file.img34,
    g_argv12        LIKE rvbs_file.rvbs06, 
    g_argv13        LIKE type_file.chr3, 
    g_argv14        LIKE rvbs_file.rvbs08,
    g_argv15        LIKE rvbs_file.rvbs09
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
DEFINE l_i          LIKE type_file.chr1    
DEFINE n_qty        LIKE rvbs_file.rvbs06 
DEFINE g_cnt_1      LIKE type_file.num5
DEFINE g_ima918        LIKE ima_file.ima918,  
       g_ima919        LIKE ima_file.ima919,  
       g_ima921        LIKE ima_file.ima921,  
       g_ima922        LIKE ima_file.ima922,  
       g_ima924        LIKE ima_file.ima924
DEFINE g_imac       DYNAMIC ARRAY OF RECORD
          imac04    LIKE imac_file.imac04
END RECORD 
#共享變量定義---end
DEFINE g_sfb_wo     LIKE sfb_file.sfb01   #MOD-CB0031 add
DEFINE g_sfb_wo_f   LIKE type_file.chr1   #MOD-CB0031 add

#傳入參數: 程式代號(p_type),單据編號(p_no),單据項次(p_sn),檢驗批號(p_seq)
#       ：料件編號(p_item),倉庫(p_stock),儲位(p_locat),批號(p_lot)
#       : 單據單位(p_ounit),庫存單位(p_sunit),轉換率(p_fac)
#       : 單據數量(p_oqty),歸屬單號(p_bno),功能形態(p_act),屬性(p_att)
FUNCTION s_mod_lot(p_type,p_no,p_sn,p_seq,p_item,p_stock,p_locat,p_lot,p_ounit,p_sunit,p_fac,p_oqty,p_bno,p_act,p_att)
#公用代码段
   DEFINE p_row,p_col     LIKE type_file.num5 
   DEFINE p_type          LIKE rvbs_file.rvbs00, 
          p_no            LIKE rvbs_file.rvbs01, 
          p_sn            LIKE rvbs_file.rvbs01, 
          p_seq           LIKE rvbs_file.rvbs13,     
          p_item          LIKE rvbs_file.rvbs021, 
          p_stock         LIKE imgs_file.imgs02, 
          p_locat         LIKE imgs_file.imgs03, 
          p_lot           LIKE imgs_file.imgs04, 
          p_ounit         LIKE img_file.img09,
          p_sunit         LIKE img_file.img09, 
          p_fac           LIKE img_file.img34,  
          p_oqty          LIKE rvbs_file.rvbs06,
          p_bno           LIKE rvbs_file.rvbs08,
          p_act           LIKE type_file.chr3,
          p_att           LIKE rvbs_file.rvbs09, 
          p_sql           LIKE type_file.num5 
   DEFINE ls_tmp STRING                                                   
   DEFINE l_sfp06     LIKE sfp_file.sfp06
                                       
   IF p_type = 'asfi510' THEN                                                    
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                     
      WHERE sfp01 = p_no                                      
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                       
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                       
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                       
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF          
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF   #FUN-C70014 add
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
 
  
   IF p_no IS NULL THEN RETURN "N",0 END IF 
  
   LET g_argv1 = p_type 
   LET g_argv2 = p_no 
   LET g_argv3 = p_sn  
   LET g_argv4 = p_seq 
   LET g_argv5 = p_item 
   LET g_argv6 = p_stock 
   LET g_argv7 = p_locat 
   LET g_argv8 = p_lot  
   LET g_argv9 = p_ounit   
   LET g_argv10 = p_sunit 
   LET g_argv11 = p_fac 
   LET g_argv12 = p_oqty
   LET g_argv13 = p_act  
   LET g_argv14 = p_bno 
   LET g_argv15 = p_att
   LET g_barcode = "N" 
  
   WHENEVER ERROR CALL cl_err_msg_log 
  
   LET p_row = 2 LET p_col = 4 
 
   OPEN WINDOW s_mod_lot_w AT p_row,p_col WITH FORM "sub/42f/s_mod_lot" 
     ATTRIBUTE( STYLE = g_win_style ) 
   CALL cl_ui_locale("s_mod_lot") 
  
   CALL g_rvbs.clear() 
  
   LET l_i = "N" 
   LET n_qty = 0

   #欄位的隱藏
   CALL s_mod_lot_refresh_detail()
   IF (g_prog = "apmt110" OR g_prog = "apmt200") AND p_att = '1' THEN
      CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",TRUE)
   ELSE 
      CALL cl_set_comp_visible("rvbs10,rvbs11,rvbs12",FALSE)
   END IF

   IF p_att = '1' THEN
      CALL cl_set_act_visible("gen_data",FALSE)
      CALL cl_set_comp_visible("sel,imgs08,lqty",FALSE)
      CALL s_mod_lot_show()
      CALL s_mod_lot_b()
   END IF 
   
   IF p_att = '-1'  THEN
      CALL cl_set_comp_visible("sel,imgs08,lqty",TRUE) 
      IF (g_argv13 = "QRY" OR g_argv13= 'SEL') THEN 
          CALL cl_set_comp_visible("sel,imgs08",FALSE) 
          CALL s_mod_lot_show() 
      ELSE 
         SELECT COUNT(*) INTO l_n FROM rvbs_file 
          WHERE rvbs00 = g_argv1 
            AND rvbs01 = g_argv2 
            AND rvbs02 = g_argv3 
            AND rvbs13 = g_argv4 
            AND rvbs09 = g_argv15 
         IF l_n = 0 THEN 
            CALL cl_set_comp_visible("rvbs022",FALSE) 
            CALL s_mod_lot_gen() 
         ELSE 
            CALL cl_set_comp_visible("imgs08,rvbs022",FALSE) 
            CALL s_mod_lot_show() 
         END IF 
      END IF
      IF g_argv13='SEL'THEN           
         CALL s_mod_lot_b() 
      END IF
      IF g_argv13='MOD' THEN
         CALL cl_set_act_visible("gen_data",TRUE)
      END IF
   END IF 
   CALL s_mod_lot_menu() 
  
   CLOSE WINDOW s_mod_lot_w 
    
   RETURN l_i,n_qty    
END FUNCTION

FUNCTION s_mod_lot_menu() 
  
   WHILE TRUE 
      CALL s_mod_lot_bp("G") 
      CASE g_action_choice 
         WHEN "detail" 
            CALL s_mod_lot_b() 
         WHEN "help" 
            CALL cl_show_help() 
         WHEN "exit" 
            LET INT_FLAG = 0 
            EXIT WHILE 
         WHEN "controlg" 
            CALL cl_cmdask() 
         WHEN "gen_data" 
            CALL s_mod_lot_gen() 
      END CASE 
   END WHILE 
  
END FUNCTION

FUNCTION s_mod_lot_show() 
  
   LET g_rvbs00  = g_argv1 
   LET g_rvbs01  = g_argv2 
   LET g_rvbs02  = g_argv3 
   LET g_rvbs13  = g_argv4  
   LET g_rvbs021 = g_argv5 
   LET g_ounit   = g_argv9
   LET g_sunit   = g_argv10  
   LET g_fac     = g_argv11 
   LET g_oqty    = g_argv12    
   LET g_sqty    = g_oqty * g_fac 

   IF g_argv15 = '-1' THEN
      LET g_lqty = 0
      SELECT SUM(rvbs06) INTO g_lqty 
        FROM rvbs_file
       WHERE rvbs00 = g_rvbs00
         AND rvbs01 = g_rvbs01
         AND rvbs02 = g_rvbs02
         AND rvbs13 = g_rvbs13
         AND rvbs09 = g_argv15
      IF cl_null(g_lqty) THEN
         LET g_lqty = 0
      END IF
      DISPLAY g_lqty TO FORMONLY.lqty
   END IF 
   DISPLAY g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs021,g_ounit,g_sunit,g_fac,g_oqty,g_sqty 
        TO rvbs01,rvbs02,rvbs13,rvbs021,FORMONLY.ounit,FORMONLY.sunit,FORMONLY.fac,FORMONLY.oqty,FORMONLY.sqty
   
  
   SELECT ima02,ima021,ima918,ima919,ima921,ima922,ima924
     INTO g_ima02,g_ima021,g_ima918,g_ima919,g_ima921,g_ima922,g_ima924
     FROM ima_file
    WHERE ima01 = g_rvbs021 
  
   DISPLAY g_ima02,g_ima021 TO ima02,ima021 
  
   CALL s_mod_lot_b_fill() 
  
END FUNCTION 

FUNCTION s_mod_lot_b_fill() 
DEFINE l_sfp06     LIKE sfp_file.sfp06   
DEFINE l_rvbs00    LIKE rvbs_file.rvbs00
DEFINE l_j         LIKE type_file.num5
DEFINE l_inj04     LIKE inj_file.inj04 
#TQC-C20344 ----- add ----- begin
DEFINE lr_con     DYNAMIC ARRAY OF RECORD
          ini03   LIKE ini_file.ini03,
          oeba04  LIKE oeba_file.oeba04,
          oeba05  LIKE oeba_file.oeba05,
          oeba06  LIKE oeba_file.oeba06,
          oeba07  LIKE oeba_file.oeba07  #FUN-CC0006 add
END RECORD
DEFINE l_ogb31    LIKE ogb_file.ogb31,
       l_ogb32    LIKE ogb_file.ogb32
DEFINE l_con      LIKE type_file.num5,
       l_char     LIKE inj_file.inj04,
       l_num      LIKE type_file.num10
DEFINE l_con_cnt  LIKE type_file.num5
DEFINE ls_sql     STRING
#TQC-C20344 ----- add ----- end

  IF g_prog = 'asfi510' THEN  
     SELECT sfp06 INTO l_sfp06 FROM sfp_file 
      WHERE sfp01 = g_rvbs01 
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF  
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF  
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF  
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF                  
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF   #FUN-C70014 add
     LET l_rvbs00 = 'asfi510' 
  ELSE 
     IF g_prog = 'asfi511' OR g_prog = 'asfi512' OR 
        g_prog = 'asfi513' OR g_prog = 'asfi514' OR g_prog = 'asfi519' THEN  #FUN-C70014 add g_prog = 'asfi519'
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

#TQC-C20344 ----- add ----- begin
   #判斷是否需要作條件篩選
   LET l_con = 0
   IF g_prog = 'axmt610' OR g_prog = 'axmt620' THEN
      SELECT ogb31,ogb32 INTO l_ogb31,l_ogb32 FROM ogb_file
       WHERE ogb01 = g_rvbs01 AND ogb03 = g_rvbs02
      SELECT l_ima928,l_ima929 FROM ima_file WHERE ima01 = g_rvbs021
      SELECT COUNT(*) INTO l_con FROM oeba_file,imac_file
       WHERE oeba01= l_ogb31 AND oeba02 = l_ogb32 AND imac01 = g_rvbs021
         AND oeba04 = imac04 AND imac03='2'
         AND (oeba05 IS NOT null OR oeba06 IS NOT null)

      LET ls_sql =" SELECT ini03,oeba04,oeba05,oeba06,oeba07 " , #FUN-CC0006 add oeba07
                  "   FROM oeba_file,imac_file,ini_file",
                  "  WHERE oeba01 = '",l_ogb31 ,"'",
                  "    AND oeba02 = '",l_ogb32,"'",
                  "    AND imac01 = '",g_rvbs021,"'",
                  "    AND oeba04 = imac04 AND imac03='2'",
                  "    AND (oeba05 IS NOT null OR oeba06 IS NOT null)",
                  "    AND ini01  = oeba04"
      PREPARE con_pre_1 FROM ls_sql
      DECLARE con_cs_1 CURSOR FOR con_pre_1
      LET l_con_cnt = 1
      IF l_con <> 0 THEN
         FOREACH con_cs_1 INTO lr_con[l_con_cnt].*
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_con_cnt = l_con_cnt + 1
         END FOREACH
         CALL lr_con.deleteElement(l_con_cnt)
         LET  l_con_cnt = l_con_cnt - 1
      END IF
   END IF
#TQC-C20344 ----- add ----- end
  
   DECLARE rvbs_curs CURSOR FOR 
           SELECT rvbs022,'Y',rvbs03,rvbs04,rvbs05,0,rvbs07,rvbs08,rvbs06, 
                  rvbs10,rvbs11,rvbs12,'','','','','','','','','',''
             FROM rvbs_file 
            WHERE rvbs00 = g_rvbs00                                
              AND rvbs01 = g_rvbs01 
              AND rvbs02 = g_rvbs02 
              AND rvbs13 = g_rvbs13   
              AND rvbs09 = g_argv15 
            ORDER BY rvbs022 
  
   CALL g_rvbs.clear() 
  
   LET g_cnt = 1 
  
   FOREACH rvbs_curs INTO g_rvbs[g_cnt].*              #單身 ARRAY 填充 
      IF STATUS THEN  
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF 
#TQC-C20344 ----- add ----- begin
      #篩選製造批號層級資料
      IF l_con <> 0 THEN
         FOR l_j=1 TO l_con
            IF lr_con[l_j].ini03 = '1' THEN
               SELECT inj04 INTO l_char FROM inj_file
                WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
                  AND inj03 = lr_con[l_j].oeba04
               IF l_char <> lr_con[l_j].oeba05 THEN
                  CONTINUE FOREACH
               END IF
            END IF

            IF lr_con[l_j].ini03 = '2' THEN
               SELECT to_number(inj04) INTO l_num FROM inj_file
                WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
                  AND inj03 = lr_con[l_j].oeba04
              #FUN-CC0006---mark---START
              #IF l_num < lr_con[l_j].oeba05 OR l_num > lr_con[l_j].oeba06 THEN
              #   CONTINUE FOREACH
              #END IF
              #FUN-CC0006---mark---END
              #FUN-CC0006---add---START 
               CASE lr_con[l_j].oeba07
                  WHEN 1  #大於
                     IF l_num <= lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 2  #大於等於
                     IF l_num < lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 3  #等於
                     IF l_num <> lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 4  #小於
                     IF l_num >= lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 5  #小於等於
                     IF l_num > lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 6  #區間
                     IF l_num < lr_con[l_j].oeba05 OR l_num > lr_con[l_j].oeba06 THEN
                        CONTINUE FOREACH
                     END IF
               END CASE
              #FUN-CC0006---add-----END
            END IF
         END FOR
      END IF
#TQC-C20344 ----- add ----- end
  
      SELECT imgs08 INTO g_rvbs[g_cnt].imgs08 
        FROM imgs_file 
       WHERE imgs01 = g_rvbs021 
         AND imgs02 = g_argv6 
         AND imgs03 = g_argv7 
         AND imgs04 = g_argv8 
         AND imgs05 = g_rvbs[g_cnt].rvbs03 
         AND imgs06 = g_rvbs[g_cnt].rvbs04 
         #抓取特性資料

         FOR l_j = 1 TO g_imac.getLength()
            LET l_inj04 = NULL
            SELECT inj04 INTO l_inj04 FROM inj_file
             WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
               AND inj03 = g_imac[l_j].imac04               
            CASE l_j
               WHEN 1
                  LET g_rvbs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET g_rvbs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET g_rvbs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET g_rvbs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET g_rvbs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET g_rvbs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET g_rvbs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET g_rvbs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET g_rvbs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET g_rvbs[g_cnt].att10 = l_inj04
            END CASE
         END FOR  
      IF cl_null(g_rvbs[g_cnt].imgs08) THEN 
         LET g_rvbs[g_cnt].imgs08 = 0 
      END IF 
      LET g_cnt = g_cnt + 1   
   END FOREACH   
   CALL g_rvbs.deleteElement(g_cnt)   
   LET g_rec_b= g_cnt-1 
   CALL s_mod_lot_refresh_detail()
END FUNCTION

FUNCTION s_mod_lot_bp(p_ud) 
   DEFINE p_ud   LIKE type_file.chr1
  
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN 
      RETURN 
   END IF 
  
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE) 
   DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b) 
#TQC-C20305 ----- add ----- begin
      BEFORE DISPLAY
         IF g_argv15 = '1' THEN
            CALL cl_set_act_visible("gen_data",FALSE)
         END IF
#TQC-C20305 ----- add ----- end  
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

FUNCTION s_mod_lot_b() 
   DEFINE l_ac_t          LIKE type_file.num5, 
          l_row,l_col     LIKE type_file.num5, 
          l_n,l_cnt       LIKE type_file.num5,
          l_j             LIKE type_file.num5, 
          p_cmd           LIKE type_file.chr1, 
          l_lock_sw       LIKE type_file.chr1, 
          l_allow_insert  LIKE type_file.chr1, 
          l_allow_delete  LIKE type_file.chr1 
   DEFINE l_desc       LIKE ima_file.ima02 
   DEFINE l_ima920     LIKE ima_file.ima920
   DEFINE l_ima923     LIKE ima_file.ima923
   DEFINE l_inj04      LIKE inj_file.inj04
   DEFINE l_n2         LIKE type_file.num5   #MOD-CB0031 add
   DEFINE l_flag       LIKE type_file.chr1   #MOD-CB0031 add
   DEFINE l_flag1       LIKE type_file.chr1   #CHI-C50022 add
   DEFINE l_ima24      LIKE ima_file.ima24    #CHI-C50022 add

   LET g_action_choice = "" 
  
   IF g_rvbs01 IS NULL THEN RETURN END IF 
  
   IF g_argv13 = "QRY" THEN 
      RETURN 
   END IF
   IF g_argv15 = '-1' THEN
      IF g_argv13 <> 'SEL' THEN
         CALL cl_set_comp_visible("sel,imgs08",TRUE) 
      ELSE 
         CALL cl_set_comp_visible("sel,imgs08",FALSE) 
      END IF
   END IF 

   IF g_argv13 = 'SEL' THEN 
      CALL cl_set_comp_entry("rvbs022",FALSE)
   ELSE
      CALL cl_set_comp_entry("rvbs022",TRUE)
   END IF 
   
   IF g_argv13 = "MOD" AND g_argv15 = '-1' THEN
      CALL cl_set_act_visible("gen_data",TRUE) 
   END IF  

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   IF g_argv15 = '-1' THEN
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   END IF
   
   IF g_argv13 = 'SEL' OR g_argv13 = 'IQC' THEN 
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   END IF
   
   CALL cl_opmsg('b')
   IF g_argv15 = '1' THEN
      CALL cl_set_comp_entry("rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",TRUE)
   END IF 
   IF g_argv15 = '-1' THEN
      CALL cl_set_comp_entry("rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE)
   END IF 
   IF g_argv15 = '1' THEN 
      LET g_forupd_sql = "SELECT rvbs022,'Y',rvbs03,rvbs04,rvbs05,0,rvbs07,",
                         "       rvbs08,rvbs06,rvbs10,rvbs11,rvbs12,'','',''",
                         "       ,'','','','','','',''",
                         "   FROM rvbs_file ",
                         "  WHERE rvbs00 = ? ",
                         "    AND rvbs01 = ? ",
                         "    AND rvbs02 = ? ",
                         "    AND rvbs13 = ? ",  
                         "    AND rvbs022 = ? ",
                         "    AND rvbs09 = ? ",
                         "    FOR UPDATE "
 
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE s_mod_lot_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
   END IF
   
   LET l_ac_t = 0 
  
   LET g_cnt_1 = 0    
          
   INPUT ARRAY g_rvbs WITHOUT DEFAULTS FROM s_rvbs.* 
       ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,                                            #CHI-910018 Mark 
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,             #CHI-910018 
                 APPEND ROW=l_allow_insert)                                       #CHI-910018 
  
      BEFORE INPUT 
         IF g_rec_b != 0 THEN 
            CALL fgl_set_arr_curr(l_ac) 
         END IF 
         IF g_argv15 = '1' THEN
            CALL cl_set_act_visible("barcode,barcode_cancel",TRUE)
            CALL cl_set_act_visible("gen_data",FALSE)
         ELSE
           CALL cl_set_act_visible("barcode,barcode_cancel",FALSE)
           CALL cl_set_act_visible("gen_data",TRUE)
         END IF
  
      BEFORE ROW 
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success='Y'
         IF g_argv1[1,7] != 'axmt629' THEN #MOD-C60216 
            BEGIN WORK
         END IF 
         CASE g_argv15
            WHEN '-1'
               IF g_rec_b>=l_ac THEN
                  LET p_cmd='u'
                  LET g_rvbs_t.* = g_rvbs[l_ac].*
                  LET g_before_input_done = FALSE
                  CALL s_mod_lot_set_entry_b(p_cmd) 
                  CALL s_mod_lot_set_no_entry_b(p_cmd) 
                  CALL s_mod_lot_set_no_required()                                           #CHI-910023	  
                  CALL s_mod_lot_set_required()              
                  LET g_before_input_done = TRUE
               END IF
            WHEN '1'
               IF g_rec_b>=l_ac THEN
                  LET p_cmd='u'
                  LET g_rvbs_t.* = g_rvbs[l_ac].*
                  OPEN s_mod_lot_bcl USING g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs_t.rvbs022,g_argv15
                  IF STATUS THEN
                     CALL cl_err("OPEN s_mod_lot_bcl:", STATUS, 1)
                     CLOSE s_mod_lot_bcl
                     RETURN
                  ELSE
                     FETCH s_mod_lot_bcl INTO g_rvbs[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('lock rvbs',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                     LET g_rvbs[l_ac].* = g_rvbs_t.* #修改bug點擊一行特性值丟失
                  END IF
                  LET g_before_input_done = FALSE
                  CALL s_mod_lot_set_entry_b(p_cmd)
                  CALL s_mod_lot_set_no_entry_b(p_cmd)
                  CALL s_mod_lot_set_no_required()
                  CALL s_mod_lot_set_required()
                  LET g_before_input_done = TRUE
                  CALL cl_show_fld_cont()   
               END IF
         END CASE
         
      BEFORE INSERT
         LET p_cmd = 'a'
         LET g_before_input_done = FALSE
         CALL s_mod_lot_set_entry_b(p_cmd)
         CALL s_mod_lot_set_no_entry_b(p_cmd)
         CALL s_mod_lot_set_no_required()
         CALL s_mod_lot_set_required()
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
                  AND rvbs13 = g_rvbs13   
               LET g_rvbs[l_ac].rvbs07 = g_rvbs[l_ac-1].rvbs07
               LET g_rvbs[l_ac].rvbs08 = g_rvbs[l_ac-1].rvbs08
            END IF
         END IF
         CALL cl_show_fld_cont()
         NEXT FIELD rvbs022

      AFTER INSERT
         CASE g_argv15
            WHEN 1
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
 
                IF cl_null(g_rvbs[l_ac].rvbs10) THEN
                   LET g_rvbs[l_ac].rvbs10 = 0
                END IF
 
                IF cl_null(g_rvbs[l_ac].rvbs11) THEN
                   LET g_rvbs[l_ac].rvbs11 = 0
                END IF
 
                IF cl_null(g_rvbs[l_ac].rvbs12) THEN
                   LET g_rvbs[l_ac].rvbs12 = 0
                END IF
 
                IF NOT cl_null(g_argv14) THEN
                   LET g_rvbs[l_ac].rvbs07 = '3'
                   LET g_rvbs[l_ac].rvbs08 = g_argv14
                END IF
                INSERT INTO rvbs_file(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,
                                      rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,
                                      rvbs10,rvbs11,rvbs12,rvbs13,   
                                      rvbsplant,rvbslegal)
                VALUES(g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs021,
                       g_rvbs[l_ac].rvbs022,
                       g_rvbs[l_ac].rvbs03,g_rvbs[l_ac].rvbs04,
                       g_rvbs[l_ac].rvbs05,g_rvbs[l_ac].rvbs06,
                       g_rvbs[l_ac].rvbs07,g_rvbs[l_ac].rvbs08,g_argv15,
                       g_rvbs[l_ac].rvbs10,g_rvbs[l_ac].rvbs11,
                       g_rvbs[l_ac].rvbs12,g_rvbs13,
                       g_plant,g_legal)      
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
              WHEN '-1'
                 LET g_cnt_1 = g_cnt_1 + 1 
         END CASE 
         #寫數據至inj_file
         CALL s_mod_lot_ins_inj(l_ac)

      BEFORE FIELD rvbs022
         IF g_argv15 = '1' THEN #default 行序
            IF cl_null(g_rvbs[l_ac].rvbs022) OR g_rvbs[l_ac].rvbs022=0 THEN
               SELECT MAX(rvbs022) + 1
                 INTO g_rvbs[l_ac].rvbs022
                 FROM rvbs_file
                WHERE rvbs00 = g_rvbs00
                  AND rvbs01 = g_rvbs01
                  AND rvbs02 = g_rvbs02
                  AND rvbs13 = g_rvbs13   
                  AND rvbs09 = g_argv15
               IF g_rvbs[l_ac].rvbs022 IS NULL THEN
                  LET g_rvbs[l_ac].rvbs022 = 1
               END IF
            END IF
         END IF 
 
      AFTER FIELD rvbs022          #check是否重複
         IF g_argv15 = '1' THEN 
            IF NOT cl_null(g_rvbs[l_ac].rvbs022) THEN
#TQC-C40031 ------ add ------ begin
               IF g_rvbs[l_ac].rvbs022 <= 0 THEN
                  CALL cl_err('','aec-994',0)
                  LET g_rvbs[l_ac].rvbs022 = g_rvbs_t.rvbs022
                  NEXT FIELD rvbs022
               END IF
#TQC-C40031 ------ add ------ end
               IF g_rvbs[l_ac].rvbs022 != g_rvbs_t.rvbs022 OR
                  g_rvbs_t.rvbs022 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt
                    FROM rvbs_file
                   WHERE rvbs00  = g_rvbs00
                     AND rvbs01  = g_rvbs01
                     AND rvbs02  = g_rvbs02
                     AND rvbs13  = g_rvbs13   
                     AND rvbs022 = g_rvbs[l_ac].rvbs022
                     AND rvbs09  = g_argv15
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0) 
                     NEXT FIELD rvbs022
                  END IF
               END IF
            END IF
         END IF 
 
      BEFORE FIELD rvbs03
         IF g_ima922 = "Y" THEN
            SELECT ima923 INTO l_ima923 FROM ima_file  
             WHERE ima01 = g_rvbs021
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
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM rvbs_file
                   WHERE rvbs03 = g_rvbs[l_ac].rvbs03
                     AND NOT (rvbs00 = g_rvbs00
                     AND rvbs01 = g_rvbs01
                     AND rvbs02 = g_rvbs02
                     AND rvbs13 = g_rvbs13
                     AND rvbs09 = g_argv15
                     AND rvbs022 = g_rvbs[l_ac].rvbs022) 
                  #MOD-CB0031---add---S
                 #入庫且為重工工單，則不控卡
                  LET l_n2 =0  LET l_flag='N'
                  IF g_sfb_wo_f = 'Y' THEN
                     IF g_prog = 'asft620' THEN    #MOD-CC0047 add
                        SELECT COUNT(*) INTO l_n2 FROM sfb_file
                         WHERE sfb01 = g_sfb_wo
                           AND sfb02 = '5'
                        IF l_n2 > 0 THEN LET l_flag = 'Y' END IF
                    #MOD-CC0047---add---S
                    #重工委外工單也不控卡
                     ELSE
                        IF g_prog = 'apmt730' OR g_prog = 'apmt200' THEN
                           SELECT COUNT(*) INTO l_n2 FROM sfb_file
                            WHERE sfb01 = g_sfb_wo
                              AND sfb02 = '8'
                           IF l_n2 > 0 THEN LET l_flag = 'Y' END IF
                        END IF
                     END IF
                    #MOD-CC0047---add---E
                  END IF
                 #MOD-CB0031---add---E
                  IF (g_prog = 'asft620' OR g_prog = 'apmt730' OR g_prog = 'apmt200')   #MOD-CC0047 add apmt730,apmt200
                      AND l_flag = 'Y' THEN                      #MOD-CB0031 add
                  ELSE                                           #MOD-CB0031 add
                     IF l_n > 0 THEN
                        CALL cl_err(g_rvbs[l_ac].rvbs03,"axm-396",1)
                        NEXT FIELD rvbs03
                     END IF
                  END IF     #MOD-CB0031 add
               END IF
            END IF
         END IF
 
      BEFORE FIELD rvbs04
         IF g_ima919 = "Y" AND g_argv15 = '1' THEN
               SELECT ima920 INTO l_ima920 FROM ima_file
             WHERE ima01 = g_rvbs021
            CALL s_auno(l_ima920,"5",g_rvbs021) RETURNING g_rvbs[l_ac].rvbs04,l_desc 
            DISPLAY BY NAME g_rvbs[l_ac].rvbs04
         END IF
 
      AFTER FIELD rvbs04
         IF g_ima918 = "Y" AND g_argv15 = '1'  THEN
            IF cl_null(g_rvbs[l_ac].rvbs04) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs04,"asf-597",1)
               NEXT FIELD rvbs04
            END IF
         END IF

         

#TQC-C20312 ----- add ----- begin
         SELECT COUNT(*) INTO l_n FROM inj_file 
          WHERE inj01 = g_rvbs021
            AND inj02 = g_rvbs[l_ac].rvbs04
         IF p_cmd = 'u' AND l_n = 0 THEN 
            CALL cl_err(g_rvbs[l_ac].rvbs04,'asf1026',0)
            LET g_rvbs[l_ac].rvbs04 = g_rvbs_t.rvbs04
            NEXT FIELD rvbs04
         END IF
#TQC-C20312 ----- add ----- end
         #抓取特性資料

         FOR l_j = 1 TO g_imac.getLength()
           LET l_inj04 = NULL
            SELECT inj04 INTO l_inj04 FROM inj_file
             WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[l_ac].rvbs04
               AND inj03 = g_imac[l_j].imac04               
            CASE l_j
               WHEN 1
                  LET g_rvbs[l_ac].att01 = l_inj04
               WHEN 2
                  LET g_rvbs[l_ac].att02 = l_inj04
               WHEN 3
                  LET g_rvbs[l_ac].att03 = l_inj04
               WHEN 4
                  LET g_rvbs[l_ac].att04 = l_inj04
               WHEN 5
                  LET g_rvbs[l_ac].att05 = l_inj04
               WHEN 6
                  LET g_rvbs[l_ac].att06 = l_inj04
               WHEN 7
                  LET g_rvbs[l_ac].att07 = l_inj04
               WHEN 8
                  LET g_rvbs[l_ac].att08 = l_inj04
               WHEN 9
                  LET g_rvbs[l_ac].att09 = l_inj04
               WHEN 10
                  LET g_rvbs[l_ac].att10 = l_inj04
            END CASE
         END FOR
         CALL s_mod_lot_set_entry_b(p_cmd)
         CALL s_mod_lot_set_no_entry_b(p_cmd)


 
         
      BEFORE FIELD rvbs07
         CALL s_mod_lot_set_entry_b(p_cmd)
         CALL s_mod_lot_set_no_required()
 
      AFTER FIELD rvbs07
          IF g_argv15 = '1' THEN 
             CALL s_mod_lot_set_no_entry_b(p_cmd)
             CALL s_mod_lot_set_required()
          END IF 

      AFTER FIELD rvbs08
         IF NOT cl_null(g_rvbs[l_ac].rvbs07) THEN
            IF cl_null(g_rvbs[l_ac].rvbs08) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs08,"asf-597",1)
               NEXT FIELD rvbs08
            END IF
            CALL s_mod_lot_rvbs08() 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rvbs[l_ac].rvbs08,g_errno,1)
               NEXT FIELD rvbs08
            END IF
         END IF
 
      BEFORE DELETE         
         IF g_rvbs_t.rvbs022 > 0 AND g_rvbs_t.rvbs022 IS NOT NULL 
            AND g_argv15 = '1' THEN
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

#CHI-C30062---add---START
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM rvbs_file
              WHERE rvbs021 = g_rvbs021
                AND rvbs04  = g_rvbs_t.rvbs04
                AND rvbs01 <> g_rvbs01
            IF l_cnt = 0 THEN  #該製造批號不存在其他單據中
               SELECT count(*) INTO l_cnt FROM rvbs_file
                 WHERE rvbs021 = g_rvbs021
                   AND rvbs04  = g_rvbs_t.rvbs04
                   AND rvbs01  = g_rvbs01
              IF l_cnt = 1 THEN #該單據存在單身只有一筆
                 DELETE FROM inj_file
                  WHERE inj01  = g_rvbs021
                    AND inj02  = g_rvbs_t.rvbs04
                 IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL cl_err('del inj_file',SQLCA.sqlcode,1)
                     CANCEL DELETE
                 END IF
              END IF
            END IF
#CHI-C30062---add-----END

            DELETE FROM rvbs_file
             WHERE rvbs00  = g_rvbs00
               AND rvbs01  = g_rvbs01
               AND rvbs02  = g_rvbs02
               AND rvbs13  = g_rvbs13   
               AND rvbs022 = g_rvbs_t.rvbs022
               AND rvbs09  = g_argv15
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
                                                                   
                         
          
      BEFORE FIELD sel 
         CALL s_mod_lot_set_entry_b(p_cmd)        
  
      ON CHANGE sel 
         IF g_argv13 = "MOD" THEN  
            IF g_rvbs[l_ac].sel = "Y" THEN 
               LET g_rvbs[l_ac].rvbs06 = g_rvbs[l_ac].imgs08 
            ELSE 
               LET g_rvbs[l_ac].rvbs06 = 0 
            END IF 
         END IF 
         CALL s_mod_lot_lqty()
  
      AFTER FIELD sel 
         CALL s_mod_lot_set_no_entry_b(p_cmd) 
  
      AFTER FIELD rvbs06 
         IF g_argv13 = "MOD"  AND g_argv15 = '-1' THEN 
            IF g_rvbs[l_ac].rvbs06 > g_rvbs[l_ac].imgs08 THEN  
               CALL cl_err(g_rvbs[l_ac].rvbs06,"axm-280",1) 
               NEXT FIELD rvbs06 
            END IF 
         END IF 
         #CHI-CB0056 add begin---------------
         IF NOT s_mod_lot_check_rvbs06() THEN 
            NEXT FIELD rvbs06
         END IF 
         #CHI-CB0056 add end-----------------
     #CHI-C50022 str add-----
         SELECT ima24 INTO l_ima24 FROM ima_file WHERE ima01=g_rvbs021 
         IF l_ima24 = 'Y' THEN
            CALL s_showmsg_init()
            CALL s_mod_lot_chkrvbs(g_rvbs[l_ac].rvbs03,g_rvbs[l_ac].rvbs04,g_rvbs[l_ac].rvbs06)
                 RETURNING l_flag1
            CALL s_showmsg()
            IF l_flag1 = 'N' THEN NEXT FIELD rvbs06 END IF
         END IF   
     #CHI-C50022 end add-----  
          
#att01~att10一旦進入就不能忽略
      AFTER FIELD att01
         IF cl_null(g_rvbs[l_ac].att01) THEN
            NEXT FIELD att01
         END IF

      AFTER FIELD att02
         IF cl_null(g_rvbs[l_ac].att02) THEN
            NEXT FIELD att02
         END IF

      AFTER FIELD att03
         IF cl_null(g_rvbs[l_ac].att03) THEN
            NEXT FIELD att03
         END IF

      AFTER FIELD att04
         IF cl_null(g_rvbs[l_ac].att04) THEN
            NEXT FIELD att04
         END IF

      AFTER FIELD att05
         IF cl_null(g_rvbs[l_ac].att05) THEN
            NEXT FIELD att05
         END IF

      AFTER FIELD att06
         IF cl_null(g_rvbs[l_ac].att06) THEN
            NEXT FIELD att06
         END IF

      AFTER FIELD att07
         IF cl_null(g_rvbs[l_ac].att07) THEN
            NEXT FIELD att07
         END IF

      AFTER FIELD att08
         IF cl_null(g_rvbs[l_ac].att08) THEN
            NEXT FIELD att08
         END IF

      AFTER FIELD att09
         IF cl_null(g_rvbs[l_ac].att09) THEN
            NEXT FIELD att09
         END IF

      AFTER FIELD att10
         IF cl_null(g_rvbs[l_ac].att10) THEN
            NEXT FIELD att10
         END IF
  
      AFTER ROW         
         IF INT_FLAG THEN
            IF g_argv15 = '1' THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','','',9001,0)
               ELSE
                  CALL cl_err('',9001,0)
               END IF
               IF p_cmd='u' THEN
                  LET g_rvbs[l_ac].* = g_rvbs_t.*
               END IF
               CLOSE s_mod_lot_bcl
            END IF
            LET INT_FLAG = 0   
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_argv15 = '-1' THEN 
            CALL s_mod_lot_lqty()
         END IF 
         
         CLOSE s_mod_lot_bcl
         IF g_argv1[1,7] != 'axmt629' THEN #MOD-C60216
            COMMIT WORK
         END IF                              
  
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入 
         IF INT_FLAG THEN 
            LET INT_FLAG = 0    
            EXIT INPUT   
         END IF 
  

      ON ROW CHANGE
         CASE g_argv15
            WHEN '-1'
               IF g_argv13 = 'SEL' THEN 
                  LET g_rvbs[l_ac].sel='Y'  
               END IF
            WHEN '1'
               IF INT_FLAG THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','',9001,0)
                  ELSE
                     CALL cl_err('',9001,0)
                  END IF 
                  LET INT_FLAG = 0
                  LET g_rvbs[l_ac].* = g_rvbs_t.*
                  CLOSE s_mod_lot_bcl
                  EXIT INPUT
               END IF

               #CHI-CB0056 add begin---------------
               IF NOT s_mod_lot_check_rvbs06() THEN 
                  NEXT FIELD rvbs06
               END IF 
               #CHI-CB0056 add end-----------------
 
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
 
                  IF cl_null(g_rvbs[l_ac].rvbs10) THEN
                     LET g_rvbs[l_ac].rvbs10 = 0
                  END IF
            
                  IF cl_null(g_rvbs[l_ac].rvbs11) THEN
                     LET g_rvbs[l_ac].rvbs11 = 0
                  END IF
            
                  IF cl_null(g_rvbs[l_ac].rvbs12) THEN
                     LET g_rvbs[l_ac].rvbs12 = 0
                  END IF

                  IF g_argv13 = "IQC" THEN
                     UPDATE rvbs_file
                        SET rvbs022= g_rvbs[l_ac].rvbs022,
                            rvbs03 = g_rvbs[l_ac].rvbs03,
                            rvbs04 = g_rvbs[l_ac].rvbs04,
                            rvbs05 = g_rvbs[l_ac].rvbs05,
                            rvbs06 = g_rvbs[l_ac].rvbs06,   
                            rvbs07 = g_rvbs[l_ac].rvbs07,
                            rvbs08 = g_rvbs[l_ac].rvbs08,
                            rvbs10 = g_rvbs[l_ac].rvbs06,
                            rvbs11 = g_rvbs[l_ac].rvbs11,
                            rvbs12 = g_rvbs[l_ac].rvbs12
                      WHERE rvbs00 = g_rvbs00
                        AND rvbs01 = g_rvbs01
                        AND rvbs02 = g_rvbs02
                        AND rvbs13 = g_rvbs13   
                        AND rvbs022= g_rvbs_t.rvbs022
                        AND rvbs09 = g_argv15
                  ELSE
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
                        AND rvbs13 = g_rvbs13  
                        AND rvbs022= g_rvbs_t.rvbs022
                        AND rvbs09 = g_argv15
                  END IF       
 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('upd rvbs',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF
 
                  IF g_success='Y' THEN
                     MESSAGE 'UPDATE O.K'
                  END IF
 
               END IF    
         END CASE
         #更新inj_file
         CALL s_mod_lot_upd_inj()  
  
      ON ACTION gen_data 
         CALL s_mod_lot_gen() 

      ON ACTION barcode
         IF g_barcode = "N" THEN
            LET g_barcode="Y"
            CALL s_mod_lot_set_no_entry_b(p_cmd)
            CALL cl_set_act_visible("barcode",FALSE)
            CALL cl_set_act_visible("barcode_cancel",TRUE)
         END IF
 
      ON ACTION barcode_cancel
         IF g_barcode = "Y" THEN
            LET g_barcode="N"
            CALL s_mod_lot_set_entry_b(p_cmd)
            CALL cl_set_act_visible("barcode",TRUE)
            CALL cl_set_act_visible("barcode_cancel",FALSE)
         END IF
 
      ON ACTION controlo
         IF INFIELD(rvbs022) AND l_ac > 1 AND g_argv15 = '1' THEN
            LET g_rvbs[l_ac].* = g_rvbs[l_ac-1].*
            LET g_rvbs[l_ac].rvbs022 = NULL
            NEXT FIELD rvbs022
         END IF
         
      ON ACTION controlg 
         CALL cl_cmdask() 
  
      ON ACTION CONTROLR 
         CALL cl_show_req_fields() 
  
      ON ACTION controlf 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
  
      ON IDLE g_idle_seconds 
         CALL cl_on_idle() 
         CONTINUE INPUT 
  
      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO")  
  
   END INPUT 
   CASE g_argv15
      WHEN '1'  
      
         FOR l_j =1 TO g_rec_b
            IF g_argv13 = "IQC" THEN
               UPDATE rvbs_file
                  SET rvbs10 = g_rvbs[l_j].rvbs06
                WHERE rvbs00 = g_rvbs00
                  AND rvbs01 = g_rvbs01
                  AND rvbs02 = g_rvbs02
                  AND rvbs13 = g_rvbs13
                  AND rvbs022= g_rvbs[l_j].rvbs022
                  AND rvbs09 = g_argv15
            END IF
         END FOR
         CLOSE s_mod_lot_bcl 
      WHEN '-1'  #出庫
         CALL s_mod_lot_rvbs()
   END CASE 
   IF g_rec_b > 0 THEN   #add for 单身无数据时会一直停留在单身
      CALL s_mod_lot_chkqty() 
   END IF

   CALL s_mod_lot_chk_all_rvbs()   #CHI-C50022 add 
END FUNCTION 

#MOD-CB0031---add---S
FUNCTION s_wo_record(p_sfb01,p_flag)
   DEFINE p_sfb01       LIKE sfb_file.sfb01
   DEFINE p_flag        LIKE type_file.chr1

   IF p_flag = 'Y' THEN
      LET g_sfb_wo_f = 'Y'
      LET g_sfb_wo = p_sfb01
   END IF

END FUNCTION
#MOD-CB0031---add---E

FUNCTION s_mod_lot_lqty()
   DEFINE i LIKE type_file.num5

   LET g_lqty = 0
   FOR i = 1 TO g_rvbs.getlength()
       IF g_rvbs[i].sel="Y" THEN 
          LET g_lqty = g_lqty + g_rvbs[i].rvbs06
       END IF
   END FOR
   DISPLAY g_lqty TO FORMONLY.lqty

END FUNCTION

FUNCTION s_mod_lot_gen() 
   DEFINE l_wc   STRING 
   DEFINE l_sql  STRING 
   DEFINE l_ima925   LIKE ima_file.ima925 
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022 
   DEFINE l_imgs11   LIKE imgs_file.imgs11 
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE lr_con     DYNAMIC ARRAY OF RECORD 
             ini03   LIKE ini_file.ini03,
             oeba04  LIKE oeba_file.oeba04,
             oeba05  LIKE oeba_file.oeba05,
             oeba06  LIKE oeba_file.oeba06,
             oeba07  LIKE oeba_file.oeba07  #FUN-CC0006 add
   END RECORD 
   DEFINE l_ogb31    LIKE ogb_file.ogb31,
          l_ogb32    LIKE ogb_file.ogb32,
          l_inj04    LIKE inj_file.inj04
   DEFINE l_con      LIKE type_file.num5,
          l_j        LIKE type_file.num5,
          l_char     LIKE inj_file.inj04,
          l_num      LIKE type_file.num10
   DEFINE l_con_cnt  LIKE type_file.num5 
   DEFINE ls_sql     STRING 
   
   IF g_argv13 = "SEL" THEN 
      RETURN 
   END IF 
  
   CALL cl_set_comp_visible("imgs08",TRUE) 
  
   LET g_rvbs00 = g_argv1 
   LET g_rvbs01 = g_argv2 
   LET g_rvbs02 = g_argv3 
   LET g_rvbs13 = g_argv4 
   LET g_rvbs021 = g_argv5 
   LET g_imgs02 = g_argv6 
   LET g_imgs03 = g_argv7 
   LET g_imgs04 = g_argv8 
   LET g_ounit  = g_argv9  
   LET g_sunit  = g_argv10  
   LET g_fac    = g_argv11   
   LET g_oqty = g_argv12    
   LET g_sqty = g_oqty * g_fac 
  
   IF g_imgs02 IS NULL THEN LET g_imgs02= ' ' END IF  
   IF g_imgs03 IS NULL THEN LET g_imgs03= ' ' END IF 
   IF g_imgs04 IS NULL THEN LET g_imgs04= ' ' END IF 
  
   SELECT ima02,ima021,ima925 
     INTO g_ima02,g_ima021,l_ima925 
     FROM ima_file 
    WHERE ima01 = g_rvbs021 
  
   CLEAR FORM  
  
   DISPLAY g_rvbs01,g_rvbs02,g_rvbs13,g_rvbs021,g_ounit,g_sunit,g_fac,g_oqty,g_sqty
          ,g_lqty 
        TO rvbs01,rvbs02,rvbs13,rvbs021,FORMONLY.ounit,FORMONLY.sunit,FORMONLY.fac,FORMONLY.oqty,FORMONLY.sqty 
          ,FORMONLY.lqty 
  
   DISPLAY g_ima02,g_ima021 TO ima02,ima021 
  

   CONSTRUCT l_wc ON imgs05,imgs06,imgs09,imgs10,imgs11 
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
      LET INT_FLAG = 0
      RETURN 
   END IF 
   
   LET l_imgs11 = g_argv14
  
   IF cl_null(l_imgs11) THEN 
      LET l_imgs11 = " " 
   END IF 
  
  
   LET l_sql = "SELECT '','N',imgs05,imgs06,imgs09,imgs08,imgs10,imgs11,0,", 
               "       '','','','','','','','','','','','',''",     #TQC-C70056 add 3 ''
               "  FROM img_file,imgs_file", 
               " WHERE img01 = imgs01", 
               "   AND img02 = imgs02", 
               "   AND img03 = imgs03", 
               "   AND img04 = imgs04", 
               "   AND imgs01 = '",g_rvbs021,"'", 
               "   AND imgs02 = '",g_imgs02,"'", 
               "   AND imgs03 = '",g_imgs03,"'", 
               "   AND imgs04 = '",g_imgs04,"'", 
               "   AND (imgs11 = ' ' OR imgs11 = '",l_imgs11,"')",  
               "   AND ",l_wc, 
               "   AND imgs08 > 0", 
               "   AND img10 <> 0" 
  
   CASE l_ima925  #排序方式 
      WHEN "1"   #序號 
         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs05"  
      WHEN "2"   #製造批號

         LET l_sql = l_sql CLIPPED," ORDER BY imgs11 DESC,imgs06"
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

   #判斷是否需要作條件篩選
   LET l_con = 0
   IF g_prog = 'axmt610' OR g_prog = 'axmt620' THEN
      SELECT ogb31,ogb32 INTO l_ogb31,l_ogb32 FROM ogb_file 
       WHERE ogb01 = g_rvbs01 AND ogb03 = g_rvbs02
       
      SELECT COUNT(*) INTO l_con FROM oeba_file,imac_file
       WHERE oeba01= l_ogb31 AND oeba02 = l_ogb32 AND imac01 = g_rvbs021 
         AND oeba04 = imac04 AND imac03='2'
         AND (oeba05 IS NOT null OR oeba06 IS NOT null)

      LET ls_sql =" SELECT ini03,oeba04,oeba05,oeba06,oeba07 " , #FUN-CC0006 add oeba07
                  "   FROM oeba_file,imac_file,ini_file",
                  "  WHERE oeba01 = '",l_ogb31 ,"'",
                  "    AND oeba02 = '",l_ogb32,"'",
                  "    AND imac01 = '",g_rvbs021,"'", 
                  "    AND oeba04 = imac04 AND imac03='2'",
                  "    AND (oeba05 IS NOT null OR oeba06 IS NOT null)",
                  "    AND ini01  = oeba04"
      PREPARE con_pre FROM ls_sql
      DECLARE con_cs CURSOR FOR con_pre
      LET l_con_cnt = 1
      IF l_con <> 0 THEN 
         FOREACH con_cs INTO lr_con[l_con_cnt].*
            IF SQLCA.sqlcode THEN 
               CALL cl_err('foreach',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF 
            LET l_con_cnt = l_con_cnt + 1
         END FOREACH
         CALL lr_con.deleteElement(l_con_cnt)
         LET  l_con_cnt = l_con_cnt - 1
      END IF 
   END IF 
   IF cl_null(g_lqty) THEN 
      LET g_lqty = 0 
   END IF
   FOREACH imgs_curs INTO g_rvbs[g_cnt].*              #單身 ARRAY 填充 
      IF STATUS THEN  
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF 
      #篩選製造批號層級資料
      IF l_con <> 0 THEN 
         FOR l_j=1 TO l_con 
            IF lr_con[l_j].ini03 = '1' THEN 
               SELECT inj04 INTO l_char FROM inj_file
                WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
                  AND inj03 = lr_con[l_j].oeba04
               IF l_char <> lr_con[l_j].oeba05 THEN 
                  CONTINUE FOREACH 
               END IF 
            END IF 

            IF lr_con[l_j].ini03 = '2' THEN 
               SELECT to_number(inj04) INTO l_num FROM inj_file
                WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
                  AND inj03 = lr_con[l_j].oeba04
              #FUN-CC0006---mark---START
              #IF l_num < lr_con[l_j].oeba05 OR l_num > lr_con[l_j].oeba06 THEN 
              #   CONTINUE FOREACH 
              #END IF
              #FUN-CC0006---mark---END 
              #FUN-CC0006---add---START
               CASE lr_con[l_j].oeba07
                  WHEN 1  #大於
                     IF l_num <= lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 2  #大於等於
                     IF l_num < lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 3  #等於
                     IF l_num <> lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 4  #小於
                     IF l_num >= lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 5  #小於等於
                     IF l_num > lr_con[l_j].oeba05 THEN
                        CONTINUE FOREACH
                     END IF
                  WHEN 6  #區間
                     IF l_num < lr_con[l_j].oeba05 OR l_num > lr_con[l_j].oeba06 THEN
                        CONTINUE FOREACH
                     END IF
               END CASE
              #FUN-CC0006---add-----END
            END IF
         END FOR 
      END IF 

         #抓取att01~att10特性資料

         FOR l_j = 1 TO g_imac.getLength()
            LET l_inj04 = NULL
            SELECT inj04 INTO l_inj04 FROM inj_file
             WHERE inj01 = g_rvbs021 AND inj02 = g_rvbs[g_cnt].rvbs04
               AND inj03 = g_imac[l_j].imac04            
            CASE l_j
               WHEN 1
                  LET g_rvbs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET g_rvbs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET g_rvbs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET g_rvbs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET g_rvbs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET g_rvbs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET g_rvbs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET g_rvbs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET g_rvbs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET g_rvbs[g_cnt].att10 = l_inj04
            END CASE
         END FOR        
      LET g_lqty = g_lqty + g_rvbs[g_cnt].rvbs06 
  
      LET l_rvbs022 = 0 
      SELECT rvbs022,rvbs06 INTO l_rvbs022,l_rvbs06 FROM rvbs_file   
       WHERE rvbs00 = g_argv1 
         AND rvbs01 = g_argv2 
         AND rvbs02 = g_argv3 
         AND rvbs13 = g_argv4 
         AND rvbs03 = g_rvbs[g_cnt].rvbs03  
         AND rvbs04 = g_rvbs[g_cnt].rvbs04  
         AND rvbs08 = g_rvbs[g_cnt].rvbs08  
         AND rvbs09 = g_argv15
  
      IF l_rvbs022 <> 0 THEN 
         LET g_rvbs[l_rvbs022].* = g_rvbs[g_cnt].* 
         LET g_rvbs[l_rvbs022].rvbs06 = l_rvbs06 
         LET g_rvbs[l_rvbs022].sel = 'Y'  

      ELSE 
         LET g_rvbs[g_cnt].rvbs022 = g_cnt 
         LET g_cnt = g_cnt + 1 
      END IF 
  
   END FOREACH 
   DISPLAY g_lqty TO FORMONLY.lqty 
  
   CALL g_rvbs.deleteElement(g_cnt) 
  
   LET g_rec_b= g_cnt-1 
  
  
  
END FUNCTION 

#更新數據
FUNCTION s_mod_lot_upd_inj()
         IF  g_rvbs[l_ac].att01 <> g_rvbs_t.att01 
             OR (cl_null(g_rvbs_t.att01) AND NOT cl_null(g_rvbs[l_ac].att01)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att01
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[1].imac04
         END IF 
         IF  g_rvbs[l_ac].att02 <> g_rvbs_t.att02 
             OR (cl_null(g_rvbs_t.att02) AND NOT cl_null(g_rvbs[l_ac].att02)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att02
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[2].imac04
         END IF 
         IF  g_rvbs[l_ac].att03 <> g_rvbs_t.att03 
             OR (cl_null(g_rvbs_t.att03) AND NOT cl_null(g_rvbs[l_ac].att03)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att03
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[3].imac04
         END IF 
         IF  g_rvbs[l_ac].att04 <> g_rvbs_t.att04  
             OR (cl_null(g_rvbs_t.att04) AND NOT cl_null(g_rvbs[l_ac].att04)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att04
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[4].imac04
         END IF
         IF  g_rvbs[l_ac].att05 <> g_rvbs_t.att05 
             OR (cl_null(g_rvbs_t.att05) AND NOT cl_null(g_rvbs[l_ac].att05)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att05
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[5].imac04
         END IF
         IF  g_rvbs[l_ac].att06 <> g_rvbs_t.att06 
             OR (cl_null(g_rvbs_t.att06) AND NOT cl_null(g_rvbs[l_ac].att06)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att06
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[6].imac04
         END IF 
         IF  g_rvbs[l_ac].att07 <> g_rvbs_t.att07  
             OR (cl_null(g_rvbs_t.att07) AND NOT cl_null(g_rvbs[l_ac].att07)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att07
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[7].imac04
         END IF
         IF  g_rvbs[l_ac].att08 <> g_rvbs_t.att08 
             OR (cl_null(g_rvbs_t.att08) AND NOT cl_null(g_rvbs[l_ac].att08)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att08
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[8].imac04
         END IF
         IF  g_rvbs[l_ac].att09 <> g_rvbs_t.att09 
             OR (cl_null(g_rvbs_t.att09) AND NOT cl_null(g_rvbs[l_ac].att09)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att09
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[9].imac04
         END IF 
         IF  g_rvbs[l_ac].att10 <> g_rvbs_t.att10 
             OR (cl_null(g_rvbs_t.att10) AND NOT cl_null(g_rvbs[l_ac].att10)) THEN
               UPDATE inj_file SET inj04 = g_rvbs[l_ac].att10
                WHERE inj01 = g_rvbs021
                  AND inj02 = g_rvbs[l_ac].rvbs04
                  AND inj03 = g_imac[10].imac04
         END IF          
END FUNCTION 

FUNCTION s_mod_lot_ins_inj(p_ac)
DEFINE l_n   LIKE type_file.num5,
       l_j   LIKE type_file.num5,
       p_ac  LIKE type_file.num5
DEFINE lr_inj  RECORD LIKE inj_file.*
DEFINE lr_imac RECORD LIKE imac_file.*
   SELECT COUNT(*) INTO l_n FROM imac_file WHERE imac01 = g_rvbs021
   IF l_n<>0 THEN
      LET l_n = 0 
      SELECT count(*) INTO l_n FROM inj_file 
       WHERE inj01 = g_rvbs021
         AND inj02 = g_rvbs[p_ac].rvbs04
      IF l_n=0 THEN 
         LET lr_inj.inj01 = g_rvbs021
         LET lr_inj.inj02 = g_rvbs[p_ac].rvbs04
         SELECT ima929 INTO lr_inj.inj05 FROM ima_file WHERE ima01 = g_rvbs021
         IF cl_null(lr_inj.inj05) THEN 
            LET lr_inj.inj05 = g_rvbs021
         END IF
         LET lr_inj.inj06 = 'N' 
         #寫入料件層級資料
         DECLARE imac_cs_2 CURSOR FOR 
                 SELECT * FROM imac_file
                  WHERE imac01 = g_rvbs021
                    AND imac03 = '1'
         FOREACH imac_cs_2 INTO lr_imac.*
            LET lr_inj.inj03 = lr_imac.imac04
            LET lr_inj.inj04 = lr_imac.imac05
            INSERT INTO inj_file VALUES(lr_inj.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","inj_file","","",SQLCA.sqlcode,"","",1)
            END IF 
         END FOREACH  
         #寫入製造批號層級資料
         FOR l_j =1 TO g_imac.getLength()
              LET lr_inj.inj03 = g_imac[l_j].imac04
              CASE l_j
                 WHEN 1
                    LET lr_inj.inj04 = g_rvbs[p_ac].att01
                 WHEN 2
                    LET lr_inj.inj04 = g_rvbs[p_ac].att02
                 WHEN 3
                    LET lr_inj.inj04 = g_rvbs[p_ac].att03
                 WHEN 4
                    LET lr_inj.inj04 = g_rvbs[p_ac].att04
                 WHEN 5
                    LET lr_inj.inj04 = g_rvbs[p_ac].att05
                 WHEN 6
                    LET lr_inj.inj04 = g_rvbs[p_ac].att06
                 WHEN 7
                    LET lr_inj.inj04 = g_rvbs[p_ac].att07
                 WHEN 8
                    LET lr_inj.inj04 = g_rvbs[p_ac].att08
                 WHEN 9
                    LET lr_inj.inj04 = g_rvbs[p_ac].att09
                 WHEN 10
                    LET lr_inj.inj04 = g_rvbs[p_ac].att10
              END CASE
              INSERT INTO inj_file VALUES(lr_inj.*)
          END FOR
       END IF 
    END IF     
END FUNCTION

FUNCTION s_mod_lot_rvbs() 
   DEFINE l_cnt     LIKE type_file.num10 
   DEFINE l_success LIKE type_file.chr1 
   DEFINE l_rvbs022 LIKE rvbs_file.rvbs022 
  
   LET l_success = "Y"   
  
   DELETE FROM rvbs_file  
    WHERE rvbs00 = g_rvbs00 
      AND rvbs01 = g_rvbs01 
      AND rvbs02 = g_rvbs02 
      AND rvbs13 = g_rvbs13 
      AND rvbs09 = g_argv15 
  
   IF STATUS THEN               
      LET l_success = "N" 
      CALL cl_err3("del","rvbs_file",g_rvbs01,"",SQLCA.sqlcode,"","del_rvbs",1) 
   END IF 
  
   LET l_rvbs022 = 1 
    
  
    FOR l_cnt = 1 TO g_rec_b       
      IF cl_null(g_rvbs[l_cnt].rvbs08) THEN 
         LET g_rvbs[l_cnt].rvbs08 = ' ' 
      END IF 
      IF cl_null(g_rvbs[l_cnt].rvbs03) THEN                                                                                          
         LET g_rvbs[l_cnt].rvbs03 = ' '                                                                                              
      END IF 
      IF cl_null(g_rvbs[l_cnt].rvbs04) THEN                                                                                          
         LET g_rvbs[l_cnt].rvbs04 = ' '                                                                                              
      END IF    
      
      IF g_rvbs[l_cnt].sel = "Y" THEN 
  
         INSERT INTO rvbs_file(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03, 
                               rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09, 
                               rvbs10,rvbs11,rvbs12,rvbs13,
                               rvbsplant,rvbslegal) 
                        VALUES(g_rvbs00,g_rvbs01,g_rvbs02,g_rvbs021,l_rvbs022, 
                               g_rvbs[l_cnt].rvbs03,g_rvbs[l_cnt].rvbs04, 
                               g_rvbs[l_cnt].rvbs05,g_rvbs[l_cnt].rvbs06, 
                               g_rvbs[l_cnt].rvbs07,g_rvbs[l_cnt].rvbs08,g_argv15, 
                               0,0,0,g_rvbs13, 
                               g_plant,g_legal)
         LET l_rvbs022 = l_rvbs022 + 1 
  
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","rvbs_file",g_rvbs01,"",STATUS,"","",1) 
            LET l_success = 'N' 
         END IF 
         CALL  s_mod_lot_ins_inj(l_cnt)
  
      END IF 
    END FOR 
  
   IF l_success = "Y" THEN 
      LET g_success = 'Y' 
   ELSE 
      LET g_success = 'N'
   END IF   
  
END FUNCTION 

FUNCTION s_mod_lot_chkqty()
   DEFINE l_qty   LIKE rvbs_file.rvbs06
   DEFINE l_r     LIKE type_file.num5
   DEFINE l_fac   LIKE img_file.img34
 
   LET l_qty = 0
 
   IF g_argv13 = "IQC" AND g_argv15 = '1' THEN
    SELECT SUM(rvbs10) INTO l_qty
      FROM rvbs_file
     WHERE rvbs00 = g_rvbs00
       AND rvbs01 = g_rvbs01
       AND rvbs02 = g_rvbs02
       AND rvbs13 = g_rvbs13
       AND rvbs09 = g_argv15
   ELSE
      SELECT SUM(rvbs06) INTO l_qty 
        FROM rvbs_file
       WHERE rvbs00 = g_rvbs00
         AND rvbs01 = g_rvbs01
         AND rvbs02 = g_rvbs02
         AND rvbs13 = g_rvbs13
         AND rvbs09 = g_argv15
   END IF
 
   IF cl_null(l_qty) THEN
      LET l_qty = 0
   END IF
                         
   IF (g_sqty <> l_qty) OR cl_null(g_sqty) THEN 
      IF (g_prog[1,7] = 'aqct110' OR 
         g_prog[1,7] = 'aqct700' OR
         g_prog[1,7] = 'aqct800' ) AND 
         g_argv15    =  '1'      THEN 
         CALL cl_err('','aim-021',1)
         CALL s_mod_lot_b()
      ELSE
         IF g_sqty < l_qty THEN
            CALL cl_err('','aim-013',1)
            CALL s_mod_lot_b()
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
   END IF
 
END FUNCTION 

#刪除rvbs_file
FUNCTION s_lot_del(p_type,p_no,p_sn,p_seq,p_item,p_act)
   DEFINE p_type          LIKE rvbs_file.rvbs00,
          p_no            LIKE rvbs_file.rvbs01,
          p_sn            LIKE rvbs_file.rvbs02,
          p_seq           LIKE rvbs_file.rvbs13,
          p_item          LIKE rvbs_file.rvbs021,
          p_act           LIKE type_file.chr3
   DEFINE l_sfp06     LIKE sfp_file.sfp06                                       
   DEFINE l_cnt           LIKE type_file.num10   #CHI-C30062 add
   DEFINE l_rvbs021       LIKE rvbs_file.rvbs021 #CHI-C30062 add
   DEFINE l_rvbs04        LIKE rvbs_file.rvbs04  #CHI-C30062 add
                                                                                
  IF p_type = 'asfi510' THEN                                                    
     SELECT sfp06 INTO l_sfp06 FROM sfp_file                                    
      WHERE sfp01 = p_no                                                        
     IF l_sfp06 = '1' THEN LET g_rvbs00 = 'asfi511' END IF                      
     IF l_sfp06 = '2' THEN LET g_rvbs00 = 'asfi512' END IF                      
     IF l_sfp06 = '3' THEN LET g_rvbs00 = 'asfi513' END IF                      
     IF l_sfp06 = '4' THEN LET g_rvbs00 = 'asfi514' END IF                      
     IF l_sfp06 = 'D' THEN LET g_rvbs00 = 'asfi519' END IF   #FUN-C70014 add
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
 
   LET g_argv1 = p_type
   LET g_argv2 = p_no
   LET g_argv3 = p_sn 
   LET g_argv4 = p_seq
   LET g_argv5 = p_item
   LET g_argv6 = p_act
 
   IF cl_null(g_argv1) THEN
     #RETURN       #MOD-D90093 mark
      RETURN TRUE  #MOD-D90093 add
   END IF
   IF cl_null(g_argv4) THEN    
      LET g_argv4=0       
   END IF  
   IF g_argv6 <> "DEL" THEN
     #RETURN       #MOD-D90093 mark
      RETURN TRUE  #MOD-D90093 add 
   END IF
 
   IF cl_null(g_argv3) THEN         
#CHI-C30062---add---START
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rvbs_file,inj_file
        WHERE rvbs021 = inj01
          AND rvbs04  = inj02
          AND rvbs00  = g_argv1
          AND rvbs01 <> g_argv2
      IF l_cnt = 0 THEN
        SELECT rvbs021,rvbs04 INTO l_rvbs021,l_rvbs04 FROM rvbs_file
          WHERE rvbs00  = g_argv1
            AND rvbs01  = g_argv2
        DELETE FROM inj_file
         WHERE inj01  = l_rvbs021
           AND inj02  = l_rvbs04
      END IF
#CHI-C30062---add-----END
      DELETE FROM rvbs_file 
       WHERE rvbs00 = g_argv1
         AND rvbs01 = g_argv2
         AND rvbs13 = g_argv4
   ELSE
#CHI-C30062---add---START
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rvbs_file,inj_file
        WHERE rvbs021 = inj01
          AND rvbs04  = inj02
          AND rvbs00  = g_argv1
          AND rvbs01 <> g_argv2
      IF l_cnt = 0 THEN
        SELECT rvbs021,rvbs04 INTO l_rvbs021,l_rvbs04 FROM rvbs_file
          WHERE rvbs00  = g_argv1
            AND rvbs01  = g_argv2
        DELETE FROM inj_file
         WHERE inj01  = l_rvbs021
           AND inj02  = l_rvbs04
      END IF
#CHI-C30062---add-----END
      DELETE FROM rvbs_file 
       WHERE rvbs00 = g_argv1
         AND rvbs01 = g_argv2
         AND rvbs02 = g_argv3
         AND rvbs13 = g_argv4
   END IF 
   IF STATUS THEN       
      RETURN FALSE
   END IF
 
   RETURN TRUE
 
END FUNCTION

#依專案代碼及料號判斷是否該做批序號管理
FUNCTION s_lot_chk_rvbs(l_pja01,l_ima01)   
 DEFINE l_pja01    LIKE pja_file.pja01,
        l_ima01    LIKE ima_file.ima01
 DEFINE l_i,l_cnt  LIKE type_file.num5,
        l_pja26     LIKE pja_file.pja26
 
#FUN-AB0059 ---------------------start---------------------------- 
 IF s_joint_venture( l_ima01,g_plant) OR NOT s_internal_item( l_ima01,g_plant ) THEN
    RETURN FALSE
 END IF
#FUN-AB0059 ---------------------end-------------------------------
 IF NOT cl_null(l_pja01) THEN
   SELECT pja26 INTO l_pja26 FROM pja_file
    WHERE pja01 = l_pja01
   IF l_pja26 = 'Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM ima_file
      WHERE ima01 = l_ima01
        AND (ima918 = 'Y' OR ima921 = 'Y')
     IF l_cnt = 0 THEN
        RETURN TRUE
     END IF
   END IF
 END IF
 
 RETURN FALSE
END FUNCTION
 
#080402全部併到 rvbs_file,取消ogbs_file,rvbs09:1入 -1出
#INSET 資料到rvbs_file/ogbs_file
#l_act :入出庫   1:出庫(ogbs_file)   2:入庫(rvbs_file)
#rvbs00:作業代號 g_prog
#rvbs01:單號
#rvbs02:單身序號
#rvbs021:料號
#rvbs022.dbo.rvbs_file序號 (此處不做批號管理的固定為1)
#rvbs06:單身數量 (必需換算成庫存數量)
#rvbs08:專案代號
#rvbs09: 1/-1  case 1入庫 / -1出庫  #080402異動
 
FUNCTION s_lot_ins_rvbs(l_act,b_rvbs)   #rvbs傳整個table
 DEFINE l_act    LIKE type_file.chr1
 DEFINE b_rvbs  RECORD LIKE rvbs_file.*,
        l_rvbs  RECORD LIKE rvbs_file.*
 IF cl_null(b_rvbs.rvbs01) THEN RETURN END IF
 
 
 LET b_rvbs.rvbs022 = 1
 LET b_rvbs.rvbs03 = ' ' 
 LET b_rvbs.rvbs04 = ' '
 LET b_rvbs.rvbs05 = null
 LET b_rvbs.rvbs07 = '3'
 LET b_rvbs.rvbs13 = '0'
 LET b_rvbs.rvbsplant = g_plant #FUN-980012 add
 LET b_rvbs.rvbslegal = g_legal #FUN-980012 add
 
 CASE l_act
   WHEN "1"  #出庫
     LET b_rvbs.rvbs09 = -1
 
  WHEN "2"   #入庫
     LET b_rvbs.rvbs09 = 1
 
 END CASE
 
 
 CASE l_act
   WHEN "1"  #出庫
     LET b_rvbs.rvbs09 = -1
 
  WHEN "2"   #入庫
     LET b_rvbs.rvbs09 = 1
 
 END CASE
 
 SELECT * INTO l_rvbs.*  FROM rvbs_file
  WHERE rvbs00 = b_rvbs.rvbs00
    AND rvbs01 = b_rvbs.rvbs01
    AND rvbs02 = b_rvbs.rvbs02
    AND rvbs03 = b_rvbs.rvbs03
    AND rvbs04 = b_rvbs.rvbs04
    AND rvbs07 = b_rvbs.rvbs07
    AND rvbs09 = b_rvbs.rvbs09
 IF SQLCA.sqlcode = 100 THEN
 
    INSERT INTO rvbs_file values(b_rvbs.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","rvbs_file",b_rvbs.rvbs01,b_rvbs.rvbs02,STATUS,"","",1)
       LET g_success = 'N'
    END IF
 ELSE
    UPDATE rvbs_file
       SET rvbs021 = b_rvbs.rvbs021 
          ,rvbs06 = b_rvbs.rvbs06
          ,rvbs08 = b_rvbs.rvbs08
     WHERE rvbs00 = b_rvbs.rvbs00
       AND rvbs01 = b_rvbs.rvbs01
       AND rvbs02 = b_rvbs.rvbs02
       AND rvbs03 = b_rvbs.rvbs03
       AND rvbs04 = b_rvbs.rvbs04
       AND rvbs07 = b_rvbs.rvbs07
       AND rvbs09 = b_rvbs.rvbs09
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","rvbs_file",b_rvbs.rvbs01,b_rvbs.rvbs02,STATUS,"","",1)
       LET g_success = 'N'
    END IF
 END IF
END FUNCTION

FUNCTION s_mod_lot_refresh_detail()
  DEFINE li_col_count                 LIKE type_file.num5 
  DEFINE li_i, li_j,li_cnt            LIKE type_file.num5
  DEFINE lc_index                     STRING
  DEFINE ls_sql                       STRING
  DEFINE ls_show,ls_hide              STRING
  DEFINE ls_entry,ls_noentry          STRING 
  DEFINE l_ini02                      LIKE ini_file.ini02

   #抓取製造批號層級料件特性資料
   LET li_cnt = 1
   DECLARE imac_cs CURSOR FOR 
           SELECT imac04 FROM imac_file 
            WHERE imac01 = g_argv5
              AND imac03 = '2'
             ORDER BY imac02
   CALL g_imac.clear()   #TQC-C20462 add
   FOREACH imac_cs INTO g_imac[li_cnt].*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF 
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL g_imac.deleteElement(li_cnt)
   #依料件特性資料動態顯示隱藏欄位名稱及內容
   LET ls_hide = ' '
   LET ls_show = ' '
  FOR li_i = 1 TO g_imac.getLength()
     SELECT ini02 INTO l_ini02 FROM ini_file
      WHERE ini01 = g_imac[li_i].imac04
      LET lc_index = li_i USING '&&' 
      
     CALL cl_set_comp_att_text("att" || lc_index,l_ini02)
     IF li_i = 1 THEN
        LET  ls_show = ls_show || "att" || lc_index
     ELSE
        LET  ls_show = ls_show || ",att" || lc_index
     END IF
     CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
   END FOR
   FOR li_j = li_i TO 10
       LET lc_index = li_j USING '&&'
       IF li_j = li_i THEN
          LET ls_hide = ls_hide || "att" || lc_index
       ELSE
          LET ls_hide = ls_hide || ",att" || lc_index
       END IF
   END FOR 
   CALL cl_set_comp_visible(ls_hide,FALSE)
   CALL cl_set_comp_visible(ls_show,TRUE)
END FUNCTION

FUNCTION s_mod_lot_set_entry_b(p_cmd)
DEFINE       p_cmd     LIKE  type_file.chr1
   IF g_argv15 = '1' THEN  
      CALL cl_set_comp_entry("rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",TRUE)
      IF (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rvbs08",TRUE)
      END IF
 
      IF g_barcode = "N" THEN
         CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05",TRUE)
      END IF

      IF cl_null(g_argv14) THEN
         CALL cl_set_comp_entry("rvbs07,rvbs08",TRUE)
      END IF
   END IF 

   IF g_argv15 = '-1' THEN 
      CALL cl_set_comp_entry("rvbs06",TRUE)
   END IF 
    
END FUNCTION 

FUNCTION s_mod_lot_set_no_entry_b(p_cmd)
DEFINE       p_cmd     LIKE  type_file.chr1
DEFINE       l_j   LIKE  type_file.num5
DEFINE       ls_entry,ls_noentry  STRING 
DEFINE       l_inj06   LIKE inj_file.inj06
DEFINE       lc_index  STRING 

   IF g_argv15 = '1' THEN  #入庫欄位控制
      IF cl_null(g_rvbs[l_ac].rvbs07) THEN
         CALL cl_set_comp_entry("rvbs08",FALSE)
      END IF 
 
      IF g_barcode = "Y" THEN
         CALL cl_set_comp_entry("rvbs022,rvbs05,rvbs07,rvbs08",FALSE)
         IF g_ima918 = "N" THEN
            CALl cl_set_comp_entry("rvbs04",FALSE)
         END IF
         IF g_ima921 = "N" THEN
            CALL cl_set_comp_entry("rvbs03",FALSE) 
         END IF
      END IF
 
      IF g_argv13 = "SEL" OR g_argv13 = "IQC" THEN 
         CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE)
      END IF

      IF NOT cl_null(g_argv14) THEN
         CALL cl_set_comp_entry("rvbs07,rvbs08",FALSE)
      END IF
   END IF 

   IF g_argv15 = '-1' THEN 
      CALL cl_set_comp_entry("rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE)
      IF g_argv13 = 'SEL' THEN  #只可修改數量 
         CALL cl_set_comp_entry("rvbs022,rvbs03,rvbs04,rvbs05,rvbs07,rvbs08",FALSE) 
      ELSE 
         IF g_rvbs[l_ac].sel = "N" THEN 
            CALL cl_set_comp_entry("rvbs06",FALSE) 
         END IF    
      END IF
   END IF 
   IF (NOT g_before_input_done) AND p_cmd = 'u' THEN 
       LET ls_entry = ' '
       LET ls_noentry = ' '
       FOR l_j = 1 TO g_imac.getLength() 
           SELECT inj06 INTO l_inj06 FROM inj_file
            WHERE inj01 = g_rvbs021 
              AND inj02 = g_rvbs[l_ac].rvbs04
              AND inj03 = g_imac[l_j].imac04
           LET lc_index = l_j USING '&&'
           IF l_j = 1 THEN
              IF l_inj06 = 'Y' THEN
                 LET ls_noentry = ls_noentry || "att" || lc_index
              ELSE
                 LET ls_entry   = ls_entry || "att" || lc_index
              END IF
           ELSE
              IF l_inj06 = 'Y' THEN 
                 LET ls_noentry = ls_noentry || ",att" || lc_index
              ELSE 
                 LET ls_entry   = ls_entry || ",att" || lc_index
              END IF 
           END IF
        END FOR 
    END IF 
    CALL cl_set_comp_entry(ls_noentry,FALSE)
    CALL cl_set_comp_entry(ls_entry,TRUE)
            
END FUNCTION
 
FUNCTION s_mod_lot_set_required()
   IF g_argv15 = '1' THEN 
      IF NOT cl_null(g_rvbs[l_ac].rvbs07) THEN
         CALL cl_set_comp_required("rvbs08",TRUE)
      END IF
 
      IF g_ima918 = 'Y' THEN
         CALL cl_set_comp_required("rvbs04",TRUE)
      END IF
 
      IF g_ima921 = 'Y' THEN
         CALL cl_set_comp_required("rvbs03",TRUE)
      END IF
 
      CALL cl_set_comp_required("rvbs06",TRUE)
   END IF 

END FUNCTION 
 
FUNCTION s_mod_lot_set_no_required()
   IF g_argv15 = '1' THEN 
      CALL cl_set_comp_required("rvbs03,rvbs04,rvbs08",FALSE)
   END IF 
END FUNCTION  

FUNCTION s_mod_lot_rvbs08()
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

#TQC-C10054---add---end---

#CHI-CB0056 add begin---------------------
FUNCTION s_mod_lot_check_rvbs06()
DEFINE l_sfe01  LIKE sfe_file.sfe01     #工單編號
DEFINE l_qty    LIKE rvbs_file.rvbs06,  #批序號發料數量總和
       l_qty_t  LIKE rvbs_file.rvbs06,  #批序號退料數量總和
       l_rvbs03 LIKE rvbs_file.rvbs03,  #序號
       l_rvbs04 LIKE rvbs_file.rvbs04   #製造批號
   IF l_ac <= 0 OR cl_null(l_ac) THEN RETURN TRUE END IF 
   IF g_rvbs[l_ac].rvbs06 < 0 THEN
      CALL cl_err('','axm-948',0) 
      RETURN FALSE 
   END IF 
   IF g_rvbs00 = "asfi526" OR g_rvbs00 = "asfi527" OR
      g_rvbs00 = "asfi528" OR g_rvbs00 = "asfi529" THEN
      #抓取當前批序號資料對應的工單
      SELECT sfs03 INTO l_sfe01 FROM sfs_file
       WHERE sfs01 = g_rvbs01 AND sfs02 = g_rvbs02

      #抓取工單當前批序號料件的已發料總量
      SELECT SUM(rvbs06) INTO l_qty FROM rvbs_file,sfe_file 
       WHERE rvbs00 IN ('asfi511','asfi512','asfi513','asfi514','asfi519')
         AND rvbs01 = sfe02 AND rvbs02 = sfe28 
         AND sfe01 = l_sfe01 AND rvbs03 = g_rvbs[l_ac].rvbs03
         AND rvbs04 = g_rvbs[l_ac].rvbs04 AND rvbs13 = g_rvbs13
         AND rvbs09 = -1
      IF cl_null(l_qty) THEN LET l_qty = 0 END IF 

      #抓取工單當前批序號料件的已退料總量
      SELECT SUM(rvbs06) INTO l_qty_t FROM rvbs_file,sfe_file 
       WHERE rvbs00 IN ('asfi526','asfi527','asfi528','asfi529')
         AND rvbs01 = sfe02 AND rvbs02 = sfe28 
         AND sfe01 = l_sfe01 AND rvbs03 = g_rvbs[l_ac].rvbs03
         AND rvbs04 = g_rvbs[l_ac].rvbs04 AND rvbs13 = g_rvbs13
         AND rvbs09 = 1
      IF cl_null(l_qty_t) THEN LET l_qty_t = 0 END IF 
      
      IF g_rvbs[l_ac].rvbs06 > l_qty - l_qty_t THEN
         CALL cl_err('','asf1035',0) 
         RETURN FALSE 
      END IF 
   END IF 
   RETURN TRUE 
END FUNCTION 
#CHI-CB0056 add end-----------------------

#CHI-C50022 str add-----
FUNCTION s_mod_lot_chkrvbs(p_rvbs03,p_rvbs04,p_rvbs06)
   DEFINE l_sql      STRING
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_rvu02    LIKE rvu_file.rvu02
   DEFINE l_rvv05    LIKE rvv_file.rvv05
   DEFINE p_rvbs03   LIKE rvbs_file.rvbs03
   DEFINE p_rvbs04   LIKE rvbs_file.rvbs04
   DEFINE p_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06
   DEFINE l_rvbs10   LIKE rvbs_file.rvbs10
   
   LET l_sql=" SELECT rvbs10 FROM rvbs_file ",
             "  WHERE (rvbs00 = 'apmt110' OR rvbs00 = 'apmt111' OR rvbs00 = 'apmt200') ",
             "    AND rvbs01 = ? ",
             "    AND rvbs02 = ? ",
             "    AND rvbs03 = ? ",
             "    AND rvbs04 = ? ",
             "    AND rvbs09 = 1 "
   PREPARE rvbs_p2 FROM l_sql
   DECLARE rvbs_c2 CURSOR FOR rvbs_p2
   
   LET l_sql=" SELECT sum(rvbs06) ",
             "   FROM rvbs_file,rvu_file,rvv_file ",
             "  WHERE (rvbs00 = 'apmt720' OR rvbs00 = 'apmt730') ", 
             "    AND rvu01=rvbs01  ", 
             "    AND rvu01=rvv01  ",
             "    AND rvv04= ? ", 
             "    AND rvv05= ? ", 
             "    AND rvuconf = 'Y' ",
             "    AND rvbs03 = ? ",  
             "    AND rvbs04 = ? ",
             "    AND rvbs09 = 1 "
			 
   PREPARE rvbs_p3 FROM l_sql
   DECLARE rvbs_c3 CURSOR FOR rvbs_p3            
   
   LET l_flag = 'Y'
   
   SELECT rvu02,rvv05 INTO l_rvu02,l_rvv05 FROM rvu_file,rvv_file 
	WHERE rvu01=rvv01 AND rvv01=g_rvbs01 AND rvv02=g_rvbs02
	
  #抓取允收量
   OPEN rvbs_c2 USING l_rvu02,l_rvv05,p_rvbs03,p_rvbs04
   FETCH rvbs_c2 INTO l_rvbs10

  #抓取已入庫
   OPEN rvbs_c3 USING l_rvu02,l_rvv05,p_rvbs03,p_rvbs04
   FETCH rvbs_c3 INTO l_rvbs06
   IF cl_null(l_rvbs06) THEN LET l_rvbs06 = 0 END IF
   
  #    此次入庫 + 已入庫   >  允收量
   IF  p_rvbs06 + l_rvbs06 > l_rvbs10 THEN
     LET l_flag = 'N'
     CALL s_errmsg('rvbs06',l_rvbs06,'','aim-040',1)
     RETURN l_flag
   END IF
   
   CLOSE rvbs_c2
   CLOSE rvbs_c3

   RETURN l_flag
   
END FUNCTION

FUNCTION s_mod_lot_chk_all_rvbs()
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_flag2    LIKE type_file.chr1
   DEFINE l_rvbs03   LIKE rvbs_file.rvbs03
   DEFINE l_rvbs04   LIKE rvbs_file.rvbs04
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06

   LET l_flag = 'Y'
   
   IF g_prog[1,7] <> 'apmt720' AND g_prog[1,7] <> 'apmt730' THEN
      RETURN 
   END IF


   DECLARE rvbs_c1 CURSOR FOR
           SELECT rvbs03,rvbs04,rvbs06
             FROM rvbs_file
            WHERE rvbs00 = g_rvbs00
              AND rvbs01 = g_rvbs01	  
              AND rvbs02 = g_rvbs02	 
              AND rvbs09 = 1
            ORDER BY rvbs022

   CALL s_showmsg_init()
   FOREACH rvbs_c1 INTO l_rvbs03,l_rvbs04,l_rvbs06
	CALL s_mod_lot_chkrvbs(l_rvbs03,l_rvbs04,l_rvbs06) 
	     RETURNING l_flag2
        IF l_flag = 'Y' AND l_flag2 = 'N' THEN
           LET l_flag = 'N'
        END IF
   END FOREACH
   CALL s_showmsg()         
 
   IF l_flag = 'N' THEN
     CALL s_mod_lot_b()
   END IF 
   
END FUNCTION
#CHI-C50022 end add-----
#DEV-D40013 add
