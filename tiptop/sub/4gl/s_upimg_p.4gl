# Prog. Version..: '5.30.06-13.03.18(00004)'     #
#
# Pattern name...: s_upimg_p.4gl
# Descriptions...: 批次更新倉庫庫存明細檔
# Date & Author..: No.FUN-CA0091 12/10/14 By baogc
# Modify.........: No:FUN-CA0160 12/11/07 By baogc 邏輯調整
# Modify.........: No:FUN-CB0103 12/11/28 By baogc 逻辑调整
# Modify.........: No:FUN-D30017 13/03/18 By xumm BUG修改
# Modify.........: No:FUN-D40103 13/05/10 By lixh1 增加儲位有效性檢查

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../apc/4gl/sapcp200.global" #FUN-CB0103 Add

FUNCTION s_upimg_p(p_type,p_no,p_plant,p_date)
DEFINE p_type       LIKE type_file.chr1
DEFINE p_no         LIKE oga_file.oga01
DEFINE p_plant      LIKE azw_file.azw01
DEFINE p_date       LIKE oga_file.oga02
DEFINE p_legal      LIKE azw_file.azw02
DEFINE l_ins        STRING 
DEFINE l_upd        STRING 
DEFINE l_sel        STRING 
DEFINE l_sql        STRING
DEFINE g_forupd_sql STRING
DEFINE l_from       STRING
DEFINE l_where      STRING
DEFINE l_img        RECORD  
       img01        LIKE img_file.img01,
       img02        LIKE img_file.img02,                   
       img03        LIKE img_file.img03,                   
       img04        LIKE img_file.img04                    
                    END RECORD
                
   WHENEVER ERROR CONTINUE

   IF cl_null(p_type) THEN
      RETURN
   END IF

   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
   LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(p_plant,'azw_file'),
               " WHERE azw01 = '",p_plant,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE sel_azw_pre FROM l_sql
   EXECUTE sel_azw_pre INTO p_legal
   
   LET l_ins = "INSERT INTO img_file(",
                   " img01, ",      #料件编号
                   " img02, ",      #仓库编号
                   " img03, ",      #储位
                   " img04, ",      #批号
                   " img05, ",      #参考号码
                   " img06, ",      #参考序号
                   " img07, ",      #采购单位
                   " img08, ",      #收货数量
                   " img09, ",      #库存单位
                   " img10, ",      #库存数量
                   " img11, ",      #No Use
                   " img12, ",      #No Use
                   " img13, ",      #制造日期
                   " img14, ",      #最近一次盘点日期
                   " img15, ",      #最近一次收料日期
                   " img16, ",      #最近一次发料日期
                   " img17, ",      #最近一次异动日期
                   " img18, ",      #有效日期
                   " img19, ",      #库存等级
                   " img20, ",      #单位数量换算率
                   " img21, ",      #单位数量换算率-对料件库存单位
                   " img22, ",      #仓位类型
                   " img23, ",      #是否为可用仓位
                   " img24, ",      #是否为ＭＲＰ可用仓位
                   " img25, ",      #保税与否
                   " img26, ",      #仓位所属会计科目
                   " img27, ",      #工单发料优先顺序
                   " img28, ",      #销售出货优先顺序
                   " img30, ",      #直接材料成本
                   " img31, ",      #间接材料成本
                   " img32, ",      #委外加工材料成本
                   " img33, ",      #委外加工人工成本
                   " img34, ",      #库存单位对成本单位的转换率
                   " img35, ",      #项目号码
                   " img36, ",      #外观编号
                   " img37, ",      #呆滞日期
                   " img38, ",      #备注
                   " imglegal, ",   #所属法人
                   " imgplant) "    #所属营运中心
   CASE p_type
      WHEN '1' #出貨單
        #LET l_sel = "SELECT ",
        #            "       ogb04, ",                                                                       #img01       #料件编号
        #            "       COALESCE(ogb09,' '),  ",                                                        #img02       #仓库编号
        #            "       COALESCE(ogb091,' '), ",                                                        #img03       #储位
        #            "       COALESCE(ogb092,' '), ",                                                        #img04       #批号
        #            "       ogb01, ",                                                                       #img05       #参考号码
        #            "       ogb03, ",                                                                       #img06       #参考序号
        #            "       '', ",                                                                          #img07       #采购单位
        #            "       '', ",                                                                          #img08       #收货数量
        #            "       ima25, ",                                                                       #img09       #库存单位
        #            "       '0', ",                                                                         #img10       #库存数量
        #            "       '', ",                                                                          #img11       #No Use
        #            "       '', ",                                                                          #img12       #No Use
        #            "       CASE WHEN ima71 = '0' THEN NULL WHEN ima71 IS NULL THEN NULL ELSE oga02 END, ", #img13       #制造日期
        #            "       oga02, ",                                                                       #img14       #最近一次盘点日期
        #            "       '', ",                                                                          #img15       #最近一次收料日期
        #            "       '', ",                                                                          #img16       #最近一次发料日期
        #            "       oga02, ",                                                                       #img17       #最近一次异动日期
        #            "       CASE WHEN ima71 = '0' THEN CAST('",g_lastdat,"' AS DATE) WHEN ima71 IS NULL THEN CAST('",g_lastdat,"' AS DATE) ELSE ima71 + oga02 END, ", #img18       #有效日期
        #            "       '', ",                                                                          #img19       #库存等级
        #            "       '1', ",                                                                         #img20       #单位数量换算率
        #            "       '1', ",                                                                         #img21       #单位数量换算率-对料件库存单位
        #            "       COALESCE(ime05,imd10,'S'), ",                                                   #img22       #仓位类型
        #            "       COALESCE(ime06,imd11,'Y'), ",                                                   #img23       #是否为可用仓位
        #            "       COALESCE(ime07,imd12,'Y'), ",                                                   #img24       #是否为ＭＲＰ可用仓位
        #            "       COALESCE(ime08,imd13,'N'), ",                                                   #img25       #保税与否
        #            "       COALESCE(ime09,imd08,NULL), ",                                                  #img26       #仓位所属会计科目
        #            "       COALESCE(ime10,imd14,NULL), ",                                                  #img27       #工单发料优先顺序
        #            "       COALESCE(ime11,imd15,NULL), ",                                                  #img28       #销售出货优先顺序
        #            "       '0', ",                                                                         #img30       #直接材料成本
        #            "       '0', ",                                                                         #img31       #间接材料成本
        #            "       '0', ",                                                                         #img32       #委外加工材料成本
        #            "       '0', ",                                                                         #img33       #委外加工人工成本
        #            "       '1', ",                                                                         #img34       #库存单位对成本单位的转换率
        #            "       '', ",                                                                          #img35       #项目号码
        #            "       '', ",                                                                          #img36       #外观编号
        #            "       oga02, ",                                                                       #img37       #呆滞日期
        #            "       '', ",                                                                          #img38       #备注
        #            "       '",p_legal CLIPPED,"', ",                                                       #imglegal    #所属法人
        #            "       '",p_plant CLIPPED,"' "                                                         #imgplant    #所属营运中心
         LET l_sel = "SELECT DISTINCT ",
                     "       ogb04, ",                                                                       #img01       #料件编号
                     "       COALESCE(ogb09,' '),  ",                                                        #img02       #仓库编号
                     "       COALESCE(ogb091,' '), ",                                                        #img03       #储位
                     "       COALESCE(ogb092,' '), ",                                                        #img04       #批号
                     "       NULL, ",                                                                        #img05       #参考号码
                     "       NULL, ",                                                                        #img06       #参考序号
                     "       '', ",                                                                          #img07       #采购单位
                     "       '', ",                                                                          #img08       #收货数量
                     "       ima25, ",                                                                       #img09       #库存单位
                     "       '0', ",                                                                         #img10       #库存数量
                     "       '', ",                                                                          #img11       #No Use
                     "       '', ",                                                                          #img12       #No Use
                     "       NULL, ",                                                                        #img13       #制造日期
                     "       NULL, ",                                                                        #img14       #最近一次盘点日期
                     "       '', ",                                                                          #img15       #最近一次收料日期
                     "       '', ",                                                                          #img16       #最近一次发料日期
                     "       NULL, ",                                                                        #img17       #最近一次异动日期
                     "       NULL, ",                                                                        #img18       #有效日期
                     "       '', ",                                                                          #img19       #库存等级
                     "       '1', ",                                                                         #img20       #单位数量换算率
                     "       '1', ",                                                                         #img21       #单位数量换算率-对料件库存单位
                     "       COALESCE(ime05,imd10,'S'), ",                                                   #img22       #仓位类型
                     "       COALESCE(ime06,imd11,'Y'), ",                                                   #img23       #是否为可用仓位
                     "       COALESCE(ime07,imd12,'Y'), ",                                                   #img24       #是否为ＭＲＰ可用仓位
                     "       COALESCE(ime08,imd13,'N'), ",                                                   #img25       #保税与否
                     "       COALESCE(ime09,imd08,NULL), ",                                                  #img26       #仓位所属会计科目
                     "       COALESCE(ime10,imd14,NULL), ",                                                  #img27       #工单发料优先顺序
                     "       COALESCE(ime11,imd15,NULL), ",                                                  #img28       #销售出货优先顺序
                     "       '0', ",                                                                         #img30       #直接材料成本
                     "       '0', ",                                                                         #img31       #间接材料成本
                     "       '0', ",                                                                         #img32       #委外加工材料成本
                     "       '0', ",                                                                         #img33       #委外加工人工成本
                     "       '1', ",                                                                         #img34       #库存单位对成本单位的转换率
                     "       '', ",                                                                          #img35       #项目号码
                     "       '', ",                                                                          #img36       #外观编号
                     "       NULL, ",                                                                        #img37       #呆滞日期
                     "       'FORPOS', ",                                                                    #img38       #备注
                     "       '",p_legal CLIPPED,"', ",                                                       #imglegal    #所属法人
                     "       '",p_plant CLIPPED,"' "                                                         #imgplant    #所属营运中心
         LET l_from = 
                     "  FROM ogb_temp ",
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ogb04 = ima01 ",
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ime_file')," ON ogb09 = ime01 AND ogb091 = ime02 ",  "                AND imeacti = 'Y' ",    #FUN-D40103
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'imd_file')," ON ogb091 = imd01 "

                    #"      ,oga_temp "
         LET l_where = 
                     " WHERE ",#ogb01 = oga01 ",
                     "       NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(p_plant,'img_file'),
                     "                    WHERE img01 = ogb04 ",
                     "                      AND img02 = COALESCE(ogb09,' ') ",
                     "                      AND img03 = COALESCE(ogb091,' ') ",
                     "                      AND img04 = COALESCE(ogb092,' ')) ",
                     "   AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC' "
        #IF NOT cl_null(p_no) THEN LET l_where = l_where CLIPPED," AND oga01 = '",p_no,"' " END IF   #FUN-D30017 Mark
         IF NOT cl_null(p_no) THEN LET l_where = l_where CLIPPED," AND ogb01 = '",p_no,"' " END IF   #FUN-D30017 Add
         LET g_forupd_sql = "SELECT img01,img02,img03,img04 ",
                            "  FROM ",cl_get_target_table(p_plant,'img_file'),
                            "      ,ogb_temp ",
                            " WHERE img01 = ogb04 ",
                            "   AND img02 = COALESCE(ogb09,' ') ",
                            "   AND img03 = COALESCE(ogb091,' ') ",
                            "   AND img04 = COALESCE(ogb092,' ') "
         IF NOT cl_null(p_no) THEN LET g_forupd_sql = g_forupd_sql CLIPPED," ogb01 = '",p_no,"' " END IF
         IF NOT cl_null(p_no) THEN
            LET l_upd =
                        "UPDATE ",cl_get_target_table(g_plant_new,'img_file'),
                        "   SET img10 = img10 + (SELECT SUM(ogb16) ",
                        "                          FROM ogb_temp ",
                        "                         WHERE ogb04 = img01 AND ogb01 = '",p_no,"' ",
                        "                           AND COALESCE(ogb09,' ') = img02 ",
                        "                           AND COALESCE(ogb091,' ') = img03 ",
                        "                           AND COALESCE(ogb092,' ') = img04 ",
                        "                           AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        "      ,img16 = '",p_date,"' ",
                        "      ,img17 = '",p_date,"' ",
                        " WHERE EXISTS (SELECT 1 ",
                        "                 FROM ogb_temp ",
                        "                WHERE ogb04 = img01 AND ogb01 = '",p_no,"' ",
                        "                  AND  COALESCE(ogb09,' ') = img02 ",
                        "                  AND  COALESCE(ogb091,' ') = img03 ",
                        "                  AND  COALESCE(ogb092,' ') = img04 ",
                        "                  AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') "
         ELSE
            LET l_upd = 
                        "UPDATE ",cl_get_target_table(g_plant_new,'img_file'),
                        "   SET img10 = img10 + (SELECT SUM(ogb16) ",
                        "                          FROM ogb_temp ",
                        "                         WHERE ogb04 = img01 ",
                        "                           AND COALESCE(ogb09,' ') = img02 ",
                        "                           AND COALESCE(ogb091,' ') = img03 ",
                        "                           AND COALESCE(ogb092,' ') = img04 ",
                        "                           AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        "      ,img16 = (SELECT MAX(oga02) FROM oga_temp,ogb_temp ",
                        "                 WHERE oga01 = ogb01 AND ogb04 = img01 ",
                        "                   AND COALESCE(ogb09,' ') = img02 ",
                        "                   AND COALESCE(ogb091,' ') = img03 ",
                        "                   AND COALESCE(ogb092,' ') = img04 ",
                        "                   AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        "      ,img17 = (SELECT MAX(oga02) FROM oga_temp,ogb_temp ",
                        "                 WHERE oga01 = ogb01 AND ogb04 = img01 ",
                        "                   AND COALESCE(ogb09,' ') = img02 ",
                        "                   AND COALESCE(ogb091,' ') = img03 ",
                        "                   AND COALESCE(ogb092,' ') = img04 ",
                        "                   AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT 1 ",
                        "                 FROM ogb_temp ",
                        "                WHERE ogb04 = img01 ",
                        "                  AND  COALESCE(ogb09,' ') = img02 ",
                        "                  AND  COALESCE(ogb091,' ') = img03 ",
                        "                  AND  COALESCE(ogb092,' ') = img04 ",
                        "                  AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') "
         END IF
      WHEN '2' #銷退單
         LET l_sel = "SELECT ",
                     "       ohb04, ",                                                                       #img01       #料件编号
                     "       COALESCE(ohb09,' '),  ",                                                        #img02       #仓库编号
                     "       COALESCE(ohb091,' '), ",                                                        #img03       #储位
                     "       COALESCE(ohb092,' '), ",                                                        #img04       #批号
                     "       ohb01, ",                                                                       #img05       #参考号码
                     "       ohb03, ",                                                                       #img06       #参考序号
                     "       '', ",                                                                          #img07       #采购单位
                     "       '', ",                                                                          #img08       #收货数量
                     "       ima25, ",                                                                       #img09       #库存单位
                     "       '0', ",                                                                         #img10       #库存数量
                     "       '', ",                                                                          #img11       #No Use
                     "       '', ",                                                                          #img12       #No Use
                     "       CASE WHEN ima71 = '0' THEN NULL WHEN ima71 IS NULL THEN NULL ELSE oha02 END, ", #img13       #制造日期
                     "       oha02, ",                                                                       #img14       #最近一次盘点日期
                     "       '', ",                                                                          #img15       #最近一次收料日期
                     "       '', ",                                                                          #img16       #最近一次发料日期
                     "       oha02, ",                                                                       #img17       #最近一次异动日期
                     "       CASE WHEN ima71 = '0' THEN CAST('",g_lastdat,"' AS DATE) WHEN ima71 IS NULL THEN CAST('",g_lastdat,"' AS DATE) ELSE ima71 + oha02 END, ", #img18       #有效日期
                     "       '', ",                                                                          #img19       #库存等级
                     "       '1', ",                                                                         #img20       #单位数量换算率
                     "       '1', ",                                                                         #img21       #单位数量换算率-对料件库存单位
                     "       COALESCE(ime05,imd10,'S'), ",                                                   #img22       #仓位类型
                     "       COALESCE(ime06,imd11,'Y'), ",                                                   #img23       #是否为可用仓位
                     "       COALESCE(ime07,imd12,'Y'), ",                                                   #img24       #是否为ＭＲＰ可用仓位
                     "       COALESCE(ime08,imd13,'N'), ",                                                   #img25       #保税与否
                     "       COALESCE(ime09,imd08,NULL), ",                                                  #img26       #仓位所属会计科目
                     "       COALESCE(ime10,imd14,NULL), ",                                                  #img27       #工单发料优先顺序
                     "       COALESCE(ime11,imd15,NULL), ",                                                  #img28       #销售出货优先顺序
                     "       '0', ",                                                                         #img30       #直接材料成本
                     "       '0', ",                                                                         #img31       #间接材料成本
                     "       '0', ",                                                                         #img32       #委外加工材料成本
                     "       '0', ",                                                                         #img33       #委外加工人工成本
                     "       '1', ",                                                                         #img34       #库存单位对成本单位的转换率
                     "       '', ",                                                                          #img35       #项目号码
                     "       '', ",                                                                          #img36       #外观编号
                     "       oha02, ",                                                                       #img37       #呆滞日期
                     "       '', ",                                                                          #img38       #备注
                     "       '",p_legal CLIPPED,"', ",                                                       #imglegal    #所属法人
                     "       '",p_plant CLIPPED,"' "                                                         #imgplant    #所属营运中心
         LET l_from = 
                     "  FROM ohb_temp ",
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ohb04 = ima01 ",
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ime_file')," ON ohb09 = ime01 AND ohb091 = ime02 ",  "                AND imeacti = 'Y' ",    #FUN-D40103
                     "                LEFT OUTER JOIN ",cl_get_target_table(p_plant,'imd_file')," ON ohb091 = imd01 ",
                     "      ,oha_temp "
         LET l_where = 
                     " WHERE ohb01 = oha01 ",
                     "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(p_plant,'img_file'),
                     "                    WHERE img01 = ohb04 ",
                     "                      AND img02 = COALESCE(ohb09,' ') ",
                     "                      AND img03 = COALESCE(ohb091,' ') ",
                     "                      AND img04 = COALESCE(ohb092,' ')) ",
                     "   AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC' "
         IF NOT cl_null(p_no) THEN LET l_where = l_where CLIPPED," AND oha01 = '",p_no,"' " END IF
         LET g_forupd_sql = "SELECT img01,img02,img03,img04 ",
                            "  FROM ",cl_get_target_table(p_plant,'img_file'),
                            "      ,ohb_temp ",
                            " WHERE img01 = ohb04 ",
                            "   AND img02 = COALESCE(ohb09,' ') ",
                            "   AND img03 = COALESCE(ohb091,' ') ",
                            "   AND img04 = COALESCE(ohb092,' ') "
         IF NOT cl_null(p_no) THEN LET g_forupd_sql = g_forupd_sql CLIPPED," ohb01 = '",p_no,"' " END IF
         IF NOT cl_null(p_no) THEN
            LET l_upd =      
                        "UPDATE ",cl_get_target_table(g_plant_new,'img_file'),                               
                        "   SET img10 = img10 - (SELECT SUM(ohb16) ",                                        
                        "                          FROM ohb_temp ",                                          
                        "                         WHERE ohb04 = img01 AND ohb01 = '",p_no,"' ",                                     
                        "                           AND  COALESCE(ohb09,' ') = img02 ",                      
                        "                           AND  COALESCE(ohb091,' ') = img03 ",
                        "                           AND  COALESCE(ohb092,' ') = img04 ",
                        "                           AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        "      ,img16 = '",p_date,"' ",
                        "      ,img17 = '",p_date,"' ",
                        " WHERE EXISTS (SELECT 1 ",
                        "                 FROM ohb_temp ",
                        "                WHERE ohb04 = img01 AND ohb01 = '",p_no,"' ",
                        "                  AND  COALESCE(ohb09,' ') = img02 ",
                        "                  AND  COALESCE(ohb091,' ') = img03 ",
                        "                  AND  COALESCE(ohb092,' ') = img04 ",
                        "                  AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') "
         ELSE   
            LET l_upd = 
                        "UPDATE ",cl_get_target_table(g_plant_new,'img_file'),
                        "   SET img10 = img10 - (SELECT SUM(ohb16) ",
                        "                          FROM ohb_temp ",
                        "                         WHERE ohb04 = img01 ",
                        "                           AND  COALESCE(ohb09,' ') = img02 ",
                        "                           AND  COALESCE(ohb091,' ') = img03 ",
                        "                           AND  COALESCE(ohb092,' ') = img04 ",                        
                        "                           AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        "      ,img16 = (SELECT MAX(oha02) FROM oha_temp,ohb_temp ",                                 
                        "                 WHERE oha01 = ohb01 AND ohb04 = img01 ",                              
                        "                   AND COALESCE(ohb09,' ') = img02 ",                                  
                        "                   AND COALESCE(ohb091,' ') = img03 ",                                 
                        "                   AND COALESCE(ohb092,' ') = img04 ",                                
                        "                   AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        "      ,img17 = (SELECT MAX(oha02) FROM oha_temp,ohb_temp ",                                 
                        "                 WHERE oha01 = ohb01 AND ohb04 = img01 ",
                        "                   AND COALESCE(ohb09,' ') = img02 ",
                        "                   AND COALESCE(ohb091,' ') = img03 ",
                        "                   AND COALESCE(ohb092,' ') = img04 ",
                        "                   AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT 1 ",
                        "                 FROM ohb_temp ",
                        "                WHERE ohb04 = img01 ",
                        "                  AND  COALESCE(ohb09,' ') = img02 ",
                        "                  AND  COALESCE(ohb091,' ') = img03 ",
                        "                  AND  COALESCE(ohb092,' ') = img04 ",
                        "                  AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') "
         END IF
   END CASE 

   #新增img
   LET l_sql = l_ins CLIPPED," ",l_sel CLIPPED," ",l_from CLIPPED," ",l_where CLIPPED
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE ins_img_pre FROM l_sql
   EXECUTE ins_img_pre
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
     #FUN-CB0103 Add Begin ---
      LET g_errno   = SQLCA.sqlcode
      LET g_msg1    = 'Oper:Ins'||' '||'Table:img_file'||' '||'Shop:'||p_plant
      CALL s_errmsg('Batch Operation:','',g_msg1,SQLCA.sqlcode,1)
      ROLLBACK WORK
     #FUN-CB0103 Add End -----
      RETURN      
   END IF
   DISPLAY "INS IMG 成功笔数: ",SQLCA.sqlerrd[3]

   #更新
   IF p_type = '1' THEN #FUN-CA0160 Add
      LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'img_file'),
                  "   SET (img05,img06,img13,img14,img17,img18,img37,img38) = ",
                  "       (SELECT ogb01,ogb03, ",
                  "               CASE WHEN ima71 = '0' THEN NULL WHEN ima71 IS NULL THEN NULL ELSE oga02 END, ",
                  "               oga02,oga02, ",
                  "               CASE WHEN ima71 = '0' THEN CAST('",g_lastdat,"' AS DATE) ",
                  "                    WHEN ima71 IS NULL THEN CAST('",g_lastdat,"' AS DATE) ELSE ima71 + oga02 END, ",
                  "               oga02,'' ",
                  "          FROM ogb_temp LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ogb04 = ima01 ",
                  "              ,oga_temp ",
                  "         WHERE oga01 = ogb01 AND ogb04 = img01 AND COALESCE(ogb09,' ') = img02 ",
                  "           AND COALESCE(ogb091,' ') = img03 AND COALESCE(ogb092,' ') = img04 ",
                  "           AND ROWNUM = 1) ",
                  " WHERE img38 = 'FORPOS' "
   END IF #FUN-CA0160 Add
  #FUN-CA0160 Add Begin ---
   IF p_type = '2' THEN
      LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'img_file'),
                  "   SET (img05,img06,img13,img14,img17,img18,img37,img38) = ",
                  "       (SELECT ohb01,ohb03, ",
                  "               CASE WHEN ima71 = '0' THEN NULL WHEN ima71 IS NULL THEN NULL ELSE oha02 END, ",
                  "               oha02,oha02, ",
                  "               CASE WHEN ima71 = '0' THEN CAST('",g_lastdat,"' AS DATE) ",
                  "                    WHEN ima71 IS NULL THEN CAST('",g_lastdat,"' AS DATE) ELSE ima71 + oha02 END, ",
                  "               oha02,'' ",
                  "          FROM ohb_temp LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ohb04 = ima01 ",
                  "              ,oha_temp ",
                  "         WHERE oha01 = ohb01 AND ohb04 = img01 AND COALESCE(ohb09,' ') = img02 ",
                  "           AND COALESCE(ohb091,' ') = img03 AND COALESCE(ohb092,' ') = img04 ",
                  "           AND ROWNUM = 1) ",
                  " WHERE img38 = 'FORPOS' "
   END IF
  #FUN-CA0160 Add End -----

   PREPARE upd_img_pre2 FROM l_sql
   EXECUTE upd_img_pre2

   #锁资料
   LET g_forupd_sql = g_forupd_sql CLIPPED," FOR UPDATE "
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE sel_img_lock CURSOR FROM g_forupd_sql
   OPEN sel_img_lock
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
     #FUN-CB0103 Add Begin ---
      LET g_errno   = SQLCA.sqlcode
      LET g_msg1    = 'Oper:Sel(Open Cursor)'||' '||'Table:img_file'||' '||'Shop:'||p_plant
      CALL s_errmsg('Batch Operation:','',g_msg1,SQLCA.sqlcode,1)
     #FUN-CB0103 Add End -----
      CLOSE sel_img_lock
      RETURN
   END IF 
   FETCH sel_img_lock INTO l_img.*
   IF SQLCA.sqlcode THEN 
      LET g_success = 'N'
     #FUN-CB0103 Add Begin ---
      LET g_errno   = SQLCA.sqlcode
      LET g_msg1    = 'Oper:Sel(Fetch Cursor)'||' '||'Table:img_file'||' '||'Shop:'||p_plant
      CALL s_errmsg('Batch Operation:','',g_msg1,SQLCA.sqlcode,1)
     #FUN-CB0103 Add End -----
      CLOSE sel_img_lock
      RETURN
   END IF    

   #更新img
   CALL cl_replace_sqldb(l_upd) RETURNING l_upd
   PREPARE upd_img_pre FROM l_upd
   EXECUTE upd_img_pre
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
     #FUN-CB0103 Add Begin ---
      LET g_errno   = SQLCA.sqlcode
      LET g_msg1    = 'Oper:Upd'||' '||'Table:img_file'||' '||'Shop:'||p_plant
      CALL s_errmsg('Batch Operation:','',g_msg1,SQLCA.sqlcode,1)
      ROLLBACK WORK
     #FUN-CB0103 Add End -----
      CLOSE sel_img_lock
      RETURN
   END IF
   DISPLAY "UPD IMG 成功笔数: ",SQLCA.sqlerrd[3]

   CLOSE sel_img_lock
END FUNCTION 

#FUN-CA0091
