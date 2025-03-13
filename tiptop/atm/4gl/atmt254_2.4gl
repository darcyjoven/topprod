# Prog. Version..: '5.30.06-13.03.22(00010)'     #
# Pattern name...: atmt254
# Descriptions...: 出貨單過帳可指定工廠&過帳還原
# Date & Author..: 06/03/04 By ice
# Modify.........: No.FUN-A10099 10/01/26 By Carier 拋轉邏輯重整&程序清理
# Modify.........: No.FUN-A20044 10/03/20 By        ima26x 調整        
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A40023 10/04/12 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A30056 10/04/13 By Carrier s_getstock 参数错误
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C80107 12/09/18 By suncx 增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D40078 13/04/28 By xujing 負庫存函数添加营运中心参数 

DATABASE ds

GLOBALS "../../config/top.global"   #No.FUN-A10099

#模組變數(Module Variables)

DEFINE l_argv0         LIKE type_file.chr1
DEFINE g_oga01         LIKE oga_file.oga01           # 單號
DEFINE l_dbs           LIKE type_file.chr21
DEFINE l_dbs_tra       LIKE type_file.chr21
DEFINE l_plant         LIKE azp_file.azp01 
DEFINE g_tsk07         LIKE tsk_file.tsk07
DEFINE g_oga99         LIKE oga_file.oga99 
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_oga           RECORD LIKE oga_file.*
DEFINE b_ogb           RECORD LIKE ogb_file.*
DEFINE g_ima25         LIKE ima_file.ima25 
DEFINE g_ima906        LIKE ima_file.ima906
DEFINE g_ima86         LIKE ima_file.ima86 
DEFINE l_sma           RECORD LIKE sma_file.*
DEFINE l_oaz           RECORD LIKE oaz_file.*
DEFINE g_sql           STRING
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL
#DEFINE g_sma894        LIKE type_file.chr1  #FUN-C80107  #FUN-D30024 mark
DEFINE g_imd23         LIKE type_file.chr1   #FUN-D30024 add

#出貨單過帳
FUNCTION t254_1(p_argv0,p_argv1,p_argv2,p_argv3,p_oga99)
  DEFINE p_argv0       LIKE type_file.chr1    # 6.代采買三角貿易
  DEFINE p_argv1       LIKE oga_file.oga01    # 出貨單號                                    # 單號
  DEFINE p_argv2       LIKE azp_file.azp01    # 出貨營運中心
  DEFINE p_argv3       LIKE tsk_file.tsk07
  DEFINE p_oga99       LIKE oga_file.oga99

  LET l_argv0 = p_argv0
  LET g_oga01 = p_argv1
  LET l_plant = p_argv2
  LET g_tsk07 = p_argv3
  LET g_oga99 = p_oga99

  # FUN-980093 add----GP5.2 Modify #改抓Transaction DB
  #LET g_plant_new = l_plant   #FUN-A50102
  #CALL s_getdbs()
  #LET l_dbs = g_dbs_new
  #CALL s_gettrandbs()
  #LET l_dbs_tra = g_dbs_tra
  #--End   FUN-980093 add-------------------------------------

  CALL t254_sys()

  CALL t254_1_s3()

END FUNCTION

FUNCTION t254_upd_oeb(p_type)                  #更新訂單已出貨量
   DEFINE p_type      LIKE type_file.num5
   DEFINE p_qty       LIKE oeb_file.oeb24

   IF p_type = 1 THEN
      LET p_qty = b_ogb.ogb12
   ELSE
      LET p_qty = b_ogb.ogb12 * -1
   END IF
   
   IF NOT cl_null(b_ogb.ogb31) AND b_ogb.ogb31[1,4] !='MISC' THEN
      #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED,"oeb_file",
      LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oeb_file'), #FUN-A50102
                  "   SET oeb24= oeb24 + ? ",    
                  " WHERE oeb01 = '",b_ogb.ogb31,"'",
                  "   AND oeb03 = '",b_ogb.ogb32,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE oeb24_cs FROM g_sql
      EXECUTE oeb24_cs USING p_qty     
      IF STATUS THEN
         LET g_showmsg = b_ogb.ogb31,'/',b_ogb.ogb32
         CALL s_errmsg('ogb31,ogb32',g_showmsg,'upd oeb24',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = b_ogb.ogb31,'/',b_ogb.ogb32
         CALL s_errmsg('ogb31,ogb32',g_showmsg,'upd oeb24','axm-134',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

END FUNCTION

FUNCTION t254_upd_oea()                 #更新訂單出貨金額
   DEFINE l_amount     LIKE oea_file.oea62

   #LET g_sql = "SELECT SUM(oeb24*oeb13) FROM ",l_dbs_tra CLIPPED,"oeb_file",
   LET g_sql = "SELECT SUM(oeb24*oeb13) FROM ",cl_get_target_table(l_plant,'oeb_file'), #FUN-A50102
               " WHERE oeb01='",b_ogb.ogb31,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oeb24_pl1 FROM g_sql
   DECLARE oeb24_cs1 CURSOR FOR oeb24_pl1
   OPEN oeb24_cs1
   FETCH oeb24_cs1 INTO l_amount
   IF cl_null(l_amount) THEN LET l_amount=0 END IF

   #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED,"oea_file",
   LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oea_file'), #FUN-A50102
               "   SET oea62= ? ",
               " WHERE oea01 = '",b_ogb.ogb31,"'"

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oea62_cs FROM g_sql
   EXECUTE oea62_cs USING l_amount

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oea01',b_ogb.ogb31,'upd oea62',status,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

#出貨單過帳
FUNCTION t254_1_s3()

   IF s_shut(0) THEN RETURN END IF

   #LET g_sql ="SELECT * FROM ",l_dbs_tra CLIPPED,"oga_file",
   LET g_sql ="SELECT * FROM ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
              " WHERE oga01 = '",g_oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oga_1_p1 FROM g_sql
   EXECUTE oga_1_p1 INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oga01',g_oga01,'SELECT oga',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.oga01 IS NULL THEN
      CALL s_errmsg('oga01',g_oga01,'oga01 is null',-400,1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.ogaconf <> 'Y' THEN
      CALL s_errmsg('oga01',g_oga01,'ogaconf = "N"','anm-960',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.ogapost = 'Y' THEN
      CALL s_errmsg('oga01',g_oga01,'ogapost = "Y"','aar-347',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_oga.oga02 <= l_sma.sma53 THEN
      CALL s_errmsg('oga02',g_oga.oga02,'','mfg9999',1)
      LET g_success = 'N'
      RETURN
   END IF

   #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED,"oga_file SET ogapost= 'Y' ",
   LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102,
               " SET ogapost= 'Y' ",
               " WHERE oga01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oga_cs FROM g_sql
   EXECUTE oga_cs
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL s_errmsg('oga01',g_oga.oga01,'UPDATE ogapost',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_oga.ogapost='Y'

   CALL t254_1_s2()

   IF g_success = 'N' THEN
      LET g_oga.ogapost='N'
      RETURN
   END IF

END FUNCTION

FUNCTION t254_1_s2()

   #LET g_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"ogb_file",
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
               " WHERE ogb01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE t254_1_s2_pl FROM g_sql
   DECLARE t254_1_s2_c CURSOR FOR t254_1_s2_pl
   FOREACH t254_1_s2_c INTO b_ogb.*
      IF STATUS THEN
         CALL s_errmsg('ogb01',g_oga.oga01,'foreach t254_1_s2_c',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      MESSAGE '_s1() read no:',b_ogb.ogb03 USING '#####&',
                             '--> parts: ', b_ogb.ogb04
      IF cl_null(b_ogb.ogb04) THEN CONTINUE FOREACH END IF

      CALL t254_upd_oeb(1)
      IF g_success = 'N' THEN CONTINUE FOREACH END IF

      IF b_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF

#     CALL t254_1_chk_ima262(b_ogb.ogb16)    #NO.FUN-A40023
      CALL t254_1_chk_avl_stk(b_ogb.ogb16)   #NO.FUN-A40023
      CALL t254_1_update(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                         b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'','-')  #No:8741
      IF g_success='N' THEN RETURN END IF

      IF l_sma.sma115 = 'Y' THEN
         CALL t254_s_du()
      END IF

   END FOREACH
   CALL t254_upd_oea()
END FUNCTION

FUNCTION t254_1_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_type) #No:8741
   DEFINE p_flag    LIKE type_file.chr1        #No:8741
   DEFINE p_ware    LIKE ogb_file.ogb09        ##倉庫
   DEFINE p_loca    LIKE ogb_file.ogb091       ##儲位
   DEFINE p_lot     LIKE ogb_file.ogb092       ##批號
   DEFINE p_qty     LIKE ogc_file.ogc12        ##銷售數量(銷售單位)
   DEFINE p_uom     LIKE tlf_file.tlf11        ##銷售單位
   DEFINE p_factor  LIKE ogb_file.ogb15_fac    ##轉換率
   DEFINE p_qty2    LIKE ogc_file.ogc16        ##銷售數量(img 單位)
   DEFINE p_type    LIKE type_file.chr1 
   DEFINE l_qty     LIKE ogc_file.ogc12        ##異動后數量
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_img     RECORD
                    img10   LIKE img_file.img10,
                    img16   LIKE img_file.img16,
                    img23   LIKE img_file.img23,
                    img24   LIKE img_file.img24,
                    img09   LIKE img_file.img09,
                    img18   LIKE img_file.img18,
                    img21   LIKE img_file.img21
                    END RECORD 

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
   IF cl_null(p_qty2) THEN LET p_qty2=0   END IF

   IF p_uom IS NULL THEN
      LET g_showmsg = b_ogb.ogb03,'/',b_ogb.ogb04
      CALL s_errmsg('ogb03,ogb04',g_showmsg,'p_uom null:','axm-186',1)
      LET g_success = 'N' RETURN
   END IF

   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img18,img21 ", #No:BUG-480401
                      #"  FROM ",l_dbs_tra CLIPPED,"img_file ",
                      "  FROM ",cl_get_target_table(l_plant,'img_file'), #FUN-A50102,
                      " WHERE img01= ? AND img02= ? AND img03= ? ",
                      "   AND img04= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)            #FUN-B80061    ADD
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql            
   CALL cl_parse_qry_sql(g_forupd_sql,l_plant) RETURNING g_forupd_sql
  # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #FUN-B80061    MARK 
   DECLARE img_lock CURSOR FROM g_forupd_sql

   OPEN img_lock USING b_ogb.ogb04,p_ware,p_loca,p_lot
   IF SQLCA.sqlcode THEN
      LET g_showmsg = b_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'open img_lock',SQLCA.sqlcode,1)
      CLOSE img_lock
      LET g_success = 'N'
      RETURN
   END IF

   FETCH img_lock INTO l_img.*
   IF SQLCA.sqlcode THEN
      LET g_showmsg = b_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'fetch img_lock',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   #No:BUG-480401
   IF l_img.img18 < g_oga.oga02 AND p_type <> '+' THEN
      LET g_showmsg = l_img.img18,'/',g_oga.oga02
      CALL s_errmsg('img18,oga02',g_showmsg,'img18<oga02','aim-400',1)
      LET g_success='N'
      RETURN
   END IF
   #No:BUG-480401

   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 - p_qty2

   IF p_type = '+' THEN LET l_cnt =  1 END IF
   IF p_type = '-' THEN LET l_cnt = -1 END IF

   CALL s_mupimg(l_cnt,b_ogb.ogb04,p_ware,p_loca,p_lot,p_qty2,
                 g_today,l_plant CLIPPED ,-1,b_ogb.ogb01,b_ogb.ogb03)

   IF g_success='N' THEN
      LET g_showmsg = b_ogb.ogb04,'/',p_ware,'/',p_loca,'/',p_lot
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'s_upimg()','9050',1)
   END IF

   #LET g_forupd_sql = "SELECT ima25,ima86 FROM ",l_dbs CLIPPED,"ima_file ",
   LET g_forupd_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(l_plant,'ima_file'), #FUN-A50102,
                      " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)         #FUN-B80061   ADD
   CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql          
   CALL cl_parse_qry_sql(g_forupd_sql,l_plant) RETURNING g_forupd_sql
  # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        #FUN-B80061   MARK     
   DECLARE ima_lock CURSOR FROM g_forupd_sql

   OPEN ima_lock USING b_ogb.ogb04
   IF STATUS THEN
      CALL s_errmsg('ima01',b_ogb.ogb04,"OPEN ima_lock:", STATUS, 1)
      CLOSE ima_lock
      LET g_success='N'
      RETURN
   END IF

   FETCH ima_lock INTO g_ima25,g_ima86
   IF STATUS THEN
      CALL s_errmsg('ima01',b_ogb.ogb04,'lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF

   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   CALL s_mudima(b_ogb.ogb04,l_plant)
   IF g_success='Y' AND p_type = '-' THEN
      CALL t254_1_tlf(p_ware,p_loca,p_lot,g_ima25,p_qty,l_qty,p_uom,p_factor,p_flag) #No:8741
   END IF

END FUNCTION

FUNCTION t254_1_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag) #No:8741
   DEFINE p_ware     LIKE ogb_file.ogb09        ##倉庫
   DEFINE p_loca     LIKE ogb_file.ogb091       ##儲位
   DEFINE p_lot      LIKE ogb_file.ogb092       ##批號
   DEFINE p_unit     LIKE ima_file.ima25        ##單位
   DEFINE p_qty      LIKE ogc_file.ogc12        ##銷售數量(銷售單位)
   DEFINE p_img10    LIKE img_file.img10        ##異動后數量
   DEFINE p_uom      LIKE tlf_file.tlf11        ##銷售單位
   DEFINE p_factor   LIKE ogb_file.ogb15_fac    ##轉換率
   DEFINE p_flag     LIKE type_file.chr1        #No:8741
   DEFINE l_n1       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n2       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n3       LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 

   #----來源----
   LET g_tlf.tlf01=b_ogb.ogb04         #異動料件編號
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=b_ogb.ogb08
   LET g_tlf.tlf021=p_ware             #倉庫
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動后數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=b_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027=b_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03=724
   LET g_tlf.tlf030=' '
   LET g_tlf.tlf031=' '                #倉庫
   LET g_tlf.tlf032=' '                #儲位
   LET g_tlf.tlf033=' '                #批號
   LET g_tlf.tlf034=' '                #異動后庫存數量
   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=b_ogb.ogb31        #訂單單號
   LET g_tlf.tlf037=b_ogb.ogb32        #訂單項次
   #-->異動數量
   LET g_tlf.tlf04= ' '                #工作站
   LET g_tlf.tlf05= ' '                #作業序號
   LET g_tlf.tlf06=g_oga.oga02         #發料日期
   LET g_tlf.tlf07=g_today             #異動資料產生日期
   LET g_tlf.tlf08=TIME                #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user              #產生人
   LET g_tlf.tlf10=p_qty               #異動數量
   LET g_tlf.tlf11=p_uom               #發料單位
   LET g_tlf.tlf12 =p_factor           #發料/庫存 換算率
   LET g_tlf.tlf13='axmt620'
   LET g_tlf.tlf14=b_ogb.ogb1001       #異動原因

   LET g_tlf.tlf17=' '                 #非庫存性料件編號

  ##NO.FUN-A20044   add--begin
#  LET g_sql = " SELECT ima261+ima262 FROM ",l_dbs CLIPPED,"ima_file",
#              "  WHERE ima01= '",b_ogb.ogb04,"'"
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
#  PREPARE tlf18_pl FROM g_sql
#  DECLARE tlf18_cs CURSOR  FOR tlf18_pl
#  OPEN tlf18_cs
#  FETCH tlf18_cs INTO g_tlf.tlf18
#  IF SQLCA.sqlcode OR g_tlf.tlf18 IS NULL THEN
#     LET g_tlf.tlf18=0
#  END IF
#  CALL s_getstock(b_ogb.ogb04,l_dbs) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044  #No.FUN-A30056
   CALL s_getstock(b_ogb.ogb04,l_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044  #No.FUN-A30056
   LET g_tlf.tlf18 = l_n2+l_n3 
   IF g_tlf.tlf18 IS NULL THEN
      LET g_tlf.tlf18=0
   END IF 
  ##NO.FUN-A20044   add--end
   LET g_tlf.tlf19=g_oga.oga03
   LET g_tlf.tlf20 = g_oga.oga46
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=b_ogb.ogb31        #參考單號(訂單)
   LET g_tlf.tlf63=b_ogb.ogb32        #訂單項次
   LET g_tlf.tlf64=b_ogb.ogb908       #手冊編號 no.A050
   LET g_tlf.tlf66=p_flag             #for axcp500多倉出貨處理   #No:8741
   LET g_tlf.tlf930=b_ogb.ogb930
   LET g_tlf.tlf20 = b_ogb.ogb41                                                
   LET g_tlf.tlf41 = b_ogb.ogb42                                                
   LET g_tlf.tlf42 = b_ogb.ogb43                                                
   LET g_tlf.tlf43 = b_ogb.ogb1001  
   LET g_tlf.tlf99 = g_oga99
   CALL s_tlf2(1,0,l_plant)
END FUNCTION

FUNCTION t254_s_du()
  DEFINE l_azp03         LIKE type_file.chr21
  DEFINE l_last_poy02    LIKE poy_file.poy02                                 
  DEFINE l_last_poy04    LIKE poy_file.poy04

   CALL s_mtrade_last_plant(g_tsk07)     #最后一站的站別 & 營運中心         
        RETURNING l_last_poy02,l_last_poy04                                     
   SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_last_poy04 

   CALL t254_sel_ima(b_ogb.ogb04)
   IF g_success = 'N' THEN RETURN END IF
   IF cl_null(g_ima906) OR g_ima906 = '1' THEN RETURN END IF

   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(b_ogb.ogb913) THEN
         CALL s_mchk_imgg(b_ogb.ogb04,b_ogb.ogb09,
                          b_ogb.ogb091,b_ogb.ogb092,b_ogb.ogb913,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = b_ogb.ogb04,'/',b_ogb.ogb09,'/',b_ogb.ogb091,'/',b_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t254_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                             b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915,-1,'2')
         IF g_success='N' THEN RETURN END IF
#        IF NOT cl_null(b_ogb.ogb915) AND b_ogb.ogb915 <> 0 THEN                 #CHI-860005 Mark
         IF NOT cl_null(b_ogb.ogb915) THEN                                       #CHI-860005
            CALL t254_tlff(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,g_ima25,
                           b_ogb.ogb915,0,b_ogb.ogb913,b_ogb.ogb914,-1,'2',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(b_ogb.ogb910) THEN
         CALL s_mchk_imgg(b_ogb.ogb04,b_ogb.ogb09,
                          b_ogb.ogb091,b_ogb.ogb092,b_ogb.ogb910,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = b_ogb.ogb04,'/',b_ogb.ogb09,'/',b_ogb.ogb091,'/',b_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t254_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                             b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912,-1,'2')
         IF g_success='N' THEN RETURN END IF
#        IF NOT cl_null(b_ogb.ogb912) AND b_ogb.ogb912 <> 0 THEN                  #CHI-860005 Mark
         IF NOT cl_null(b_ogb.ogb912) THEN                                        #CHI-860005
            CALL t254_tlff(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,g_ima25,
                           b_ogb.ogb912,0,b_ogb.ogb910,b_ogb.ogb911,-1,'1',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_ogb.ogb913) THEN
         CALL s_mchk_imgg(b_ogb.ogb04,b_ogb.ogb09,
                          b_ogb.ogb091,b_ogb.ogb092,b_ogb.ogb913,l_azp03)
            RETURNING g_flag
         IF g_flag = 1 THEN
            LET g_showmsg = b_ogb.ogb04,'/',b_ogb.ogb09,'/',b_ogb.ogb091,'/',b_ogb.ogb092
            CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'sel imgg:','axm-244',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL t254_upd_imgg('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                             b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915,-1,'2')
         IF g_success='N' THEN RETURN END IF
#        IF NOT cl_null(b_ogb.ogb915) AND b_ogb.ogb915 <> 0 THEN                   #CHI-860005 Mark
         IF NOT cl_null(b_ogb.ogb915) THEN                                         #CHI-860005
            CALL t254_tlff(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,g_ima25,
                           b_ogb.ogb915,0,b_ogb.ogb913,b_ogb.ogb914,-1,'2',l_azp03)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF

END FUNCTION

FUNCTION t254_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag,p_azp03)
   DEFINE p_ware     LIKE imgg_file.imgg02               #倉庫
   DEFINE p_loca     LIKE imgg_file.imgg03               #儲位
   DEFINE p_lot      LIKE imgg_file.imgg04               #批號
   DEFINE p_unit     LIKE imgg_file.imgg09 
   DEFINE p_qty      LIKE imgg_file.imgg10               #數量
   DEFINE p_img10    LIKE imgg_file.imgg10               #異動后數量
   DEFINE p_uom      LIKE imgg_file.imgg09               #img 單位
   DEFINE p_factor   LIKE imgg_file.imgg21               #轉換率
   DEFINE l_imgg10   LIKE imgg_file.imgg10 
   DEFINE u_type     LIKE type_file.num5 
   DEFINE p_flag     LIKE type_file.chr1 
   DEFINE p_azp03    LIKE azp_file.azp03

   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
   IF cl_null(p_qty)  THEN LET p_qty =0   END IF
   LET g_sql = " SELECT imgg10 ",
               #"   FROM ",l_dbs_tra CLIPPED,"imgg_file ",
               "   FROM ",cl_get_target_table(l_plant,'imgg_file'), #FUN-A50102,
               "  WHERE imgg01 = '",b_ogb.ogb04,"' ",
               "    AND imgg02 = '",p_ware,"' ",
               "    AND imgg03 = '",p_loca,"' ",
               "    AND imgg04 = '",p_lot,"' ",
               "    AND imgg09 = '",p_uom,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE imgg_pre FROM g_sql
   DECLARE imgg_cur CURSOR FOR imgg_pre
   EXECUTE imgg_pre INTO l_imgg10
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   INITIALIZE g_tlff.* TO NULL

   #----來源----
   LET g_tlff.tlff01=b_ogb.ogb04              #異動料件編號
   LET g_tlff.tlff02=50                  #'Stock'
   LET g_tlff.tlff020=b_ogb.ogb08
   LET g_tlff.tlff021=p_ware             #倉庫
   LET g_tlff.tlff022=p_loca             #儲位
   LET g_tlff.tlff023=p_lot              #批號
   LET g_tlff.tlff024=l_imgg10           #異動後數量
   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=b_ogb.ogb01        #出貨單號
   LET g_tlff.tlff027=b_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlff.tlff03=724
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '                #倉庫
   LET g_tlff.tlff032=' '                #儲位
   LET g_tlff.tlff033=' '                #批號
   LET g_tlff.tlff034=' '                #異動後庫存數量
   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=b_ogb.ogb31        #訂單單號
   LET g_tlff.tlff037=b_ogb.ogb32        #訂單項次

   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=g_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_uom            #發料單位
   LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
   LET g_tlff.tlff13='axmt620'
   LET g_tlff.tlff14=' '              #異動原因

   LET g_tlff.tlff17=' '              #非庫存性料件編號
   #CALL s_imaQOH(b_ogb.ogb04)
   #   RETURNING g_tlff.tlff18
   LET g_tlff.tlff18 = g_tlf.tlf18
   LET g_tlff.tlff19=g_oga.oga04
   LET g_tlff.tlff20 = g_oga.oga46
   LET g_tlff.tlff61= g_ima86
   LET g_tlff.tlff62=b_ogb.ogb31    #參考單號(訂單)
   LET g_tlff.tlff63=b_ogb.ogb32    #訂單項次
   LET g_tlff.tlff64=b_ogb.ogb908   #手冊編號 no.A050
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlff.tlff930=b_ogb.ogb930
   LET g_tlff.tlff99 = g_oga99

   IF cl_null(b_ogb.ogb915) OR b_ogb.ogb915=0 THEN
      CALL s_tlff2(p_flag,NULL,p_azp03)
   ELSE
      CALL s_tlff2(p_flag,b_ogb.ogb913,p_azp03)
   END IF
END FUNCTION

FUNCTION t254_p2_s(p_oga01,p_plant,p_tsk07)
   DEFINE p_plant  LIKE azp_file.azp01 
   DEFINE p_oga01  LIKE oga_file.oga01
   DEFINE p_tsk07  LIKE tsk_file.tsk07
   DEFINE l_cnt    LIKE type_file.num5

   LET g_tsk07 = p_tsk07
   LET g_oga.oga01 = p_oga01
   LET l_plant = p_plant
   # FUN-980093 add----GP5.2 Modify #改抓Transaction DB
   #LET g_plant_new = l_plant
   #CALL s_getdbs()           #FUN-A50102
   #LET l_dbs = g_dbs_new     #FUN-A50102
   #CALL s_gettrandbs()       #FUN-A50102
   #LET l_dbs_tra = g_dbs_tra #FUN-A50102
   #--End   FUN-980093 add-------------------------------------

   #LET g_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"oga_file ",
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
               " WHERE oga01 = '",g_oga.oga01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oga3_pre FROM g_sql
   EXECUTE oga3_pre INTO g_oga.*
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      CALL s_errmsg('oga01',g_oga.oga01,'execute oga3_pre',SQLCA.SQLCODE,1)
      RETURN
   END IF

   CALL t254_sys()

   #LET g_sql = "UPDATE ",l_dbs_tra CLIPPED,"oga_file SET ogapost= 'N' ",
   LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
               "   SET ogapost= 'N' ",
               " WHERE oga01='",g_oga.oga01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE oga2_upd FROM g_sql
   EXECUTE oga2_upd
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
      CALL s_errmsg('oga01',g_oga.oga01,'execute oga2_upd',SQLCA.SQLCODE,1)
      RETURN
   END IF

   LET g_oga.ogapost = 'N'
   #LET g_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"ogb_file ",
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
               " WHERE ogb01 = '",g_oga.oga01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE ogb2_pre FROM g_sql
   DECLARE ogb2_s1_c CURSOR FOR ogb2_pre
   FOREACH ogb2_s1_c INTO b_ogb.*
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('ogb01',g_oga.oga01,'foreach ogb2_s1_c',SQLCA.sqlcode,1)
         LET g_success='N' 
         EXIT FOREACH
      END IF

      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success="Y"
      END IF

      IF cl_null(b_ogb.ogb04) THEN CONTINUE FOREACH END IF
      LET g_sql = "SELECT COUNT(*) ",
                  #"  FROM ",l_dbs CLIPPED,"omb_file,",
                  #          l_dbs CLIPPED,"oma_file ",
                  "  FROM ",cl_get_target_table(l_plant,'omb_file'),",", #FUN-A50102
                            cl_get_target_table(l_plant,'oma_file'),     #FUN-A50102
                  " WHERE oma01 = omb01 ",
                  "   AND omb01 = '",g_oga.oga10,"'",
                  "   AND omb31 = '",b_ogb.ogb01,"'",
                  "   AND omb32 =  ",b_ogb.ogb03,
                  "   AND omavoid != 'Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql               #FUN-A50102  
      PREPARE omb2_pre FROM g_sql
      EXECUTE omb2_pre INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('oma01',g_oga.oga01,'execute omb2_pre','axm-302',1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      CALL t254_upd_oeb(-1)
      IF l_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF b_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF

      CALL t254_sel_ima(b_ogb.ogb04)
      IF g_success = 'N' THEN CONTINUE FOREACH END IF

      CALL t254_1_update(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                         b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'','+')  #No:8741
      IF g_success='N' THEN CONTINUE FOREACH END IF

      CALL t254_du(b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                   b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915,
                   b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912,'2')
      IF g_success='N' THEN CONTINUE FOREACH END IF
       
      CALL t254_u_tlf()
      IF g_success='N' THEN RETURN END IF
  END FOREACH
  CALL t254_upd_oea()

  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF

END FUNCTION

FUNCTION t254_du(p_item,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1,p_flag)
  DEFINE p_item     LIKE img_file.img01
  DEFINE p_ware     LIKE img_file.img02
  DEFINE p_loc      LIKE img_file.img03
  DEFINE p_lot      LIKE img_file.img04
  DEFINE p_unit2    LIKE img_file.img09
  DEFINE p_fac2     LIKE img_file.img21
  DEFINE p_qty2     LIKE img_file.img10
  DEFINE p_unit1    LIKE img_file.img09
  DEFINE p_fac1     LIKE img_file.img21
  DEFINE p_qty1     LIKE img_file.img10
  DEFINE p_flag     LIKE type_file.chr1

  IF l_sma.sma115 = 'N' THEN RETURN END IF

  CALL t254_sel_ima(p_item)
  IF g_success = 'N' THEN RETURN END IF

  IF g_ima906 IS NULL OR g_ima906 = '1' THEN RETURN END IF
  IF g_ima906 = '2' THEN
     IF NOT cl_null(p_unit2) THEN
        CALL t254_upd_imgg('1',p_item,p_ware,p_loc,p_lot,
                           p_unit2,p_fac2,p_qty2,+1,'2')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF NOT cl_null(p_unit1) THEN
        CALL t254_upd_imgg('1',p_item,p_ware,p_loc,p_lot,
                           p_unit1,p_fac1,p_qty1,+1,'1')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF p_flag = '2' THEN
        CALL t254_tlff_2()
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
  IF g_ima906 = '3' THEN
     IF NOT cl_null(p_unit2) THEN
        CALL t254_upd_imgg('2',p_item,p_ware,p_loc,p_lot,
                           p_unit2,p_fac2,p_qty2,+1,'2')
        IF g_success='N' THEN RETURN END IF
     END IF
     IF p_flag = '2' THEN
        CALL t254_tlff_2()
        IF g_success='N' THEN RETURN END IF
     END IF
  END IF
END FUNCTION

FUNCTION t254_tlff_2()#------------------------------------------ Update tlf_file

   #LET g_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"tlff_file ",
   LET g_sql = "DELETE FROM ",cl_get_target_table(l_plant,'tlff_file'), #FUN-A50102
               " WHERE tlff01 ='",b_ogb.ogb04,"'",
               "   AND tlff02 =50 ",
               "   AND tlff026='",g_oga.oga01,"' ", #出貨單號
               "   AND tlff027= ",b_ogb.ogb03,      #出貨項次
               "   AND tlff036='",b_ogb.ogb31,"' ", #訂單單號
               "   AND tlff037= ",b_ogb.ogb32,      #訂單項次
               "   AND tlff06 ='",g_oga.oga02,"' " #出貨日期
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #carrier  check
   PREPARE tlff_2_del FROM g_sql
   EXECUTE tlff_2_del
   IF SQLCA.sqlcode THEN
      LET g_showmsg = g_oga.oga01,'/',b_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlff:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = g_oga.oga01,'/',b_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlff:','axm-176',1)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

FUNCTION t254_u_tlf()#------------------------------------------ Update tlf_file
   DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
   DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
   DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
  ##NO.FUN-8C0131   add--begin
   #LET g_sql = "SELECT * FROM ",l_dbs_tra CLIPPED,"tlf_file ",
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'tlf_file'), #FUN-A50102
               " WHERE tlf01 ='",b_ogb.ogb04,"' ",
               "   AND tlf02 = 50 ",
               "   AND tlf026='",g_oga.oga01,"' ", 
               "   AND tlf027= ",b_ogb.ogb03,      
               "   AND tlf036='",b_ogb.ogb31,"' ", 
               "   AND tlf037= ",b_ogb.ogb32,      
               "   AND tlf06 ='",g_oga.oga02,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql          #FUN-A50102     
    DECLARE t254_u_tlf_c CURSOR FROM g_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t254_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
   
   #LET g_sql = "DELETE FROM ",l_dbs_tra CLIPPED,"tlf_file ",
   LET g_sql = "DELETE FROM ",cl_get_target_table(l_plant,'tlf_file'), #FUN-A50102
               " WHERE tlf01 ='",b_ogb.ogb04,"' ",
               "   AND tlf02 = 50 ",
               "   AND tlf026='",g_oga.oga01,"' ", #出貨單號
               "   AND tlf027= ",b_ogb.ogb03,      #出貨項次
               "   AND tlf036='",b_ogb.ogb31,"' ", #訂單單號
               "   AND tlf037= ",b_ogb.ogb32,      #訂單項次
               "   AND tlf06 ='",g_oga.oga02,"' "  #出貨日期

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
   PREPARE tlf_4_del FROM g_sql
   EXECUTE tlf_4_del
   IF SQLCA.SQLCODE THEN
      LET g_showmsg = b_ogb.ogb01,'/',b_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlf:',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = b_ogb.ogb01,'/',b_ogb.ogb03
      CALL s_errmsg('ogb01,ogb03',g_showmsg,'del tlf:','axm-176',1)
      LET g_success='N' 
      RETURN
   END IF
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end     
END FUNCTION

FUNCTION t254_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE p_imgg00   LIKE imgg_file.imgg00
  DEFINE p_imgg01   LIKE imgg_file.imgg01
  DEFINE p_imgg02   LIKE imgg_file.imgg02
  DEFINE p_imgg03   LIKE imgg_file.imgg03
  DEFINE p_imgg04   LIKE imgg_file.imgg04
  DEFINE p_imgg09   LIKE imgg_file.imgg09
  DEFINE p_imgg211  LIKE imgg_file.imgg211
  DEFINE p_imgg10   LIKE imgg_file.imgg10
  DEFINE p_type     LIKE type_file.num10
  DEFINE p_no       LIKE type_file.chr1 
  DEFINE l_imgg21   LIKE imgg_file.imgg21 
  DEFINE l_imgg00   LIKE imgg_file.imgg00
  DEFINE l_cnt      LIKE type_file.num5

  IF cl_null(p_imgg03) THEN LET p_imgg03 = ' ' END IF
  IF cl_null(p_imgg04) THEN LET p_imgg04 = ' ' END IF
  LET g_forupd_sql =
      #"SELECT imgg00 FROM ",l_dbs_tra CLIPPED,"imgg_file ",
      "SELECT imgg00 FROM ",cl_get_target_table(l_plant,'imgg_file'), #FUN-A50102
      " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
      "   AND imgg09= ? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)    #FUN-B80061   ADD
  CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
  CALL cl_parse_qry_sql(g_forupd_sql,l_plant) RETURNING g_forupd_sql
 # LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80061   MARK                    
  DECLARE imgg_lock CURSOR FROM g_forupd_sql

  OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
  IF STATUS THEN
     LET g_showmsg = p_imgg01,'/',p_imgg02,'/',p_imgg03,'/',p_imgg04,'/',p_imgg09
     CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'OPEN imgg_lock',SQLCA.sqlcode,1)
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF
  FETCH imgg_lock INTO l_imgg00
  IF STATUS THEN
     LET g_showmsg = p_imgg01,'/',p_imgg02,'/',p_imgg03,'/',p_imgg04,'/',p_imgg09
     CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'FETCH imgg_lock',SQLCA.sqlcode,1)
     LET g_success='N'
     CLOSE imgg_lock
     RETURN
  END IF

  CALL t254_sel_ima(p_imgg01)
  IF g_success = 'N' THEN RETURN END IF

  CALL s_umfchkm(p_imgg01,p_imgg09,g_ima25,l_plant)
       RETURNING l_cnt,l_imgg21
  IF l_cnt = 1 AND NOT (g_ima906='3' AND p_no='2') THEN
     LET g_showmsg = p_imgg01,'/',p_imgg09,'/',g_ima25
     CALL s_errmsg('imgg01,imgg09,ima25',g_showmsg,'s_umfchkm','mfg3075',1)
     LET g_success = 'N' 
     RETURN
  END IF

  CALL s_mupimgg(p_type,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg10,g_oga.oga02,l_plant)
  IF g_success='N' THEN RETURN END IF

END FUNCTION

FUNCTION t254_sys()
  #SELECT 系統參數
  #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"sma_file",
  LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'sma_file'), #FUN-A50102
              " WHERE sma00 = '0'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102  
  PREPARE sma_p1 FROM g_sql
  EXECUTE sma_p1 INTO l_sma.*
  IF SQLCA.sqlcode THEN
     CALL s_errmsg('sma00','0','select sma fail',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

  #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oaz_file",
  LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'oaz_file'), #FUN-A50102
              " WHERE oaz00 = '0'"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102   
  PREPARE oaz_p1 FROM g_sql
  EXECUTE oaz_p1 INTO l_oaz.*
  IF SQLCA.sqlcode THEN
     CALL s_errmsg('oaz00','0','select oaz fail',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF

END FUNCTION

FUNCTION t254_sel_ima(p_ima01)
   DEFINE p_ima01     LIKE ima_file.ima01

   LET g_ima906 = NULL
   LET g_ima25  = NULL
   LET g_sql = " SELECT ima906,ima25 ",
               #"  FROM ",l_dbs CLIPPED,"ima_file ",
               "  FROM ",cl_get_target_table(l_plant,'ima_file'), #FUN-A50102
               " WHERE ima01 = '",p_ima01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102   
   PREPARE ima_sel FROM g_sql
   EXECUTE ima_sel INTO g_ima906,g_ima25
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ima01',p_ima01,'ima_sel',SQLCA.sqlcode,1)
      LET g_success='N'
      RETURN
   END IF

END FUNCTION

#FUNCTION t254_1_chk_ima262(p_qty2)     #NO.FUN-A40023
FUNCTION t254_1_chk_avl_stk(p_qty2)     #NO.FUN-A40023
   DEFINE p_qty2    LIKE ogc_file.ogc16    ##銷售數量(img 單位)
   DEFINE l_oeb19   LIKE oeb_file.oeb19
#  DEFINE l_ima262  LIKE ima_file.ima262      #NO.FUN-A20044
   DEFINE l_avl_stk LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_fac     LIKE ogb_file.ogb15_fac
   DEFINE l_n1      LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n2      LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n3      LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 

   #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(b_ogb.ogb31) AND NOT cl_null(b_ogb.ogb32) THEN  
       CALL t254_sel_ima(b_ogb.ogb04)
       IF g_success = 'N' THEN RETURN END IF

       #LET g_sql =  "SELECT oeb19 FROM ",l_dbs_tra CLIPPED,"oeb_file",
       LET g_sql =  "SELECT oeb19 FROM ",cl_get_target_table(l_plant,'oeb_file'), #FUN-A50102
                    " WHERE oeb01 = '",b_ogb.ogb31,"'",
                    "   AND oeb03 = '",b_ogb.ogb32,"'"          
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
       PREPARE oeb19_pl1 FROM g_sql 
       DECLARE oeb19_cs1 CURSOR FOR oeb19_pl1
       OPEN oeb19_cs1
       FETCH oeb19_cs1 INTO l_oeb19
       IF STATUS THEN
          LET g_showmsg = b_ogb.ogb31,'/',b_ogb.ogb32
          CALL s_errmsg('ogb31,ogb32',g_showmsg,'fetch oeb19',SQLCA.sqlcode,1)
          LET g_success='N' 
          RETURN
       END IF
       IF l_oeb19 = 'N' THEN    
#         LET g_sql =  "SELECT ima262 FROM ",l_dbs CLIPPED,"ima_file",
#                      " WHERE ima01 = '",b_ogb.ogb04,"'"         
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#         PREPARE ima262_pl FROM g_sql 
#         DECLARE ima262_cs CURSOR FOR ima262_pl
#         OPEN ima262_cs
#         FETCH ima262_cs INTO l_ima262 
#         IF STATUS THEN
#            CALL s_errmsg('ima01',b_ogb.ogb04,'select ima262',SQLCA.sqlcode,1)
#            LET g_success='N' 
#            RETURN
#         END IF
#         IF l_ima262 IS NULL THEN 
#            LET l_ima262 = 0 
#         END IF
#         CALL s_getstock(b_ogb.ogb04,l_dbs) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044   #No.FUN-A30056
          CALL s_getstock(b_ogb.ogb04,l_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044   #No.FUN-A30056
          LET l_avl_stk = l_n3           #NO.FUN-A20044
          IF l_avl_stk IS NULL THEN      #NO.FUN-A20044
             LET l_avl_stk = 0           #NO.FUN-A20044
          END IF 
          #LET g_sql =  "SELECT SUM(oeb905*oeb05_fac) FROM ",l_dbs_tra CLIPPED,"oeb_file",
          LET g_sql =  "SELECT SUM(oeb905*oeb05_fac) FROM ",cl_get_target_table(l_plant,'oeb_file'), #FUN-A50102
                       " WHERE oeb04 = '",b_ogb.ogb04,"'",  
                       "   AND oeb19= 'Y' AND oeb70= 'N'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
          PREPARE oeb12_pl FROM g_sql 
          DECLARE oeb12_cs CURSOR FOR oeb12_pl
          OPEN oeb12_cs
          FETCH oeb12_cs INTO l_oeb12 
          IF STATUS THEN
             CALL s_errmsg('oeb04',b_ogb.ogb04,'fetch oeb12_cs',SQLCA.sqlcode,1)
             LET g_success='N' 
             RETURN
          END IF 
          IF l_oeb12 IS NULL THEN 
             LET l_oeb12 = 0 
          END IF
#         LET l_qoh = l_ima262 - l_oeb12    #NO.FUN-A20044
          LET l_qoh = l_avl_stk - l_oeb12   #NO.FUN-A20044

          CALL s_umfchkm(b_ogb.ogb04,b_ogb.ogb15,g_ima25,l_plant)
               RETURNING l_cnt,l_fac
          IF l_cnt = 1 THEN
             LET g_showmsg = b_ogb.ogb04,'/',b_ogb.ogb15,'/',g_ima25
             CALL s_errmsg('ima01,img09,ima25',g_showmsg,'s_umfchkm','mfg3075',1)
             LET g_success = 'N' 
             RETURN
          END IF
          LET p_qty2 = p_qty2 * l_fac

         #IF l_qoh < p_qty2 AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail   #FUN-C80107 mark
         #FUN-D30024--modify--str--
         #INITIALIZE g_sma894 TO NULL                                                         #FUN-C80107
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],b_ogb.ogb09) RETURNING g_sma894      #FUN-C80107
         #IF l_qoh < p_qty2 AND g_sma894 = 'N' THEN                                           #FUN-C80107
          INITIALIZE g_imd23 TO NULL
          CALL s_inv_shrt_by_warehouse(b_ogb.ogb09,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant
          IF l_qoh < p_qty2 AND g_imd23 = 'N' THEN                                         
         #FUN-D30024--modify--end--
             LET g_showmsg = l_qoh,'/',p_qty2
#            CALL s_errmsg('oeb905,ima262',g_showmsg,'QOH<0','mfg-026',1)    #NO.FUN-A20044
             CALL s_errmsg('oeb905,l_avl_stk',g_showmsg,'QOH<0','mfg-026',1) #NO.FUN-A20044
             LET g_success='N' 
             RETURN
          END IF
       END IF
    END IF
END FUNCTION
