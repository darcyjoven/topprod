# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_instlf_p.4gl
# Descriptions...: 批次新增庫存異動檔
# Date & Author..: No.FUN-CA0091 12/10/14 By baogc
# Modify.........: No:FUN-CA0160 12/11/16 By baogc 邏輯調整
# Modify.........: No:FUN-CB0103 12/11/28 By baogc 邏輯調整

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../apc/4gl/sapcp200.global" #FUN-CB0103 Add


FUNCTION s_instlf_p(p_type,p_no,p_plant)
DEFINE p_type  LIKE type_file.chr1
DEFINE p_no    LIKE oga_file.oga01
DEFINE p_plant LIKE azw_file.azw01
DEFINE p_legal LIKE azw_file.azw02
DEFINE l_ins   STRING
DEFINE l_upd   STRING
DEFINE l_sel   STRING
DEFINE l_sql   STRING
DEFINE l_from  STRING
DEFINE l_order STRING
DEFINE l_time  LIKE type_file.chr8

   WHENEVER ERROR CONTINUE

   IF cl_null(p_type) THEN RETURN END IF

   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
   LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(p_plant,'azw_file'),
               " WHERE azw01 = '",p_plant,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   PREPARE sel_azw_pre FROM l_sql
   EXECUTE sel_azw_pre INTO p_legal


   LET l_time = TIME
   CASE p_type
      WHEN '1'
         LET l_from = 
                     "  FROM ogb_temp ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ogb04 = ima01 ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'imd_file')," ON imd01 = ogb09 ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'img_file')," ON (img01 = ogb04 ",
                     "                                                                       AND img02 = COALESCE(ogb09,' ') ",
                     "                                                                       AND img03 = COALESCE(ogb091,' ') ",
                     "                                                                       AND img04 = COALESCE(ogb092,' ')) ",
                     "      ,oga_temp ",
                     " WHERE ogb01 = oga01 AND ogb04 = ima01 AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC' AND ima120 <> '2' "
         IF NOT cl_null(p_no) THEN LET l_from = l_from CLIPPED," AND oga01 = '",p_no,"' " END IF
         LET l_order = " ORDER BY oga01,ogb03 "
         IF NOT cl_null(p_no) THEN
            LET l_upd = "UPDATE ",cl_get_target_table(p_plant,'tlf_file'),
                        "   SET tlf024 = tlf024 + (SELECT SUM(ogb16) FROM ogb_temp ",
                        "                           WHERE ogb04 = tlf01 AND ogb01 = '",p_no,"' ",
                        "                             AND ((ogb01 = tlf026 AND ogb03 > tlf027) OR (ogb01 > tlf026)) ",
                        "                             AND COALESCE(ogb09,' ') = tlf902 ",
                        "                             AND COALESCE(ogb091,' ') = tlf903 ",
                        "                             AND COALESCE(ogb092,' ') = tlf904 ",
                        "                             AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT COUNT(ogb04) FROM ogb_temp ",
                        "                WHERE ogb01 = tlf026 ",
                        "                  AND ogb03 = tlf027 ",
                        "                  AND ogb01 = '",p_no,"') "
         ELSE
            LET l_upd = "UPDATE ",cl_get_target_table(p_plant,'tlf_file'),
                        "   SET tlf024 = tlf024 + (SELECT SUM(ogb16) FROM ogb_temp ",
                        "                           WHERE ogb04 = tlf01 ",
                        "                             AND ((ogb01 = tlf026 AND ogb03 > tlf027) OR (ogb01 > tlf026)) ",
                        "                             AND COALESCE(ogb09,' ') = tlf902 ",
                        "                             AND COALESCE(ogb091,' ') = tlf903 ",
                        "                             AND COALESCE(ogb092,' ') = tlf904 ",
                        "                             AND ogb44 <> '4' AND ogb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
                        "                WHERE ogb01 = tlf026 ",
                        "                  AND ogb03 = tlf027) "
         END IF
         LET l_sel = "SELECT ",
                             " ogb04, ",                                            #tlf01           #异动料件编号
                             " 50, ",                                               #tlf02           #来源状况
                             " ogb08, ",                                            #tlf020          #异动来源营运中心编号
                             " COALESCE(ogb09,' '), ",                              #tlf021          #仓库
                             " COALESCE(ogb091,' '), ",                             #tlf022          #库位
                             " COALESCE(ogb092,' '), ",                             #tlf023          #批号
                            #" img10, ",                                            #tlf024          #异动后库存数量
                             " 0, ",                                                #tlf024          #异动后库存数量
                             " ima25, ",                                            #tlf025          #异动后库存数量单位
                             " ogb01, ",                                            #tlf026          #单据编号
                             " COALESCE(ogb03,0), ",                                #tlf027          #单据项次
                             " 724, ",                                              #tlf03           #目的状况
                             " ' ', ",                                              #tlf030          #异动目的营运中心编号
                             " ' ', ",                                              #tlf031          #仓库
                             " ' ', ",                                              #tlf032          #库位
                             " ' ', ",                                              #tlf033          #批号
                             " NULL, ",                                             #tlf034          #异动后库存数量
                             " ' ', ",                                              #tlf035          #异动后库存数量单位
                             " ogb31, ",                                            #tlf036          #单据编号
                             " COALESCE(ogb32,0), ",                                #tlf037          #单据项次
                             " ' ', ",                                              #tlf04           #工作站
                             " ' ', ",                                              #tlf05           #作业编号
                             " oga02, ",                                            #tlf06           #单据扣帐日期
                             " '",g_today,"', ",                                    #tlf07           #运行扣帐日期
                             " '",l_time,"', ",                                     #tlf08           #异动资料生成时间
                             " '",g_user,"', ",                                     #tlf09           #异动资料发出者
                             " ogb16, ",                                            #tlf10           #异动数量
                             " ogb05, ",                                            #tlf11           #异动数量单位
                             " COALESCE(ogb15_fac,1), ",                            #tlf12           #异动数量单位与异动目的数量单位转换率
                             " 'axmt620', ",                                        #tlf13           #异动指令编号
                             " ogb1001, ",                                          #tlf14           #异动原因
                             " NULL,",                                              #tlf15           #借方会计科目
                             " NULL,",                                              #tlf16           #贷方会计科目
                             " ' ', ",                                              #tlf17           #备注
                            #" (SELECT COALESCE(SUM(img10*img21),0) ",              #tlf18           #异动后总库存量
                            #"    FROM ",cl_get_target_table(p_plant,'img_file'),
                            #"   WHERE img01 = ogb04 ",
                            #"     AND img02 = COALESCE(ogb09,' ') ",
                            #"     AND img03 = COALESCE(ogb091,' ') ",
                            #"     AND img04 = COALESCE(ogb092,' ')), ",
                             " COALESCE(img10,0), ",                                #tlf18           #异动后总库存量
                             " oga03, ",                                            #tlf19           #异动厂商/客户编号/部门编号
                             " oga46, ",                                            #tlf20           #项目号码
                             " NULL, ",                                             #tlf21           #成会异动成本
                             " NULL, ",                                             #tlf211          #成会计算日期
                             " NULL, ",                                             #tlf212          #成会计算时间
                             " NULL, ",                                             #tlf2131         #No Use
                             " NULL, ",                                             #tlf2132         #No Use
                             " NULL, ",                                             #tlf214          #No Use
                             " NULL, ",                                             #tlf215          #No Use
                             " NULL, ",                                             #tlf2151         #No Use
                             " NULL, ",                                             #tlf216          #No Use
                             " NULL, ",                                             #tlf2171         #No Use
                             " NULL, ",                                             #tlf2172         #No Use
                             " NULL, ",                                             #tlf219          #1.第二单位   2.第一单位
                             " NULL, ",                                             #tlf218          #第二单位的rowid内容
                             " NULL, ",                                             #tlf220          #单位  双单位的单位
                             " NULL, ",                                             #tlf221          #材料成本
                             " NULL, ",                                             #tlf222          #人工成本
                             " NULL, ",                                             #tlf2231         #制费一成本
                             " NULL, ",                                             #tlf2232         #加工成本
                             " NULL, ",                                             #tlf224          #制费二成本
                             " NULL, ",                                             #tlf225          #No Use
                             " NULL, ",                                             #tlf2251         #No Use
                             " NULL, ",                                             #tlf226          #No Use
                             " NULL, ",                                             #tlf2271         #No Use
                             " NULL, ",                                             #tlf2272         #No Use
                             " NULL, ",                                             #tlf229          #No Use
                             " NULL, ",                                             #tlf230          #No Use
                             " NULL, ",                                             #tlf231          #No Use
                             " COALESCE(img21,1), ",                                #tlf60           #异动单据单位对库存单位之换算率
                             " ogb01[1,",g_doc_len,"], ",                           #tlf61           #单别
                             " ogb31, ",                                            #tlf62           #工单单号
                             " ogb32, ",                                            #tlf63           #No Use
                             " ogb908, ",                                           #tlf64           #手册编号
                             " NULL, ",                                             #tlf65           #凭证编号
                             " NULL, ",                                             #tlf66           #多仓出货 Flag
                             " imd09, ",                                            #tlf901          #成本仓库
                             " COALESCE(ogb09,' '), ",                              #tlf902          #仓库
                             " COALESCE(ogb091,' '), ",                             #tlf903          #库位
                             " COALESCE(ogb092,' '), ",                             #tlf904          #批号
                             " ogb01, ",                                            #tlf905          #单号
                             " ogb03, ",                                            #tlf906          #项次
                             " '-1', ",                                             #tlf907          #入出库码
                             " NULL, ",                                             #tlf908          #保税审核否
                             " NULL, ",                                             #tlf909          #保税撷取否
                             " NULL, ",                                             #tlf910          #合同撷取否
                             " oga99, ",                                            #tlf99           #多角序号
                             " ogb930, ",                                           #tlf930          #成本中心
                             " NULL, ",                                             #tlf931          #内部成本
                             " NULL, ",                                             #tlf151          #借方会计科目二
                             " NULL, ",                                             #tlf161          #贷方会计科目二
                             " NULL, ",                                             #tlf2241         #制费三成本
                             " NULL, ",                                             #tlf2242         #制费四成本
                             " NULL, ",                                             #tlf2243         #制费五成本
                             " NULL, ",                                             #tlfcost         #类型编号(批次号/专案号/利润中心)
                             " ogb42, ",                                            #tlf41           #WBS编号
                             " ogb43, ",                                            #tlf42           #活动编号
                             " ogb1001, ",                                          #tlf43           #理由码
                             " NULL, ",                                             #tlf211x         #成会计算日期
                             " NULL, ",                                             #tlf212x         #成会计算时间
                             " NULL, ",                                             #tlf21x          #成会异动成本
                             " NULL, ",                                             #tlf221x         #材料成本
                             " NULL, ",                                             #tlf222x         #人工成本
                             " NULL, ",                                             #tlf2231x        #制费一成本
                             " NULL, ",                                             #tlf2232x        #加工成本
                             " NULL, ",                                             #tlf2241x        #制费三成本
                             " NULL, ",                                             #tlf2242x        #制费四成本
                             " NULL, ",                                             #tlf2243x        #制费五成本
                             " NULL, ",                                             #tlf224x         #制费二成本
                             " NULL, ",                                             #tlf65x          #凭证编号
                             " '",p_plant,"', ",                                    #tlfplant        #所属营运中心
                             " '",p_legal,"', ",                                    #tlflegal        #所属法人
                             " NULL, ",                                             #tlf27           #被替代料号
                             " NULL, ",                                             #tlf28           #成会分类
                             " ' ', ",                                              #tlf012          #工艺段号
                             " '0' "                                                #tlf013          #工艺序
      WHEN '2'
         LET l_from = 
                     "  FROM ohb_temp ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'ima_file')," ON ohb04 = ima01 ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'imd_file')," ON imd01 = ohb09 ",
                     "            LEFT OUTER JOIN ",cl_get_target_table(p_plant,'img_file')," ON (img01 = ohb04 ",
                     "                                                                       AND img02 = COALESCE(ohb09,' ') ",
                     "                                                                       AND img03 = COALESCE(ohb091,' ') ",
                     "                                                                       AND img04 = COALESCE(ohb092,' ')) ",
                     "      ,oha_temp ",
                     " WHERE ohb01 = oha01 AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC' AND ima120 <> '2' "
         IF NOT cl_null(p_no) THEN LET l_from = l_from CLIPPED," AND oha01 = '",p_no,"' " END IF
         LET l_order = " ORDER BY oha01,ohb03 "
         IF NOT cl_null(p_no) THEN
            LET l_upd = "UPDATE ",cl_get_target_table(p_plant,'tlf_file'),
                        "   SET tlf024 = tlf024 - (SELECT SUM(ohb16) FROM ohb_temp ",
                        "                           WHERE ohb04 = tlf01 AND ohb01 = '",p_no,"' ",
                        "                             AND ((ohb01 = tlf026 AND ohb03 > tlf027) OR (ohb01 > tlf026)) ",
                        "                             AND COALESCE(ohb09,' ') = tlf902 ",
                        "                             AND COALESCE(ohb091,' ') = tlf903 ",
                        "                             AND COALESCE(ohb092,' ') = tlf904 ",
                        "                             AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT 1 FROM ohb_temp ",
                        "                WHERE ohb01 = tlf026 ",
                        "                  AND ohb03 = tlf027 ",
                        "                  AND ohb01 = '",p_no,"') "
         ELSE
            LET l_upd = "UPDATE ",cl_get_target_table(p_plant,'tlf_file'),
                        "   SET tlf024 = tlf024 - (SELECT SUM(ohb16) FROM ohb_temp ",
                        "                           WHERE ohb04 = tlf01 ",
                        "                             AND ((ohb01 = tlf026 AND ohb03 > tlf027) OR (ohb01 > tlf026)) ",
                        "                             AND COALESCE(ohb09,' ') = tlf902 ",
                        "                             AND COALESCE(ohb091,' ') = tlf903 ",
                        "                             AND COALESCE(ohb092,' ') = tlf904 ",
                        "                             AND ohb64 <> '4' AND ohb04[1,4] <> 'MISC') ",
                        " WHERE EXISTS (SELECT 1 FROM ohb_temp ",
                        "                WHERE ohb01 = tlf026 ",
                        "                  AND ohb03 = tlf027) "
         END IF
         LET l_sel = "SELECT ",
                             " ohb04, ",                                            #tlf01           #异动料件编号
                             " 731, ",                                              #tlf02           #来源状况
                             " ' ', ",                                              #tlf020          #异动来源营运中心编号
                             " ' ', ",                                              #tlf021          #仓库
                             " ' ', ",                                              #tlf022          #库位
                             " ' ', ",                                              #tlf023          #批号
                             " 0, ",                                                #tlf024          #异动后库存数量
                             " ' ', ",                                              #tlf025          #异动后库存数量单位
                             " ohb01, ",                                            #tlf026          #单据编号
                             " COALESCE(ohb03,0), ",                                #tlf027          #单据项次
                             " 50, ",                                               #tlf03           #目的状况
                             " ohb08, ",                                            #tlf030          #异动目的营运中心编号
                             " ohb09, ",                                            #tlf031          #仓库
                            #" ohb091, ",                                           #tlf032          #库位 #FUN-CA0160 Mark
                             " COALESCE(ohb091,' '), ",                             #tlf032          #库位 #FUN-CA0160 Add
                            #" ohb092, ",                                           #tlf033          #批号 #FUN-CA0160 Mark
                             " COALESCE(ohb092,' '), ",                             #tlf033          #批号 #FUN-CA0160 Add
                            #" img10, ",                                            #tlf034          #异动后库存数量
                             " 0, ",                                                #tlf034          #异动后库存数量
                             " ima25, ",                                            #tlf035          #异动后库存数量单位
                             " ohb01, ",                                            #tlf036          #单据编号
                             " COALESCE(ohb03,0), ",                                #tlf037          #单据项次
                             " ' ', ",                                              #tlf04           #工作站
                             " ' ', ",                                              #tlf05           #作业编号
                             " oha02, ",                                            #tlf06           #单据扣帐日期
                             " '",g_today,"', ",                                    #tlf07           #运行扣帐日期
                             " '",l_time,"', ",                                     #tlf08           #异动资料生成时间
                             " '",g_user,"', ",                                     #tlf09           #异动资料发出者
                             " ABS(ohb12), ",                                       #tlf10           #异动数量
                             " ohb05, ",                                            #tlf11           #异动数量单位
                             " COALESCE(ohb15_fac,1), ",                            #tlf12           #异动数量单位与异动目的数量单位转换率
                             " 'aomt800', ",                                        #tlf13           #异动指令编号
                             " ohb50, ",                                            #tlf14           #异动原因
                             " NULL,",                                              #tlf15           #借方会计科目
                             " NULL,",                                              #tlf16           #贷方会计科目
                             " ' ', ",                                              #tlf17           #备注
                            #" (SELECT COALESCE(SUM(img10*img21),0) ",              #tlf18           #异动后总库存量
                            #"    FROM ",cl_get_target_table(p_plant,'img_file'),
                            #"   WHERE img01 = ohb04 ",
                            #"     AND img02 = COALESCE(ohb09,' ') ",
                            #"     AND img03 = COALESCE(ohb091,' ') ",
                            #"     AND img04 = COALESCE(ohb092,' ')), ",
                             " COALESCE(img10,0), ",                                #tlf18           #异动后总库存量  #FUN-CA0160 ReMark
                             " oha03, ",                                            #tlf19           #异动厂商/客户编号/部门编号
                             " NULL, ",                                             #tlf20           #项目号码
                             " NULL, ",                                             #tlf21           #成会异动成本
                             " NULL, ",                                             #tlf211          #成会计算日期
                             " NULL, ",                                             #tlf212          #成会计算时间
                             " NULL, ",                                             #tlf2131         #No Use
                             " NULL, ",                                             #tlf2132         #No Use
                             " NULL, ",                                             #tlf214          #No Use
                             " NULL, ",                                             #tlf215          #No Use
                             " NULL, ",                                             #tlf2151         #No Use
                             " NULL, ",                                             #tlf216          #No Use
                             " NULL, ",                                             #tlf2171         #No Use
                             " NULL, ",                                             #tlf2172         #No Use
                             " NULL, ",                                             #tlf219          #1.第二单位   2.第一单位
                             " NULL, ",                                             #tlf218          #第二单位的rowid内容
                             " NULL, ",                                             #tlf220          #单位  双单位的单位
                             " NULL, ",                                             #tlf221          #材料成本
                             " NULL, ",                                             #tlf222          #人工成本
                             " NULL, ",                                             #tlf2231         #制费一成本
                             " NULL, ",                                             #tlf2232         #加工成本
                             " NULL, ",                                             #tlf224          #制费二成本
                             " NULL, ",                                             #tlf225          #No Use
                             " NULL, ",                                             #tlf2251         #No Use
                             " NULL, ",                                             #tlf226          #No Use
                             " NULL, ",                                             #tlf2271         #No Use
                             " NULL, ",                                             #tlf2272         #No Use
                             " NULL, ",                                             #tlf229          #No Use
                             " NULL, ",                                             #tlf230          #No Use
                             " NULL, ",                                             #tlf231          #No Use
                             " COALESCE(img21,1), ",                                #tlf60           #异动单据单位对库存单位之换算率
                             " ohb01[1,",g_doc_len,"], ",                           #tlf61           #单别
                             " ohb33, ",                                            #tlf62           #工单单号
                             " NULL, ",                                             #tlf63           #No Use
                             " ohb52, ",                                            #tlf64           #手册编号
                             " NULL, ",                                             #tlf65           #凭证编号
                             " NULL, ",                                             #tlf66           #多仓出货 Flag
                             " imd09, ",                                            #tlf901          #成本仓库
                             " COALESCE(ohb09,' '), ",                              #tlf902          #仓库
                             " COALESCE(ohb091,' '), ",                             #tlf903          #库位
                             " COALESCE(ohb092,' '), ",                             #tlf904          #批号
                             " ohb01, ",                                            #tlf905          #单号
                             " ohb03, ",                                            #tlf906          #项次
                            #" '-1', ",                                             #tlf907          #入出库码 #FUN-CA0160 Mark
                             " '1', ",                                              #tlf907          #入出库码 #FUN-CA0160 Add
                             " NULL, ",                                             #tlf908          #保税审核否
                             " NULL, ",                                             #tlf909          #保税撷取否
                             " NULL, ",                                             #tlf910          #合同撷取否
                             " oha99, ",                                            #tlf99           #多角序号
                             " ohb930, ",                                           #tlf930          #成本中心
                             " NULL, ",                                             #tlf931          #内部成本
                             " NULL, ",                                             #tlf151          #借方会计科目二
                             " NULL, ",                                             #tlf161          #贷方会计科目二
                             " NULL, ",                                             #tlf2241         #制费三成本
                             " NULL, ",                                             #tlf2242         #制费四成本
                             " NULL, ",                                             #tlf2243         #制费五成本
                             " NULL, ",                                             #tlfcost         #类型编号(批次号/专案号/利润中心)
                             " NULL, ",                                             #tlf41           #WBS编号
                             " NULL, ",                                             #tlf42           #活动编号
                             " NULL, ",                                             #tlf43           #理由码
                             " NULL, ",                                             #tlf211x         #成会计算日期
                             " NULL, ",                                             #tlf212x         #成会计算时间
                             " NULL, ",                                             #tlf21x          #成会异动成本
                             " NULL, ",                                             #tlf221x         #材料成本
                             " NULL, ",                                             #tlf222x         #人工成本
                             " NULL, ",                                             #tlf2231x        #制费一成本
                             " NULL, ",                                             #tlf2232x        #加工成本
                             " NULL, ",                                             #tlf2241x        #制费三成本
                             " NULL, ",                                             #tlf2242x        #制费四成本
                             " NULL, ",                                             #tlf2243x        #制费五成本
                             " NULL, ",                                             #tlf224x         #制费二成本
                             " NULL, ",                                             #tlf65x          #凭证编号
                             " '",p_plant,"', ",                                    #tlfplant        #所属营运中心
                             " '",p_legal,"', ",                                    #tlflegal        #所属法人
                             " NULL, ",                                             #tlf27           #被替代料号
                             " NULL, ",                                             #tlf28           #成会分类
                             " ' ', ",                                              #tlf012          #工艺段号
                             " '0' "                                                #tlf013          #工艺序
   END CASE
   LET l_ins =
      "INSERT INTO ",cl_get_target_table(p_plant,'tlf_file'),"(",
      " tlf01, ",       #异动料件编号
      " tlf02, ",       #来源状况
      " tlf020, ",      #异动来源营运中心编号
      " tlf021, ",      #仓库
      " tlf022, ",      #库位
      " tlf023, ",      #批号
      " tlf024, ",      #异动后库存数量
      " tlf025, ",      #异动后库存数量单位
      " tlf026, ",      #单据编号
      " tlf027, ",      #单据项次
      " tlf03, ",       #目的状况
      " tlf030, ",      #异动目的营运中心编号
      " tlf031, ",      #仓库
      " tlf032, ",      #库位
      " tlf033, ",      #批号
      " tlf034, ",      #异动后库存数量
      " tlf035, ",      #异动后库存数量单位
      " tlf036, ",      #单据编号
      " tlf037, ",      #单据项次
      " tlf04, ",       #工作站
      " tlf05, ",       #作业编号
      " tlf06, ",       #单据扣帐日期
      " tlf07, ",       #运行扣帐日期
      " tlf08, ",       #异动资料生成时间
      " tlf09, ",       #异动资料发出者
      " tlf10, ",       #异动数量
      " tlf11, ",       #异动数量单位
      " tlf12, ",       #异动数量单位与异动目的数量单位转换率
      " tlf13, ",       #异动指令编号
      " tlf14, ",       #异动原因
      " tlf15, ",       #借方会计科目
      " tlf16, ",       #贷方会计科目
      " tlf17, ",       #备注
      " tlf18, ",       #异动后总库存量
      " tlf19, ",       #异动厂商/客户编号/部门编号
      " tlf20, ",       #项目号码
      " tlf21, ",       #成会异动成本
      " tlf211, ",      #成会计算日期
      " tlf212, ",      #成会计算时间
      " tlf2131, ",     #No Use
      " tlf2132, ",     #No Use
      " tlf214, ",      #No Use
      " tlf215, ",      #No Use
      " tlf2151, ",     #No Use
      " tlf216, ",      #No Use
      " tlf2171, ",     #No Use
      " tlf2172, ",     #No Use
      " tlf219, ",      #1.第二单位   2.第一单位
      " tlf218, ",      #第二单位的rowid内容
      " tlf220, ",      #单位  双单位的单位
      " tlf221, ",      #材料成本
      " tlf222, ",      #人工成本
      " tlf2231, ",     #制费一成本
      " tlf2232, ",     #加工成本
      " tlf224, ",      #制费二成本
      " tlf225, ",      #No Use
      " tlf2251, ",     #No Use
      " tlf226, ",      #No Use
      " tlf2271, ",     #No Use
      " tlf2272, ",     #No Use
      " tlf229, ",      #No Use
      " tlf230, ",      #No Use
      " tlf231, ",      #No Use
      " tlf60, ",       #异动单据单位对库存单位之换算率
      " tlf61, ",       #单别
      " tlf62, ",       #工单单号
      " tlf63, ",       #No Use
      " tlf64, ",       #手册编号
      " tlf65, ",       #凭证编号
      " tlf66, ",       #多仓出货 Flag
      " tlf901, ",      #成本仓库
      " tlf902, ",      #仓库
      " tlf903, ",      #库位
      " tlf904, ",      #批号
      " tlf905, ",      #单号
      " tlf906, ",      #项次
      " tlf907, ",      #入出库码
      " tlf908, ",      #保税审核否
      " tlf909, ",      #保税撷取否
      " tlf910, ",      #合同撷取否
      " tlf99, ",       #多角序号
      " tlf930, ",      #成本中心
      " tlf931, ",      #内部成本
      " tlf151, ",      #借方会计科目二
      " tlf161, ",      #贷方会计科目二
      " tlf2241, ",     #制费三成本
      " tlf2242, ",     #制费四成本
      " tlf2243, ",     #制费五成本
      " tlfcost, ",     #类型编号(批次号/专案号/利润中心)
      " tlf41, ",       #WBS编号
      " tlf42, ",       #活动编号
      " tlf43, ",       #理由码
      " tlf211x, ",     #成会计算日期
      " tlf212x, ",     #成会计算时间
      " tlf21x, ",      #成会异动成本
      " tlf221x, ",     #材料成本
      " tlf222x, ",     #人工成本
      " tlf2231x, ",    #制费一成本
      " tlf2232x, ",    #加工成本
      " tlf2241x, ",    #制费三成本
      " tlf2242x, ",    #制费四成本
      " tlf2243x, ",    #制费五成本
      " tlf224x, ",     #制费二成本
      " tlf65x, ",      #凭证编号
      " tlfplant, ",    #所属营运中心
      " tlflegal, ",    #所属法人
      " tlf27, ",       #被替代料号
      " tlf28, ",       #成会分类
      " tlf012, ",      #工艺段号
      " tlf013) "       #工艺序
      

   #新增tlf资料
   LET l_sql = l_ins CLIPPED," ",l_sel CLIPPED," ",l_from CLIPPED," ",l_order CLIPPED
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE ins_tlf_pre FROM l_sql
   EXECUTE ins_tlf_pre
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
     #FUN-CB0103 Add Begin ---
      LET g_errno   = SQLCA.sqlcode
      LET g_msg1    = 'Oper:Ins'||' '||'Table:tlf_file'||' '||'Shop:'||p_plant
      CALL s_errmsg('Batch Operation:','',g_msg1,SQLCA.sqlcode,1)
     #FUN-CB0103 Add End -----
      RETURN
   END IF
   
   DISPLAY "INS TLF 成功笔数: ",SQLCA.sqlerrd[3]
  
  ##更新异动后库存数量
  #CALL cl_replace_sqldb(l_upd) RETURNING l_upd
  #CALL cl_parse_qry_sql(l_upd,p_plant) RETURNING l_upd
  #PREPARE upd_tlf024_pre FROM l_upd
  #EXECUTE upd_tlf024_pre
  #IF SQLCA.sqlcode THEN
  #   LET g_success = 'N'
  #   RETURN
  #END IF
  #DISPLAY "UPD TLF 成功笔数: ",SQLCA.sqlerrd[3]

END FUNCTION 

#FUN-CA0091
