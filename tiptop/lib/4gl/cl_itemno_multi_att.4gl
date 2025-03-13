# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_itemno_multi_att.4gl
# Descriptions...: 料件多屬性欄位
# Date & Author..: 05/04/01 by saki
# Usage..........: CALL cl_itemno_multi_att("ima01",g_ima.ima01,"I",'1')
# Modify.........: 05/08/16 By Lifeng 增加復制子料件BOM的函數
# Modify.........: No.FUN-570234 05/10/21 By will 子料件分隔符采用sma_file.sma46
#                  cl_copy_bom()
# Modify.........: No.TQC-5A0001 05/11/07 By saki 修改母料件截取方式及子料件生成后的存入規則
# Modify.........: No.TQC-5C0115 05/12/26 By jackie 修改單身輸入屬性值后帶不出子料件編號問題
# Modify.........: No.FUN-640013 06/03/27 By Rayven 支持料件多屬性機制新流程，增加向imx_file中插入imx00父料件編號欄位
# Modify.........: No.FUN-640139 06/04/11 By Lifeng 修改cl_copy_bom將單純INSERT改為DELETE＋INSERT以支持更新方式
# Modify.........: No.TQC-640171 06/04/26 By Rayven 增加判定輸入的是母料件還是多屬性子料件
# Modify.........: No.TQC-650035 06/05/10 By wujie 如果在BOM預覽中修改了公式算出的料號，則在復制BOM時也要對應修改料號
# Modify.........: No.TQC-650070 06/05/16 By wujie 增加WHENEVER ERROR CONTINUE的錯誤處理
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-650108 06/05/25 By Rayven Return料件編號處增加一個參數返回，'0'or'1'，用于判定訂單子料件可否新增
# Modify.........: No.MOD-670007 06/07/03 By wujie axm出貨單down出
# Modify.........: No.FUN-650108 06/07/04 By yoyo axm銷退單down出
# Modify.........: No.FUN-690005 06/09/25 By cheunl 欄位定義類型轉換
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.TQC-7C0024 07/12/06 By wujie 非訂單時，提示不能生成新的子料件到ima_file中
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830086 08/03/24 By jan 當使用多屬性時，過料件編號，只要料號存在，母料號也可過
# Modify.........: No.FUN-840036 08/03/27 By ve007 產生子料件后,母料件否附為'N', 服飾版時， 不需自動復制母料件的BOM給子料件
# Modify.........: No.FUN-830132 08/03/27 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-830116 08/04/18 By Arman  
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.MOD-890210 08/09/22 By wujie 新增子料件時，部分欄位預設錯誤，圖片沒有copy
# Modify.........: No.MOD-8A0098 08/10/22 By wujie 增加ps_type ='f',對應rvv的情況
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920176 09/02/12 By claire 連動BOM新增時,狀態碼應為0
# Modify.........: No.TQC-940011 09/04/06 By Hiko 解決多屬性欄位在垂直的Scroll Bar出現後不見的問題.
# Modify.........: No:MOD-A80027 10/08/04 By tommas 移動MOD-890210的程式區塊
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值,在insert into bmd_file之前給bmd11賦值
# Modify.........: No:FUN-C30006 12/08/27 By bart 在cl_copy_ima中，call cl_copy_bom之前加判斷，IF sma909='Y'時，才COPY
# Modify.........: No:TQC-D90008 13/09/10 By SunLM 當sma46為null時候,應該賦值' ',否則l_ps為空,導致後續生成bom異常

DATABASE ds
                                           
GLOBALS "../../config/top.global"   #FUN-7C0053
                                           
# Descriptions...: 依照欄位值動態產生多屬性欄位
# Date & Author..: 2005/04/01 by saki
# Input Parameter: ps_field   STRING   料件欄位
#                  ps_value   STRING   料件編號(父料件)
#                  ps_spec    VARCHAR(1)  料件規格
#                  ps_mode    VARCHAR(1)  調用模式，如果是下面cl_show_itemno_multi_att函數調用，則這里使用'0',
#                                      否則使用'1',兩者的區別在于前者不需要判斷ps_field，直接把ls_tag_name
#                                      設置為‘TableColumn‘, Add By Lifeng        
#                  ps_type    VARCHAR(1)  通過不同的參數來指定不同的屏幕變量
#                                      '1' s_oeb        '2' s_tsl 
#                                      '3' s_imn        '4' s_inb
#                                      '5' s1_ohb       '6' s_b1 
#                                      '7' s_tsh        '8' s_ohb
#                                      '9' s_pnn        'a' s_rvb
#                                      'b' s_pmn        'c' s_pml
#                                      'd' s_ogb        'e' s1_ohb
# Return Code...: '0'或'1'   0表示不能新增子料件，1表示能新增，僅對可以新增子料件的程序有效,如不能新增子料件，都返回'1'
#                 ls_value   STRING   料件編號(全編號)
#                 ls_spec    STRING   料件規格(全規格)
# Modify........: 05/05/26 By Lifeng
#                 1.調整agc04的欄位類型,從NUMBER到CHAR
#                 2.增加向ima_file中插入子料件的功能以及向對應的料件屬性檔imx_file中插入明細信息的功能
#                 3.修改原來合成子料件名稱的規則,由“屬性組名稱_明細屬性”改為”母料件名稱_明細屬性“
 
FUNCTION cl_itemno_multi_att(ps_field,ps_value,ps_spec,ps_mode,ps_type) 
   DEFINE   ps_field     STRING,
            ps_value     STRING,
            ps_spec      STRING,
            ps_mode      LIKE type_file.chr1,    #No.FUN-690005 VARCHAR(1),
            ps_type      LIKE type_file.chr1     #No.FUN-690005 VARCHAR(1)
   DEFINE   llst_att     base.StringTokenizer
   DEFINE   ls_item_p    STRING
   DEFINE   ls_att       STRING
   DEFINE   lnode_root   om.DomNode
   DEFINE   lwin_curr    ui.Window
   DEFINE   lfrm_curr    ui.Form
   DEFINE   lnode_item   om.DomNode
   DEFINE   ls_tag_name  STRING
   DEFINE   ls_value     STRING
   DEFINE   ls_spec      STRING
   DEFINE   lr_att       ARRAY[10] OF STRING
   DEFINE   lr_att_c     ARRAY[10] OF STRING
   DEFINE   li_i         LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   l_n          LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   li_col_count LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   lc_index     LIKE type_file.chr2    #No.FUN-690005 VARCHAR(02)
   DEFINE   l_imaag1     LIKE ima_file.imaag
   DEFINE   lc_aga01     LIKE aga_file.aga01
   DEFINE   lc_aga02     LIKE aga_file.aga02
   DEFINE   lc_agb03     LIKE agb_file.agb03
   DEFINE   lc_agd02     LIKE agd_file.agd02
   DEFINE   lc_agd03     LIKE agd_file.agd03
   DEFINE   lr_agc       DYNAMIC ARRAY OF RECORD
               agc01     LIKE agc_file.agc01,
               agc02     LIKE agc_file.agc02,
               agc03     LIKE agc_file.agc03,
               agc04     LIKE agc_file.agc04,
               agc05     LIKE agc_file.agc05,
               agc06     LIKE agc_file.agc06
                         END RECORD
   DEFINE   lr_agd       RECORD LIKE agd_file.*
   DEFINE   ls_combo_vals STRING
   DEFINE   ls_combo_txts STRING
   DEFINE   ls_sql       STRING
   DEFINE   li_min_num   LIKE agc_file.agc05
   DEFINE   li_max_num   LIKE agc_file.agc06
   DEFINE   ls_item_text STRING
   DEFINE   lnode_parent om.DomNode
   DEFINE   li_currRow   LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   ls_str       STRING
   DEFINE   l_ps         LIKE sma_file.sma46  #No.FUN-570234 Add
#  DEFINE   l_result     SMALLINT,
#           lc_imaag     LIKE ima_file.imaag
 
   #Add By Lifeng Start
   DEFINE   ps_value_tmp LIKE ima_file.ima01
   DEFINE   ls_value_tmp LIKE ima_file.ima01
   DEFINE   ls_name      LIKE ima_file.ima02
   DEFINE   ls_imx01  LIKE imx_file.imx01,
            ls_imx02  LIKE imx_file.imx02,
            ls_imx03  LIKE imx_file.imx03,
            ls_imx04  LIKE imx_file.imx04,
            ls_imx05  LIKE imx_file.imx05,
            ls_imx06  LIKE imx_file.imx06,
            ls_imx07  LIKE imx_file.imx07,
            ls_imx08  LIKE imx_file.imx08,
            ls_imx09  LIKE imx_file.imx09,
            ls_imx10  LIKE imx_file.imx10
   DEFINE   lc_temp_ima  LIKE ima_file.ima01
   DEFINE   l_param_list STRING
   DEFINE   l_agb03      LIKE agb_file.agb03
   DEFINE   l_tmp        STRING
   DEFINE   l_str_tok    base.StringTokenizer
   DEFINE   ls_parent    LIKE ima_file.ima01    #No.FUN-640013
   DEFINE   lc_parent    LIKE ima_file.ima01    #No.FUN-640013
   DEFINE   lc_child     LIKE ima_file.ima01    #No.FUN-640013
 
   #No.TQC-5A0001 --start--
   DEFINE   li_cnt       LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   lc_imaag     LIKE ima_file.imaag
   DEFINE   lc_imaag1    LIKE ima_file.imaag1
   #No.TQC-5A0001 ---end---
 
   DEFINE   l_result     LIKE type_file.num5    #No.FUN-690005 SMALLINT  #No.TQC-640171
   DEFINE   g_value      LIKE ima_file.ima01  #No.TQC-640171
   DEFINE   g_spec       LIKE ima_file.ima01  #No.TQC-640171
   DEFINE   ls_tabname   STRING               #No.FUN-720042
   DEFINE   l_flag       LIKE type_file.chr1  #No.FUN-7B0018
 
   #No.TQC-940011 --start--
   DEFINE l_table_name STRING,
          l_table_node om.DomNode,
          l_table_offset SMALLINT
   #No.TQC-940011 --start--
 
   LET ls_imx01 = ""
   LET ls_imx02 = ""
   LET ls_imx03 = ""
   LET ls_imx04 = ""
   LET ls_imx05 = ""
   LET ls_imx06 = ""
   LET ls_imx07 = ""
   LET ls_imx08 = ""
   LET ls_imx09 = ""
   LET ls_imx10 = ""   
   #Add By Lifeng End
 
   SELECT sma46 INTO l_ps FROM sma_file  #No.FUN-570234  --add
   IF l_ps IS NULL THEN 
      LET l_ps = ' '   #TQC-D90008 add
   END IF  
   IF (ps_field IS NULL) OR (ps_value IS NULL) THEN
      RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
   END IF
 
   #No.TQC-640171  --start--
   CALL cl_is_multi_feature_manage(ps_value) RETURNING l_result 
   IF l_result = 0 THEN
      LET g_value = ps_value
      SELECT ima02 INTO g_spec
        FROM ima_file
       WHERE ima01 = g_value
      RETURN '1',g_value,g_spec  #No.TQC-650108 新增返回參數'1'
   END IF
   #No.TQC-640171  --end--
 
   LET lnode_root = ui.Interface.getRootNode()
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
   END IF
 
   IF ps_mode = '1' THEN
      LET ls_tabname = cl_get_table_name(ps_field)  #No.FUN-720042
      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ps_field)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_field)
         IF lnode_item IS NULL THEN
            RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
         ELSE
            LET ls_tag_name = "TableColumn"
         END IF
      ELSE
         LET ls_tag_name = "FormField"
      END IF
   ELSE #如果被下面的cl_show_itemno_multi_att調用則直接設置為TableColumn
      LET ls_tag_name = "TableColumn"
   END IF
 
   #這里很奇怪,好象如果輸入的是子料件一樣可以繼續生成子料件
   #No.TQC-5A0001 --start--
   #先用傳進來的值到ima_file里面找imaag,imaag1來判斷是要開怎樣的多屬性
   LET lc_temp_ima = ps_value
   SELECT COUNT(*) INTO li_cnt FROM ima_file WHERE ima01 = lc_temp_ima
   IF li_cnt > 0 THEN
      SELECT imaag,imaag1 INTO lc_imaag,lc_imaag1 FROM ima_file WHERE ima01 = lc_temp_ima
      IF lc_imaag IS NULL THEN         #如果ima_file已經存在且沒有屬性群組，代表非多屬性料號
         RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
      ELSE        
         IF lc_imaag != "@CHILD" THEN  #如果ima_file存在且屬性群組有值但不等于@CHILD，代表為母料件
            LET ls_item_p = ps_value
         ELSE                          #如果ima_file存在且屬性值=@CHILD，代表為子料件
            #FUN-640013 Modified , 如果是子料件,那么取其對應的母料件(原來是取第一個"_"符號
            #左邊的東東,但這樣是不對的,因為分隔符是系統通過sma46來定義的,是會變的,另一方面,
            #如果母料件的料號中本來就包含分隔符,那么這里取值就會出現錯誤,
            #料件多屬性的新機制中已經在imx_file中增加了一個欄位imx00來存放
            #多屬性子料件對應的母料件,現在改成這樣的取法了,
            #下面是被注釋掉的原來的代碼
            #LET ls_item_p = ps_value.subString(1,ps_value.getIndexOf("_",1) - 1)
            LET lc_child = ps_value
            SELECT imx00 INTO lc_parent FROM imx_file 
              WHERE imx000 = lc_child
            #料件多屬性舊機制下是不會往imx00中填東西的,所以權當不識別了
            IF cl_null(lc_parent) THEN RETURN '1',ps_value,ps_spec END IF  #No.TQC-650108 新增返回參數'1'
            LET ls_item_p = lc_parent
         END IF
      END IF
   ELSE
      RETURN '1',ps_value,ps_spec   #No.TQC-650108 新增返回參數'1'      
      #如果ima_file不存在代表沒有此母料件，也沒有任何料件編號符合
   END IF
#  IF ps_value.getIndexOf(l_ps,1) > 0 THEN   #FUN-570234
#     LET ls_item_p = ps_value.subString(1,ps_value.getIndexOf("_",1) - 1)
#     LET llst_att = base.StringTokenizer.create(ps_value,l_ps)
#     LET li_i = 0
#     WHILE llst_att.hasMoreTokens()
#        LET ls_att = llst_att.nextToken()
#        IF li_i = 0 THEN
#           LET ls_item_p = ls_att
#        ELSE
#           RETURN ps_value,ps_spec
#           LET lr_att[li_i] = ls_att
#           LET lr_att_c[li_i] = ls_att
#        END IF
#        LET li_i = li_i + 1
#     END WHILE
#  ELSE
#     LET ls_item_p = ps_value
#  END IF
   #No.TQC-5A0001 ---end---
 
   #Add By Lifeng Start ,此處需要根據ls_item_p得到屬性群組并將
   #屬性群組賦給lc_aga01，而不是象原有的做法直接將ls_item_p賦給它
   #LET lc_aga01 = ls_item_p
   LET lc_temp_ima = ls_item_p
   SELECT aga01 INTO lc_aga01 FROM aga_file 
     WHERE aga01 = ( SELECT imaag FROM ima_file WHERE ima01 = lc_temp_ima )
   IF lc_aga01 IS NULL OR lc_aga01 = '@CHILD' THEN
      RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
   END IF
 
  SELECT COUNT(*) INTO li_col_count FROM agb_file
    WHERE agb01 = lc_aga01
   IF li_col_count = 0 THEN
      RETURN '1',ps_value,ps_spec  #No.TQC-650108 新增返回參數'1'
   END IF
 
   CASE ls_tag_name
      WHEN "FormField"
      WHEN "TableColumn"
         # 顯現該有的欄位,置換欄位格式
         FOR li_i = 1 TO li_col_count
            SELECT agb03 INTO lc_agb03 FROM agb_file
             WHERE agb01 = lc_aga01 AND agb02 = li_i
 
            LET lc_agb03 = lc_agb03 CLIPPED
            SELECT * INTO lr_agc[li_i].* FROM agc_file
             WHERE agc01 = lc_agb03
 
            LET lc_index = li_i USING '&&'
 
            CASE lr_agc[li_i].agc04
               WHEN '1'
                  CALL cl_set_comp_visible("att" || lc_index,TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                  CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
               WHEN '2'
                  CALL cl_set_comp_visible("att" || lc_index || "_c",TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
                  LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
                  DECLARE agd_curs CURSOR FROM ls_sql
                  LET ls_combo_vals = ""
                  LET ls_combo_txts = ""
                  FOREACH agd_curs INTO lr_agd.*
                     IF SQLCA.sqlcode THEN
                        EXIT FOREACH
                     END IF
                     IF ls_combo_vals IS NULL THEN
                        LET ls_combo_vals = lr_agd.agd02 CLIPPED
                     ELSE
                        LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                     END IF
                     IF ls_combo_txts IS NULL THEN
                        LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                     ELSE
                        LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                     END IF
                  END FOREACH
                  CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
                  CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
               WHEN '3'
                  CALL cl_set_comp_visible("att" || lc_index,TRUE)
                  CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                  CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
            END CASE
         END FOR
 
         IF ps_mode = "1" THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
            LET lnode_parent = lnode_item.getParent()
            LET li_currRow = lnode_parent.getAttribute("currentRow")
            LET li_currRow = li_currRow + 1
         ELSE 
            LET li_currRow = 1    #如果是在下面的函數中調用則永遠顯示在第一行
         END IF
 
         #No.TQC-940011 --start--
         CASE ps_type
            WHEN '1' LET l_table_name = "s_oeb"
            WHEN '2' LET l_table_name = "s_tsl"
            WHEN '3' LET l_table_name = "s_imn"
            WHEN '4' LET l_table_name = "s_inb"
            WHEN '5' LET l_table_name = "s1_ohb"
            WHEN '6' LET l_table_name = "s_b1"
            WHEN '7' LET l_table_name = "s_tsh"
            WHEN '8' LET l_table_name = "s_ohb"
            WHEN '9' LET l_table_name = "s_pnn"
            WHEN 'a' LET l_table_name = "s_rvb"
            WHEN 'b' LET l_table_name = "s_pmn"
            WHEN 'c' LET l_table_name = "s_pml"
            WHEN 'd' LET l_table_name = "s_ogb"
            WHEN 'e' LET l_table_name = "s1_ohb"
            WHEN 'f' LET l_table_name = "s_rvv"
            OTHERWISE
               DISPLAY "The type ",ps_type," has not definition."
         END CASE
 
         LET l_table_node = lfrm_curr.findNode("Table", l_table_name)
         IF l_table_node IS NOT NULL THEN
            #offset指的是Table的垂直Scroll捲動的資料筆數有幾筆.
            LET l_table_offset = l_table_node.getAttribute("offset")
            LET li_currRow = li_currRow - l_table_offset
         END IF
         #No.TQC-940011 ---end---
 
 
         #TQC-650108 by ray
         # 料件特性顯示輸入
#        DISPLAY lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
#                lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
#                lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
#                lr_att[10],lr_att_c[10]
#             TO att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#                att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#                att09,att09_c,att10,att10_c
         IF ps_type = '2' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_tsl[li_currRow].att01,s_tsl[li_currRow].att01_c,s_tsl[li_currRow].att02,s_tsl[li_currRow].att02_c,s_tsl[li_currRow].att03,s_tsl[li_currRow].att03_c,s_tsl[li_currRow].att04,s_tsl[li_currRow].att04_c,
               s_tsl[li_currRow].att05,s_tsl[li_currRow].att05_c,s_tsl[li_currRow].att06,s_tsl[li_currRow].att06_c,s_tsl[li_currRow].att07,s_tsl[li_currRow].att07_c,s_tsl[li_currRow].att08,s_tsl[li_currRow].att08_c,
               s_tsl[li_currRow].att09,s_tsl[li_currRow].att09_c,s_tsl[li_currRow].att10,s_tsl[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs CURSOR FROM ls_sql
               FOREACH param_curs INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '1' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_oeb[li_currRow].att01,s_oeb[li_currRow].att01_c,s_oeb[li_currRow].att02,s_oeb[li_currRow].att02_c,s_oeb[li_currRow].att03,s_oeb[li_currRow].att03_c,s_oeb[li_currRow].att04,s_oeb[li_currRow].att04_c,
               s_oeb[li_currRow].att05,s_oeb[li_currRow].att05_c,s_oeb[li_currRow].att06,s_oeb[li_currRow].att06_c,s_oeb[li_currRow].att07,s_oeb[li_currRow].att07_c,s_oeb[li_currRow].att08,s_oeb[li_currRow].att08_c,
               s_oeb[li_currRow].att09,s_oeb[li_currRow].att09_c,s_oeb[li_currRow].att10,s_oeb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs1 CURSOR FROM ls_sql
               FOREACH param_curs1 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '9' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_pnn[li_currRow].att01,s_pnn[li_currRow].att01_c,s_pnn[li_currRow].att02,s_pnn[li_currRow].att02_c,s_pnn[li_currRow].att03,s_pnn[li_currRow].att03_c,s_pnn[li_currRow].att04,s_pnn[li_currRow].att04_c,
               s_pnn[li_currRow].att05,s_pnn[li_currRow].att05_c,s_pnn[li_currRow].att06,s_pnn[li_currRow].att06_c,s_pnn[li_currRow].att07,s_pnn[li_currRow].att07_c,s_pnn[li_currRow].att08,s_pnn[li_currRow].att08_c,
               s_pnn[li_currRow].att09,s_pnn[li_currRow].att09_c,s_pnn[li_currRow].att10,s_pnn[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs9 CURSOR FROM ls_sql
               FOREACH param_curs9 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '4' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_inb[li_currRow].att01,s_inb[li_currRow].att01_c,s_inb[li_currRow].att02,s_inb[li_currRow].att02_c,s_inb[li_currRow].att03,s_inb[li_currRow].att03_c,s_inb[li_currRow].att04,s_inb[li_currRow].att04_c,
               s_inb[li_currRow].att05,s_inb[li_currRow].att05_c,s_inb[li_currRow].att06,s_inb[li_currRow].att06_c,s_inb[li_currRow].att07,s_inb[li_currRow].att07_c,s_inb[li_currRow].att08,s_inb[li_currRow].att08_c,
               s_inb[li_currRow].att09,s_inb[li_currRow].att09_c,s_inb[li_currRow].att10,s_inb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs4 CURSOR FROM ls_sql
               FOREACH param_curs4 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '5' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s1_ohb[li_currRow].att01,s1_ohb[li_currRow].att01_c,s1_ohb[li_currRow].att02,s1_ohb[li_currRow].att02_c,s1_ohb[li_currRow].att03,s1_ohb[li_currRow].att03_c,s1_ohb[li_currRow].att04,s1_ohb[li_currRow].att04_c,
               s1_ohb[li_currRow].att05,s1_ohb[li_currRow].att05_c,s1_ohb[li_currRow].att06,s1_ohb[li_currRow].att06_c,s1_ohb[li_currRow].att07,s1_ohb[li_currRow].att07_c,s1_ohb[li_currRow].att08,s1_ohb[li_currRow].att08_c,
               s1_ohb[li_currRow].att09,s1_ohb[li_currRow].att09_c,s1_ohb[li_currRow].att10,s1_ohb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs5 CURSOR FROM ls_sql
               FOREACH param_curs5 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '3' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_imn[li_currRow].att01,s_imn[li_currRow].att01_c,s_imn[li_currRow].att02,s_imn[li_currRow].att02_c,s_imn[li_currRow].att03,s_imn[li_currRow].att03_c,s_imn[li_currRow].att04,s_imn[li_currRow].att04_c,
               s_imn[li_currRow].att05,s_imn[li_currRow].att05_c,s_imn[li_currRow].att06,s_imn[li_currRow].att06_c,s_imn[li_currRow].att07,s_imn[li_currRow].att07_c,s_imn[li_currRow].att08,s_imn[li_currRow].att08_c,
               s_imn[li_currRow].att09,s_imn[li_currRow].att09_c,s_imn[li_currRow].att10,s_imn[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs2 CURSOR FROM ls_sql
               FOREACH param_curs2 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = '6' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_b1[li_currRow].att01,s_b1[li_currRow].att01_c,s_b1[li_currRow].att02,s_b1[li_currRow].att02_c,s_b1[li_currRow].att03,s_b1[li_currRow].att03_c,s_b1[li_currRow].att04,s_b1[li_currRow].att04_c,
               s_b1[li_currRow].att05,s_b1[li_currRow].att05_c,s_b1[li_currRow].att06,s_b1[li_currRow].att06_c,s_b1[li_currRow].att07,s_b1[li_currRow].att07_c,s_b1[li_currRow].att08,s_b1[li_currRow].att08_c,
               s_b1[li_currRow].att09,s_b1[li_currRow].att09_c,s_b1[li_currRow].att10,s_b1[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs6 CURSOR FROM ls_sql
               FOREACH param_curs6 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
#MOD-670007--begin
         IF ps_type = 'd' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_ogb[li_currRow].att01,s_ogb[li_currRow].att01_c,s_ogb[li_currRow].att02,s_ogb[li_currRow].att02_c,s_ogb[li_currRow].att03,s_ogb[li_currRow].att03_c,s_ogb[li_currRow].att04,s_ogb[li_currRow].att04_c,
               s_ogb[li_currRow].att05,s_ogb[li_currRow].att05_c,s_ogb[li_currRow].att06,s_ogb[li_currRow].att06_c,s_ogb[li_currRow].att07,s_ogb[li_currRow].att07_c,s_ogb[li_currRow].att08,s_ogb[li_currRow].att08_c,
               s_ogb[li_currRow].att09,s_ogb[li_currRow].att09_c,s_ogb[li_currRow].att10,s_ogb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_cursd CURSOR FROM ls_sql
               FOREACH param_cursd INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
#MOD-670007--end  
#FUN-650108--start
         IF ps_type = 'e' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s1_ohb[li_currRow].att01,s1_ohb[li_currRow].att01_c,s1_ohb[li_currRow].att02,s1_ohb[li_currRow].att02_c,s1_ohb[li_currRow].att03,s1_ohb[li_currRow].att03_c,s1_ohb[li_currRow].att04,s1_ohb[li_currRow].att04_c,
               s1_ohb[li_currRow].att05,s1_ohb[li_currRow].att05_c,s1_ohb[li_currRow].att06,s1_ohb[li_currRow].att06_c,s1_ohb[li_currRow].att07,s1_ohb[li_currRow].att07_c,s1_ohb[li_currRow].att08,s1_ohb[li_currRow].att08_c,
               s1_ohb[li_currRow].att09,s1_ohb[li_currRow].att09_c,s1_ohb[li_currRow].att10,s1_ohb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curse CURSOR FROM ls_sql
               FOREACH param_curse INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
#No.FUN-650108--en
#No.MOD-8A0098 --begin
         IF ps_type = 'f' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_rvv[li_currRow].att01,s_rvv[li_currRow].att01_c,s_rvv[li_currRow].att02,s_rvv[li_currRow].att02_c,s_rvv[li_currRow].att03,s_rvv[li_currRow].att03_c,s_rvv[li_currRow].att04,s_rvv[li_currRow].att04_c,
               s_rvv[li_currRow].att05,s_rvv[li_currRow].att05_c,s_rvv[li_currRow].att06,s_rvv[li_currRow].att06_c,s_rvv[li_currRow].att07,s_rvv[li_currRow].att07_c,s_rvv[li_currRow].att08,s_rvv[li_currRow].att08_c,
               s_rvv[li_currRow].att09,s_rvv[li_currRow].att09_c,s_rvv[li_currRow].att10,s_rvv[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_cursf CURSOR FROM ls_sql
               FOREACH param_cursf INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
         END INPUT
       END IF
#No.MOD-8A0098 --end
 
         IF ps_type = '7' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_tsh[li_currRow].att01,s_tsh[li_currRow].att01_c,s_tsh[li_currRow].att02,s_tsh[li_currRow].att02_c,s_tsh[li_currRow].att03,s_tsh[li_currRow].att03_c,s_tsh[li_currRow].att04,s_tsh[li_currRow].att04_c,
               s_tsh[li_currRow].att05,s_tsh[li_currRow].att05_c,s_tsh[li_currRow].att06,s_tsh[li_currRow].att06_c,s_tsh[li_currRow].att07,s_tsh[li_currRow].att07_c,s_tsh[li_currRow].att08,s_tsh[li_currRow].att08_c,
               s_tsh[li_currRow].att09,s_tsh[li_currRow].att09_c,s_tsh[li_currRow].att10,s_tsh[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs7 CURSOR FROM ls_sql
               FOREACH param_curs7 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
       IF ps_type = '8' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_ohb[li_currRow].att01,s_ohb[li_currRow].att01_c,s_ohb[li_currRow].att02,s_ohb[li_currRow].att02_c,s_ohb[li_currRow].att03,s_ohb[li_currRow].att03_c,s_ohb[li_currRow].att04,s_ohb[li_currRow].att04_c,
               s_ohb[li_currRow].att05,s_ohb[li_currRow].att05_c,s_ohb[li_currRow].att06,s_ohb[li_currRow].att06_c,s_ohb[li_currRow].att07,s_ohb[li_currRow].att07_c,s_ohb[li_currRow].att08,s_ohb[li_currRow].att08_c,
               s_ohb[li_currRow].att09,s_ohb[li_currRow].att09_c,s_ohb[li_currRow].att10,s_ohb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_curs8 CURSOR FROM ls_sql
               FOREACH param_curs8 INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = 'a' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_rvb[li_currRow].att01,s_rvb[li_currRow].att01_c,s_rvb[li_currRow].att02,s_rvb[li_currRow].att02_c,s_rvb[li_currRow].att03,s_rvb[li_currRow].att03_c,s_rvb[li_currRow].att04,s_rvb[li_currRow].att04_c,
               s_rvb[li_currRow].att05,s_rvb[li_currRow].att05_c,s_rvb[li_currRow].att06,s_rvb[li_currRow].att06_c,s_rvb[li_currRow].att07,s_rvb[li_currRow].att07_c,s_rvb[li_currRow].att08,s_rvb[li_currRow].att08_c,
               s_rvb[li_currRow].att09,s_rvb[li_currRow].att09_c,s_rvb[li_currRow].att10,s_rvb[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_cursa CURSOR FROM ls_sql
               FOREACH param_cursa INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = 'b' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_pmn[li_currRow].att01,s_pmn[li_currRow].att01_c,s_pmn[li_currRow].att02,s_pmn[li_currRow].att02_c,s_pmn[li_currRow].att03,s_pmn[li_currRow].att03_c,s_pmn[li_currRow].att04,s_pmn[li_currRow].att04_c,
               s_pmn[li_currRow].att05,s_pmn[li_currRow].att05_c,s_pmn[li_currRow].att06,s_pmn[li_currRow].att06_c,s_pmn[li_currRow].att07,s_pmn[li_currRow].att07_c,s_pmn[li_currRow].att08,s_pmn[li_currRow].att08_c,
               s_pmn[li_currRow].att09,s_pmn[li_currRow].att09_c,s_pmn[li_currRow].att10,s_pmn[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_cursb CURSOR FROM ls_sql
               FOREACH param_cursb INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
         IF ps_type = 'c' THEN
         INPUT lr_att[1],lr_att_c[1],lr_att[2],lr_att_c[2],lr_att[3],lr_att_c[3],
               lr_att[4],lr_att_c[4],lr_att[5],lr_att_c[5],lr_att[6],lr_att_c[6],
               lr_att[7],lr_att_c[7],lr_att[8],lr_att_c[8],lr_att[9],lr_att_c[9],
               lr_att[10],lr_att_c[10] WITHOUT DEFAULTS
#         FROM att01,att01_c,att02,att02_c,att03,att03_c,att04,att04_c,
#              att05,att05_c,att06,att06_c,att07,att07_c,att08,att08_c,
#              att09,att09_c,att10,att10_c
          FROM s_pml[li_currRow].att01,s_pml[li_currRow].att01_c,s_pml[li_currRow].att02,s_pml[li_currRow].att02_c,s_pml[li_currRow].att03,s_pml[li_currRow].att03_c,s_pml[li_currRow].att04,s_pml[li_currRow].att04_c,
               s_pml[li_currRow].att05,s_pml[li_currRow].att05_c,s_pml[li_currRow].att06,s_pml[li_currRow].att06_c,s_pml[li_currRow].att07,s_pml[li_currRow].att07_c,s_pml[li_currRow].att08,s_pml[li_currRow].att08_c,
               s_pml[li_currRow].att09,s_pml[li_currRow].att09_c,s_pml[li_currRow].att10,s_pml[li_currRow].att10_c
 
            AFTER FIELD att01
               IF lr_att[1] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att01")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att01)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att01
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[1] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[1] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att01
                        END IF
                     END IF
                  END FOR
                  LET ls_imx01 = lr_att[1]  #Add By Lifeng
               END IF
            AFTER FIELD att02
               IF lr_att[2] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att02")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att02)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att02
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[2] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[2] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att02
                        END IF
                     END IF
                  END FOR
                  LET ls_imx02 = lr_att[2]  #Add By Lifeng
               END IF
            AFTER FIELD att03
               IF lr_att[3] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att03")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att03)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att03
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[3] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[3] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att03
                        END IF
                     END IF
                  END FOR
                  LET ls_imx03 = lr_att[3]  #Add By Lifeng
               END IF
            AFTER FIELD att04
               IF lr_att[4] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att04")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att04)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att04
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[4] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[4] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att04
                        END IF
                     END IF
                  END FOR
                  LET ls_imx04 = lr_att[4]  #Add By Lifeng
               END IF
            AFTER FIELD att05
               IF lr_att[5] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att05")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att05)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att05
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[5] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[5] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att05
                        END IF
                     END IF
                  END FOR
                  LET ls_imx05 = lr_att[5]  #Add By Lifeng
               END IF
            AFTER FIELD att06
               IF lr_att[6] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att06")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att06)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att06
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[6] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[6] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att06
                        END IF
                     END IF
                  END FOR
                  LET ls_imx06 = lr_att[6]  #Add By Lifeng
               END IF
            AFTER FIELD att07
               IF lr_att[7] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att07")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att07)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att07
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[7] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[7] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att07
                        END IF
                     END IF
                  END FOR
                  LET ls_imx07 = lr_att[7]  #Add By Lifeng
               END IF
            AFTER FIELD att08
               IF lr_att[8] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att08")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att08)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att08
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[8] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[8] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att08
                        END IF
                     END IF
                  END FOR
                  LET ls_imx08 = lr_att[8]  #Add By Lifeng
               END IF
            AFTER FIELD att09
               IF lr_att[9] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att09")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att09)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att09
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[9] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[9] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att09
                        END IF
                     END IF
                  END FOR
                  LET ls_imx09 = lr_att[9]  #Add By Lifeng
               END IF
            AFTER FIELD att10
               IF lr_att[10] IS NOT NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.att10")
                  LET ls_item_text = lnode_item.getAttribute("text")
                  FOR li_i = 1 TO lr_agc.getLength()
                     IF ls_item_text.equals(lr_agc[li_i].agc02) THEN
                        #Add By Lifeng Start, 增加對長度與定義使用位數是否相等的判斷
                        IF LENGTH(GET_FLDBUF(att10)) <> lr_agc[li_i].agc03 THEN
                           CALL cl_err_msg("","aim-911",lr_agc[li_i].agc03,1)
                           NEXT FIELD att10
                        END IF
                        #Add By Lifeng End
                        LET li_min_num = lr_agc[li_i].agc05
                        LET li_max_num = lr_agc[li_i].agc06
                        IF (lr_agc[li_i].agc05 IS NOT NULL) AND
                           (lr_att[10] < li_min_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                        IF (lr_agc[li_i].agc06 IS NOT NULL) AND
                           (lr_att[10] > li_max_num) THEN
                           CALL cl_err_msg("","lib-232",lr_agc[li_i].agc05 || "|" || lr_agc[li_i].agc06,1)
                           NEXT FIELD att10
                        END IF
                     END IF
                  END FOR
                  LET ls_imx10 = lr_att[10]  #Add By Lifeng
               END IF
 
            #Add By Lifeng Start
            AFTER FIELD att01_c
               IF lr_att_c[1] IS NOT NULL THEN
                  LET ls_imx01 = lr_att_c[1]
               END IF 
 
            AFTER FIELD att02_c
               IF lr_att_c[2] IS NOT NULL THEN
                  LET ls_imx02 = lr_att_c[2]
               END IF 
 
            AFTER FIELD att03_c
               IF lr_att_c[3] IS NOT NULL THEN
                  LET ls_imx03 = lr_att_c[3]
               END IF
               
            AFTER FIELD att04_c
               IF lr_att_c[4] IS NOT NULL THEN
                  LET ls_imx04 = lr_att_c[4]
               END IF
 
            AFTER FIELD att05_c
               IF lr_att_c[5] IS NOT NULL THEN
                  LET ls_imx05 = lr_att_c[5]
               END IF
                
            AFTER FIELD att06_c
               IF lr_att_c[6] IS NOT NULL THEN
                  LET ls_imx06 = lr_att_c[6]
               END IF
 
            AFTER FIELD att07_c
               IF lr_att_c[7] IS NOT NULL THEN
                  LET ls_imx07 = lr_att_c[7]
               END IF
 
            AFTER FIELD att08_c
               IF lr_att_c[8] IS NOT NULL THEN
                  LET ls_imx08 = lr_att_c[8]
               END IF
 
            AFTER FIELD att09_c
               IF lr_att_c[9] IS NOT NULL THEN
                  LET ls_imx09 = lr_att_c[9]
               END IF
 
            AFTER FIELD att10_c
               IF lr_att_c[10] IS NOT NULL THEN
                  LET ls_imx10 = lr_att_c[10]
               END IF
            #Add By Lifeng End
 
            AFTER INPUT
               LET ls_value = ls_item_p
#               LET lc_aga01 = ls_value
#               SELECT aga02 INTO lc_aga02 FROM aga_file
#                WHERE aga01 = lc_aga01
               LET ps_value_tmp = ps_value
               SELECT ima02 INTO ls_name FROM ima_file 
                 WHERE ima01 = ps_value_tmp
               LET ls_spec = ls_name
               FOR li_i = 1 TO li_col_count
                   LET lc_agd03 = ""
                   IF lr_att[li_i] IS NOT NULL THEN
                      LET ls_value = ls_value.trim(),l_ps,lr_att[li_i]
                      LET lc_agd02 = lr_att[li_i]
                      SELECT agd03 INTO lc_agd03 FROM agd_file
                       WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                      IF cl_null(lc_agd03) THEN
                         LET ls_spec = ls_spec.trim(),l_ps,lr_att[li_i]
                      ELSE
                         LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                      END IF
                   ELSE
                      IF lr_att_c[li_i] IS NOT NULL THEN
                         LET ls_value = ls_value.trim(),l_ps,lr_att_c[li_i]
                         LET lc_agd02 = lr_att_c[li_i]
                         SELECT agd03 INTO lc_agd03 FROM agd_file
                          WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = lc_agd02
                         IF cl_null(lc_agd03) THEN
                            LET ls_spec = ls_spec.trim(),l_ps,lr_att_c[li_i]
                         ELSE
                            LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
                         END IF
                      END IF
                   END IF
                  # display 'ls_spec=',ls_spec
               END FOR
               FOR li_i = 1 TO li_col_count
                  LET lc_index = li_i USING '&&'
                  CALL cl_set_comp_visible("att" || lc_index,FALSE)
                  CALL cl_set_comp_visible("att" || lc_index || "_c",FALSE)
               END FOR
               
               #Add By Lifeng Start
               #先解析ls_value生成要傳給cl_copy_bom的那個l_param_list
               LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
               LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
 
               LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                            "ima01 = '",ps_value CLIPPED,"' AND agb01 = imaag ",
                            "ORDER BY agb02"  
               DECLARE param_cursc CURSOR FROM ls_sql
               FOREACH param_cursc INTO l_agb03
                 #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
                 IF cl_null(l_param_list) THEN
                    LET l_param_list = '#',l_agb03,'#|',l_str_tok.nextToken()
                 ELSE
                    LET l_param_list = l_param_list,'|#',l_agb03,'#|',l_str_tok.nextToken()
                 END IF
               END FOREACH
 
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
       END IF
       #TQC-650108 --end
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET ls_value = ps_value
         #No.TQC-5A0001 --start--
         #避免在選擇多屬性料件時，按取消還會出現內部的訊息
         ELSE
            IF ps_type = '1' THEN    #TQC-650108 By Ray
               IF g_sma.sma908 <> 'Y' THEN                            
                  LET g_value = ls_value                                                                     
                  SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value                                                               
                  IF l_n=0 THEN                                                                                                            
                     CALL cl_err(g_value,'ams-003',1)                                                                                      
                     RETURN '0',ls_value,ls_spec  #No.TQC-650108 新增返回參數'0'                                                 
                  END IF                                                                                                                   
               END IF
               #向ima_file中插入新生成的料件記錄
               IF cl_copy_ima(ps_value,ls_value,ls_spec,l_param_list) = TRUE THEN
                  LET ls_value_tmp = ls_value
                  #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
                  LET ls_parent = ps_value  #No.FUN-640013
                  INSERT INTO imx_file VALUES(ls_value_tmp,ls_parent,ls_imx01,ls_imx02,ls_imx03,
                    ls_imx04,ls_imx05,ls_imx06,ls_imx07,ls_imx08,ls_imx09,
                    ls_imx10)  #No.FUN-640013
                  #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                  #記錄的完全同步
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('Failure to insert imx_file , rollback insert to ima_file !','',1)
                     DELETE FROM ima_file WHERE ima01 = ls_value_tmp
                     #No.FUN-7B0018 080304 add --begin
                     #No.FUN-830132 080327 mod --begin
#                    IF NOT s_industry('std') THEN
                     IF s_industry('icd') THEN
                     #No.FUN-830132 080327 mod --end
                        LET l_flag = s_del_imaicd(ls_value_tmp,'')
                     END IF
                     #No.FUN-7B0018 080304 add --end
                  END IF
               #No.TQC-5A0001 --start--
#No.TQC-5C0115 --start--
#              ELSE
#                 LET ls_value = ps_value
#No.TQC-5C0115 --end--
               #No.TQC-5A0001 ---end---
               END IF
         #TQC-650108 By Ray
            ELSE 
               LET ls_value_tmp = ls_value
#使用多屬性時，過料件編號，只要料號存在，母料號也可過
             IF g_sma.sma120 = 'N' THEN                 #No.FUN-830086
               SELECT COUNT(*) INTO l_n FROM ima_file                                                                                       
                WHERE ima01 = ls_value_tmp                                                                                                       
               IF l_n > 0 THEN 
                  SELECT imaag INTO l_imaag1 FROM ima_file WHERE ima01 = ls_value_tmp
                  IF l_imaag1 != "@CHILD" THEN                                                                                                   
                     CALL cl_err(ls_value_tmp,"lib-304",1)                                                                                      
                  END IF                                                                                                                         
     #No.TQC-5A0001 ---end---                                                                                                       
               END IF   
             END IF                                     #No.FUN-830086
#No.FUN-830086--END--
               #Add By Lifeng End
#No.TQC-7C0024 --begin
               SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = ls_value_tmp
               IF l_n =0 THEN
                  CALL cl_err(g_value,'ams-003',1)                                                                                      
                  RETURN '0',ls_value,ls_spec  
               END IF
#No.TQC-7C0024 --end
            END IF
         #No.TQC-5A0001 ---end---
         END IF
         #TQC-650108 --end
   END CASE
 
   RETURN '1',ls_value,ls_spec  #No.TQC-650108 新增返回參數'1'
END FUNCTION
 
#--Add By Lifeng Start-----------------------------------------------------
 
# Descriptions...: 該函數用于按照一個父料件信息復制一個子料件信息，復制規則為︰料件編號,
#                  品名和為傳入值（由上游函數合成），是否多屬性管理欄位imaag為@CHILD表示不
#                  進行多屬性管理、imaag1欄位為所屬的屬性組，其他欄位均帶出父料件中的內容
#                  該函數會自動檢查在料件信息表ima_file中是否已經存在相同料號的料件，如果
#                  存在則不進行復制操作
#                  如果操作成功，則返回1，否則返回0
# Input Parameter: p_parent,p_child_ima01,p_child_ima02,p_param_list
# Return Code....: 如果操作成功，則返回1，否則返回0
 
FUNCTION cl_copy_ima(p_parent,p_child_ima01,p_child_ima02,p_param_list)
DEFINE
  p_parent       LIKE ima_file.ima01,
  p_child_ima01  LIKE ima_file.ima01,
  p_child_ima02  LIKE ima_file.ima02,
  p_param_list   STRING,    #用于復制BOM時使用的參數字符串,這里的格式為
                            #'屬性名|屬性值|屬性名|屬性值'
 
  l_result       LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_result_bom   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  l_count,li_i   LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  s_ima  RECORD  LIKE ima_file.*,
  s_smd  RECORD  LIKE smd_file.*,
  lc_imaag       LIKE ima_file.imaag
DEFINE l_imaicd  RECORD LIKE imaicd_file.*   #No.FUN-7B0018
#No.MOD-890210 --begin                                                          
DEFINE ls_docNum              STRING                                            
DEFINE ls_time                STRING                                            
DEFINE l_gca01                LIKE gca_file.gca01                               
DEFINE l_gca07                LIKE gca_file.gca07                               
DEFINE l_gca08                LIKE gca_file.gca08                               
DEFINE l_gca09                LIKE gca_file.gca09                               
DEFINE l_gca10                LIKE gca_file.gca10               
#No.MOD-890210 --end                              
 
 
 
  WHENEVER ERROR CONTINUE              #忽略一切錯誤    #No.MOD-890210  
  #檢查相同料號是否已經存在于ima_file中
  SELECT COUNT(*) INTO l_result FROM ima_file
  WHERE ima01 = p_child_ima01
  IF l_result > 0 THEN
     #No.TQC-5A0001 --start--
     SELECT imaag INTO lc_imaag FROM ima_file WHERE ima01 = p_child_ima01
     IF lc_imaag != "@CHILD" THEN
        CALL cl_err(p_child_ima01,"lib-304",1)
     END IF
     #No.TQC-5A0001 ---end---
     LET l_result = 0
     RETURN l_result  #如果已經存在則直接退出并返回0
  ELSE
    LET l_result = 1
  END IF

#No.MOD-890210 --begin   #No.MOD-A80027 
  DROP TABLE x                                                                  
  DROP TABLE y                                                                  
  LET l_gca01 ='ima01=',p_parent CLIPPED                                        
  SELECT * FROM gca_file WHERE gca01 =l_gca01 INTO TEMP x                       
  SELECT gca07,gca08,gca09,gca10 INTO l_gca07,l_gca08,l_gca09,l_gca10 FROM gca_file
   WHERE gca01 =l_gca01                                                         
  SELECT * FROM gcb_file                                                        
   WHERE gcb01 = l_gca07                                                        
     AND gcb02 = l_gca08                                                        
     AND gcb03 = l_gca09                                                        
     AND gcb04 = l_gca10                                                        
    INTO TEMP y                                                                 
  LET l_gca01 ='ima01=',p_child_ima01 CLIPPED                                   
  LET ls_time = TIME                                                            
  LET ls_docNum = "FLD-",                                                       
                   FGL_GETPID() USING "<<<<<<<<<<", "-",                        
                   TODAY USING "YYYYMMDD", "-",                                 
                   ls_time.subString(1,2), ls_time.subString(4,5),ls_time.subString(7,8)
  LET l_gca07 =ls_docNum                                                        
  UPDATE x SET gca01 =l_gca01,                                                  
               gca07 =l_gca07,                                                  
               gca11 ='Y',     
               gca12 =g_user,                                                   
               gca13 =g_grup,                                                   
               gca14 =g_today                                                   
  INSERT INTO gca_file SELECT * FROM x                                          
  UPDATE y SET gcb01 =l_gca07,                                                  
               gcb13 =g_user,                                                   
               gcb14 =g_grup,                                                   
               gcb15 =g_today                                                   
  INSERT INTO gcb_file SELECT * FROM y                                          
                                                                                
#No.MOD-890210 --end

  #復制父料件信息到中間變量中
  SELECT * INTO s_ima.* FROM ima_file WHERE ima01 = p_parent;
  #更改其中部分欄位內容
  LET s_ima.ima01 = p_child_ima01
  LET s_ima.ima02 = p_child_ima02
  LET s_ima.imaag1 = s_ima.imaag
  LET s_ima.imaag = '@CHILD'
  #以下這些代碼是從aimi100中的i100_copy函數中copy來的，到INSERT語句之前為止
  LET s_ima.ima05  =NULL      #目前使用版本
# LET s_ima.ima18  =0
# LET s_ima.ima16  =99         #NO:6973
  LET s_ima.ima26  =0         #MPS/MRP可用庫存數量
  LET s_ima.ima261 =0         #不可用庫存數量
  LET s_ima.ima262 =0         #庫存可用數量
  LET s_ima.ima29  =NULL      #最近易動日期
  LET s_ima.ima30  =NULL      #最近盤點日期
# LET s_ima.ima32  =0         #標准售價
  LET s_ima.ima33  =0         #最近售價
  LET s_ima.ima40  =0         #累計使用數量 期間
  LET s_ima.ima41  =0         #累計使用數量 年度
# LET s_ima.ima47  =0         #采購損耗率
  LET s_ima.ima52  =1         #平均訂購量
# LET s_ima.ima140 ='N'       #phase out  
  LET s_ima.ima53  =0         #最近采購單價
# LET s_ima.ima531 =0         #市價
  LET s_ima.ima532 =NULL      #市價最近異動日期
# LET s_ima.ima562 =0         #生產損耗率
  LET s_ima.ima73  =NULL      #最近入庫日期
  LET s_ima.ima74  =NULL      #最近出庫日期
# LET s_ima.ima75  =''        #海關編號
# LET s_ima.ima76  =''        #商品類別
# LET s_ima.ima77  =0         #在途量   
# LET s_ima.ima78  =0         #在驗量   
# LET s_ima.ima79  =0         #缺料量   
# LET s_ima.ima80  =0         #未耗預測量   
# LET s_ima.ima81  =0         #確認生產量   
# LET s_ima.ima82  =0         #計划量   
# LET s_ima.ima83  =0         #MRP需求量   
# LET s_ima.ima84  =0         #OM 銷單備置量   
# LET s_ima.ima85  =0         #MFP銷單備置量
  LET s_ima.ima881 =NULL      #期間采購最近采購日期 
  LET s_ima.ima91  =0         #平均采購單價
  LET s_ima.ima92  ='N'       #net change status
  LET s_ima.ima93  ='NNNNNNNN'#new parts status
# LET s_ima.ima94  =''        #
# LET s_ima.ima95  =0         #
# LET s_ima.ima96  =0         #A. T. P. 量
# LET s_ima.ima97  =0         #MFG 接單量
# LET s_ima.ima98  =0         #OM 接單量
# LET s_ima.ima100 ='N'
# LET s_ima.ima101 ='1'
# LET s_ima.ima102 ='1'
# LET s_ima.ima104 =0         #廠商分配起始量
  LET s_ima.ima901 = g_today  #料件建檔日期
  LET s_ima.ima902 = NULL     #NO:6973
# LET s_ima.ima121 = 0        #單位材料成本
# LET s_ima.ima122 = 0        #單位人工成本
# LET s_ima.ima123 = 0        #單位制造費用
# LET s_ima.ima124 = 0        #單位管銷成本
# LET s_ima.ima125 = 0        #單位成本
# LET s_ima.ima126 = 0        #單位利潤率
# LET s_ima.ima127 = 0        #未稅訂價(本幣)
# LET s_ima.ima128 = 0        #含稅訂價(本幣)
# LET s_ima.ima131 = ' '      #產品分類編號  #NO:6783
# LET s_ima.ima132 = NULL     #費用科目編號
# LET s_ima.ima133 = NULL     #產品預測料號
# LET s_ima.ima134 = NULL     #主要包裝方式編號
# LET s_ima.ima135 = NULL     #產品條碼編號
# LET s_ima.ima139 = 'N'    
  LET s_ima.ima151 = 'N'      #No.FUN-840036
  LET s_ima.imauser=g_user    #資料所有者
  LET s_ima.imagrup=g_grup    #資料所有者所屬群
  LET s_ima.imamodu=NULL      #資料修改日期
  LET s_ima.imadate=g_today   #資料建立日期
  LET s_ima.imaacti='Y'       #有效資料
  IF s_ima.ima06 IS NULL THEN
#    LET s_ima.ima871 =0         #間接物料分攤率   
#    LET s_ima.ima872 =''        #材料制造費用成本項目   
#    LET s_ima.ima873 =0         #間接人工分攤率   
#    LET s_ima.ima874 =''        #人工制造費用成本項目   
#    LET s_ima.ima88  =0         #期間采購數量   
#    LET s_ima.ima89  =0         #期間采購使用的期間(月)
#    LET s_ima.ima90  =0         #期間采購使用的期間(日)
  END IF
  IF s_ima.ima01[1,4]='MISC' THEN LET s_ima.ima08='Z' END IF
  IF s_ima.ima35 is null then let s_ima.ima35=' ' end if
  IF s_ima.ima36 is null then let s_ima.ima36=' ' end if
  IF cl_null(s_ima.ima903) THEN LET s_ima.ima903 = 'N' END IF
  IF cl_null(s_ima.ima905) THEN LET s_ima.ima905 = 'N' END IF
  IF cl_null(s_ima.ima910) THEN LET s_ima.ima910 = ' ' END IF 
  IF cl_null(s_ima.ima156) THEN LET s_ima.ima156 = 'N' END IF     #FUN-A80150 add  
  IF cl_null(s_ima.ima158) THEN LET s_ima.ima158 = 'N' END IF     #FUN-A80150 add
  IF cl_null(s_ima.ima159) THEN LET s_ima.ima159 = '3' END IF     #FUN-C20065 add
  IF cl_null(s_ima.ima928) THEN LET s_ima.ima928 = 'N' END IF      #TQC-C20131  add  
  #將新的料件信息插回到ima_file中去
  INSERT INTO ima_file VALUES(s_ima.*) 
  IF SQLCA.sqlcode THEN
     LET l_result = 0  #記錄可能有的錯誤
  ELSE 
     #No.FUN-7B0018 080304 add --begin
     #No.FUN-830132 080327 mod --begin
#    IF NOT s_industry('std') THEN
     IF s_industry('icd') THEN
     #No.FUN-830132 080327 mod --end
        INITIALIZE l_imaicd.* TO NULL
        LET l_imaicd.imaicd00 = s_ima.ima01
        IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
           LET l_result = 0
        END IF
     END IF
     #No.FUN-7B0018 080304 add --end  
     LET l_result = 1
  END IF 
 
  #復制料件的單位轉換率信息
  DECLARE smd_cur CURSOR FOR        
    SELECT * FROM smd_file WHERE smd01=p_parent
  FOREACH smd_cur INTO s_smd.*      
    LET s_smd.smd01 = p_child_ima01
    INSERT INTO smd_file VALUES(s_smd.*)   
    IF SQLCA.SQLCODE THEN
       CALL cl_err('ins smd:',SQLCA.SQLCODE,0)      
    ELSE        
       MESSAGE 'INSERT smd...'    
    END IF      
  END FOREACH
  IF g_sma.sma909 = 'Y' THEN  #FUN-C30006
     #復制料件可能有的BOM信息
     SELECT COUNT(*) INTO l_count FROM bma_file WHERE bma01 = p_parent
     IF l_count > 0 THEN
        CALL cl_copy_bom(p_child_ima01,p_parent,p_param_list) RETURNING l_result_bom
        IF NOT l_result_bom THEN
           CALL cl_err(p_child_ima01,'lib-298',0)  #如果復制BOM錯誤僅提出警告
        END IF
     END IF
  END IF  #FUN-C30006
  RETURN l_result
 
END FUNCTION
 
# Descriptions...: 顯示一個獨立的Form來完成多屬性料號機制中子料號的插入工作
#                  返回生成的子料件的料號和名稱
# Input Parameter: p_ima01,p_ima02
# Return Code....:
 
FUNCTION cl_show_itemno_multi_att(p_ima01,p_ima02)
DEFINE 
  p_ima01  LIKE ima_file.ima01,
  p_ima02  LIKE ima_file.ima02,
  ls_ima01 LIKE ima_file.ima01,
  ls_ima02 LIKE ima_file.ima02,
 
  p_col,p_row LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  li_i        LIKE type_file.num5,    #No.FUN-690005 SMALLINT,
  lc_i        LIKE type_file.chr2,    #No.FUN-690005 VARCHAR(02),
  l_check     LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)  #No.TQC-650108 
 
  #先判斷當前料號是否進行多屬性管理,如果要進行則顯示下面的操作否則什么都不做
  IF NOT cl_is_multi_feature_manage(p_ima01) THEN
     RETURN p_ima01,p_ima02
  END IF
 
  LET p_row = 2 LET p_col = 2
  OPEN WINDOW itemno_multi_w AT p_row,p_col WITH FORM "lib/42f/cl_itemno_multi_att"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_init()
 
  FOR li_i = 1 TO 10
      LET lc_i = li_i USING '&&'
      CALL cl_set_comp_visible("att" || lc_i , FALSE)
      CALL cl_set_comp_visible("att" || lc_i || "_c" , FALSE)
  END FOR
 
  #賦初始值
  SELECT ima02 INTO ls_ima02 FROM ima_file WHERE ima01 = p_ima01
  DISPLAY p_ima01 TO FORMONLY.ima01_p
  DISPLAY ls_ima02 TO FORMONLY.ima02_p
 
  CALL cl_itemno_multi_att(' ',p_ima01,p_ima02,'0','1') RETURNING l_check,ls_ima01,ls_ima02  #No.TQC-650108 新增返回參數l_check
 
  CLOSE WINDOW itemno_multi_w
  RETURN ls_ima01,ls_ima02
 
END FUNCTION
 
# Descriptions...: 本函數按照母料件的BOM結構，結合可能有的屬性信息來計算用量或種類以
#                  生成子料件的BOM信息，傳入的參數分別為母料件編號(p_old)，子料件編號
#                  (p_new)以及屬性列表(p_prop_list)，其中屬性列表是以"屬性名|屬性值"
#                  格式傳遞的
#                  該函數參考于abmi600作業中的copy()函數，除了對bma_file和bmb_file兩個
#                  基本表進行復制之外，還對可能有的bmc_file,bmd_file,bml_file和bmt_file
#                  中的記錄進行復制
#                  該函數調用了cl_formula.4gl中的cl_fml_run()函數來解析表中可能出現的公式
#                  目前暫時不支持對單身附加資料bmc_file等進行公式替換
# Input Parameter: p_new,p_old,p_param_list
# Return Code....:
 
FUNCTION cl_copy_bom(p_new,p_old,p_param_list)   
DEFINE 
  p_new,p_old          LIKE bma_file.bma01,
  p_param_list         STRING,
  p_bmb03              LIKE bmb_file.bmb03,              #TQC-650035
  l_bmb30              LIKE bmb_file.bmb30,              #TQC-650035
  l_bma                RECORD LIKE bma_file.*,
  l_bmb                RECORD LIKE bmb_file.*,
  l_bmc	               RECORD LIKE bmc_file.*,
  l_bmd                RECORD LIKE bmd_file.*,
  l_bml                RECORD LIKE bml_file.*,
  l_bmt                RECORD LIKE bmt_file.*,
  l_sql                LIKE type_file.chr1000,  #No.FUN-690005 VARCHAR(400),
  l_formula            STRING,
  l_bmb03              STRING,
  l_res_str            STRING,
  l_res_int            LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
  #No.FUN-840036--begin--
  IF s_industry('slk') THEN 
#    CALL cl_err('','lib-060',0)                
     RETURN TRUE 
  END IF    
  #No.FUN-840036--end--
  WHENEVER ERROR CONTINUE              #忽略一切錯誤    #TQC-650070
  #BEGIN WORK 
  #------------------- COPY BODY (bmc_file) ------------------------------
 
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bmc_file WHERE bmc01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL cl_err('del bmc: ',SQLCA.SQLCODE,1)
     RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
  #復制說明資料 bmc_file
  LET l_sql = " SELECT bmc_file.* FROM bmc_file,bmb_file ",
              " WHERE bmb01 = bmc01 ",  
              " AND   bmb29 = bmc06 ",
              " AND bmb02 = bmc02   ",
              " AND bmb03 = bmc021  ",
              " AND bmb04 = bmc03   ",
              " AND bmb01=  '",p_old,"'",
              #" AND bmb29=  '",old_bma06,"'",  #不考慮該鍵值（特性代碼）的區別，全部復制
              " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"  #不考慮生效日期，只要求失效日期大于當前日期
  
  PREPARE i600_pbmc FROM l_sql 
  DECLARE i600_cbmc CURSOR FOR i600_pbmc
  FOREACH i600_cbmc INTO l_bmc.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bmc:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
  
    #bmc_file中可能需要公式替換的欄位(bmc021元件料號)
    CALL cl_fml_run(l_bmc.bmc021,p_param_list) RETURNING l_res_str,l_res_int
#No.TQC-650035--begin
    SELECT tmp_bmb03 INTO p_bmb03 FROM tmp_file
     WHERE tmp_bmb02 =l_bmt.bmt02
    IF NOT cl_null(p_bmb03) AND (p_bmb03 !=l_res_str) THEN
       LET l_res_str =p_bmb03
    END IF
#No.TQC-650035--end
    IF l_res_int THEN LET l_bmc.bmc021 = l_res_str  END IF 
    LET l_bmc.bmc01 = p_new
    
    #如果完成公式替換后的元件料號有值才進行復制
    IF LENGTH(l_bmc.bmc021) > 0 THEN
       INSERT INTO bmc_file VALUES(l_bmc.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err('ins bmc: ',SQLCA.SQLCODE,1)
          #ROLLBACK WORK
          RETURN FALSE
       END IF
    END IF
  END FOREACH
 
  #------------------- COPY BODY (bmt_file) ------------------------------
 
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bmt_file WHERE bmt01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL cl_err('del bmt: ',SQLCA.SQLCODE,1)
     RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
  #復制插件位置
  LET l_sql = " SELECT bmb30,bmt_file.* FROM bmt_file,bmb_file ",
              " WHERE bmb01 = bmt01 ",    #主件 
              " AND bmb29 = bmt08   ",    #FUN-550014 add
              " AND bmb02 = bmt02   ",    #項次
              " AND bmb03 = bmt03   ",    #元件
              " AND bmb04 = bmt04   ",    #生效日
              " AND bmb01=  '",p_old,"'",
              #" AND bmb29=  '",old_bma06,"'",  #不考慮該鍵值（特性代碼）的區別，全部復制
              " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"  #不考慮生效日期，只要求失效日期大于當前日期
              
  PREPARE i600_pbmt FROM l_sql 
  DECLARE i600_cbmt CURSOR FOR i600_pbmt
  FOREACH i600_cbmt INTO l_bmb30,l_bmt.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bmt:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
    
    #bmt_file中可能需要公式替換的欄位(bmt03元件料號,bmt07插件用量)
    IF l_bmb30 ='3' THEN
       LET l_bmt.bmt03 = "&",l_bmt.bmt03 CLIPPED,"-1&"
    END IF
    CALL cl_fml_run(l_bmt.bmt03,p_param_list) RETURNING l_res_str,l_res_int
#No.TQC-650035--begin
    SELECT tmp_bmb03 INTO p_bmb03 FROM tmp_file
     WHERE tmp_bmb02 =l_bmt.bmt02
    IF NOT cl_null(p_bmb03) AND (p_bmb03 !=l_res_str) THEN
       LET l_res_str =p_bmb03
    END IF
#No.TQC-650035--end
    IF l_res_int THEN  LET l_bmt.bmt03 = l_res_str END IF
{   CALL cl_fml_run(l_bmt.bmt07,p_param_list) RETURNING l_res_str,l_res_int
    IF l_res_int THEN LET l_bmt.bmt07 = l_res_str  END IF }
    LET l_bmt.bmt01 = p_new
    
    #如果完成公式替換后的元件料號有值才進行復制
    IF LENGTH(l_bmt.bmt03) > 0 THEN
       #CHI-790004..................begin
       IF cl_null(l_bmt.bmt02) THEN
          LET l_bmt.bmt02=0
       END IF
       #CHI-790004..................end
       INSERT INTO bmt_file VALUES(l_bmt.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err('ins bmt: ',SQLCA.SQLCODE,1)
          #ROLLBACK WORK
          RETURN FALSE
       END IF
    END IF
  END FOREACH
 
  #------------------- COPY BODY (bml_file) ------------------------------
 
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bml_file WHERE bml01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL cl_err('del bml: ',SQLCA.SQLCODE,1)
     RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
  #復制元件廠牌資料
  LET l_sql = " SELECT UNIQUE bml_file.* FROM bml_file,bmb_file ",
              " WHERE bmb01 = bml02 ",     
              " AND bmb03 = bml01 ",
              " AND bmb01= '",p_old,"'",
              " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"  #不考慮生效日期，只要求失效日期大于當前日期
              
  PREPARE i600_pbml FROM l_sql
  DECLARE i600_cbml CURSOR FOR i600_pbml
  FOREACH i600_cbml INTO l_bml.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bml:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
    
    #bml_file中可能需要公式替換的欄位(bml01元件料號)
    CALL cl_fml_run(l_bml.bml01,p_param_list) RETURNING l_res_str,l_res_int
#No.TQC-650035--begin
    SELECT tmp_bmb03 INTO p_bmb03 FROM tmp_file
     WHERE tmp_bmb02 =l_bmt.bmt02
    IF NOT cl_null(p_bmb03) AND (p_bmb03 !=l_res_str) THEN
       LET l_res_str =p_bmb03
    END IF
#No.TQC-650035--end
    IF l_res_int THEN LET l_bml.bml01 = l_res_str  END IF  
    LET l_bml.bml02 = p_new
    
    #如果完成公式替換后的元件料號有值才進行復制
    IF LENGTH(l_bml.bml01) > 0 THEN
       INSERT INTO bml_file VALUES(l_bml.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err('ins bml: ',SQLCA.SQLCODE,1)
          #ROLLBACK WORK
          RETURN FALSE
       END IF
    END IF
  END FOREACH
   
  #----------------- COPY (bmd_file) NO:0587 add in 99/10/01 By Kammy--
 
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bmd_file WHERE bmd01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('del bmd: ',SQLCA.SQLCODE,1)
      RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
 #復制取替代件
  LET l_sql = " SELECT bmd_file.* FROM bmd_file,bmb_file ",
              " WHERE bmb01 = bmd08 ",     
              "   AND bmb03 = bmd01 ",
              "   AND bmb01= '",p_old,"'",
              "   AND bmdacti = 'Y'",                                           #CHI-910021
              " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"  #不考慮生效日期，只要求失效日期大于當前日期
              
  PREPARE i600_pbmd FROM l_sql 
  DECLARE i600_cbmd CURSOR FOR i600_pbmd
  FOREACH i600_cbmd INTO l_bmd.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bmd:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
    
    #bmd_file中可能需要公式替換的欄位(bmd01原元件料號,bmd04替代料編號和bmd07替代量)
    CALL cl_fml_run(l_bmd.bmd01,p_param_list) RETURNING l_res_str,l_res_int
#No.TQC-650035--begin
    SELECT tmp_bmb03 INTO p_bmb03 FROM tmp_file
     WHERE tmp_bmb02 =l_bmt.bmt02
    IF NOT cl_null(p_bmb03) AND (p_bmb03 !=l_res_str) THEN
       LET l_res_str =p_bmb03
    END IF
#No.TQC-650035--end
{    IF l_res_int THEN LET l_bmd.bmd01 = l_res_str  END IF
    CALL cl_fml_run(l_bmd.bmd04,p_param_list) RETURNING l_res_str,l_res_int
    IF l_res_int THEN LET l_bmd.bmd04 = l_res_str  END IF
    CALL cl_fml_run(l_bmd.bmd07,p_param_list) RETURNING l_res_str,l_res_int
    IF l_res_int THEN LET l_bmd.bmd07 = l_res_str  END IF   }
    LET l_bmd.bmd08 = p_new
    IF cl_null(l_bmd.bmd11) THEN LET l_bmd.bmd11 = 'N' END IF      #TQC-C20131  add
    #如果完成公式替換后的原元件料號/新元件料號都有值才進行復制
    IF (( LENGTH(l_bmd.bmd01) > 0 )AND( LENGTH(l_bmd.bmd04) > 0 )) THEN
       INSERT INTO bmd_file VALUES(l_bmd.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err('ins bmd: ',SQLCA.SQLCODE,1)
          #ROLLBACK WORK
          RETURN FALSE
       END IF
    END IF
  END FOREACH
  
  #------------------- COPY HEAD (bma_file) ------------------------------
  
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bma_file WHERE bma01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL cl_err('del bma: ',SQLCA.SQLCODE,1)
     RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
  DECLARE i600_cbma CURSOR FOR 
    SELECT * FROM bma_file 
    WHERE bma01=p_old 
     #AND bma06=old_bma06 #這里不考慮特性
  
  FOREACH i600_cbma INTO l_bma.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bma:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
    
    LET l_bma.bma01=p_new       #新的鍵值
    #LET l_bma.bma06=new_bma06   #這里不考慮特性
    LET l_bma.bma05=NULL        #發放日
    LET l_bma.bmauser=g_user    #資料所有者
    LET l_bma.bmagrup=g_grup    #資料所有者所屬群
    LET l_bma.bmamodu=NULL      #資料修改日期
    LET l_bma.bmadate=g_today   #資料建立日期
    LET l_bma.bmaacti='Y'       #有效資料
    
    LET l_bma.bma10 = '0'       #MOD-920176 add
 
    #No.FUN-830116 ---begin
    IF cl_null(l_bma.bma10) THEN
       LET l_bma.bma10 = '0'
    END IF
    #No.FUN-830116 ---end 
    INSERT INTO bma_file VALUES(l_bma.*)
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err('ins bma: ',SQLCA.SQLCODE,1)
       #ROLLBACK WORK
       RETURN FALSE
    END IF
  END FOREACH  
  
  #------------------- COPY BODY (bmb_file) ------------------------------
 
  #MOD-640139 Add Start，如果已經存在則刪除 ---
  DELETE FROM bmb_file WHERE bmb01 =  p_new
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL cl_err('del bmb: ',SQLCA.SQLCODE,1)
     RETURN FALSE
  END IF
  #MOD-640139 Add End ---
 
  LET l_sql = " SELECT * FROM bmb_file WHERE bmb01='",p_old,"'",
              " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
  PREPARE i600_pbmb FROM l_sql 
  DECLARE i600_cbmb CURSOR FOR i600_pbmb
  FOREACH i600_cbmb INTO l_bmb.*
    IF SQLCA.SQLCODE THEN CALL cl_err('sel bmb:',SQLCA.SQLCODE,0)
       EXIT FOREACH
    END IF
   
    #如果該筆記錄的計算方式為"3.公式"才執行下面的轉換
    IF l_bmb.bmb30 = '3' THEN
       #bmd_file中可能需要公式替換的欄位(bmb03元件料號,bmb06組成用量和bmb08損耗率)
       #通過存放在bmb03中的BOM公式前綴來得到相對于三個欄位的三個公式
       LET l_bmb03 = l_bmb.bmb03   #將元件料號(此時記錄著公式前綴)保存起來,因為下面會被替換掉
       LET l_formula = '&',l_bmb03 CLIPPED,'-1&'
       CALL cl_fml_run(l_formula,p_param_list) RETURNING l_res_str,l_res_int
       IF l_res_int THEN LET l_bmb.bmb03 = l_res_str  END IF
       LET l_formula = '&',l_bmb03 CLIPPED,'-2&'
       CALL cl_fml_run(l_formula,p_param_list) RETURNING l_res_str,l_res_int
       IF l_res_int THEN LET l_bmb.bmb06 = l_res_str  END IF
       LET l_formula = '&',l_bmb03 CLIPPED,'-3&'
       CALL cl_fml_run(l_formula,p_param_list) RETURNING l_res_str,l_res_int
       IF l_res_int THEN LET l_bmb.bmb08 = l_res_str  END IF    
 
       #最后將新生成的記錄的計算方式恢復為"1.固定"
       LET l_bmb.bmb30 = '1' 
    END IF    
 
    LET l_bmb.bmb01 = p_new 
    #LET l_bmb.bmb29 = new_bma06 #不考慮特性
    LET l_bmb.bmb24 = ''
    
    IF cl_null(l_bmb.bmb28) THEN LET l_bmb.bmb28 = 0 END IF
    
    #MOD-790002.................begin
    IF cl_null(l_bmb.bmb02)  THEN
       LET l_bmb.bmb02=' '
    END IF
    #MOD-790002.................end
 
    #如果完成公式替換后的原元件料號/新元件料號都有值才進行復制
    IF NOT cl_null(l_bmb.bmb03) THEN
       LET l_bmb.bmb33 = 0 #No.FUN-830116
       INSERT INTO bmb_file VALUES(l_bmb.*)
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err(l_bmb.bmb03,'mfg-001',1)
          EXIT FOREACH
       END IF
    END IF
  END FOREACH
 
  #COMMIT WORK
  RETURN TRUE
END FUNCTION
 
#--Add By Lifeng End-------------------------------------------------------
