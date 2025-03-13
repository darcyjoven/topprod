# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#Link用
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定

IMPORT com   #FUN-720042
IMPORT os   #No.FUN-9C0009  
DATABASE ds
#FUN-720042
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_efgpgw.inc"         #No.FUN-710010
GLOBALS "../4gl/aws_crossgw.inc"        #No:FUN-B20029
DEFINE g_efsoap      STRING
DEFINE g_wse         RECORD LIKE wse_file.*
DEFINE g_wsf         RECORD LIKE wsf_file.*
DEFINE g_wsi         RECORD LIKE wsi_file.*
DEFINE g_wap         RECORD LIKE wap_file.*
DEFINE g_wse03       LIKE wse_file.wse03
DEFINE g_wse04       LIKE wse_file.wse04
DEFINE g_wse05       LIKE wse_file.wse05
DEFINE g_wse06       LIKE wse_file.wse06
DEFINE g_wse07       LIKE wse_file.wse07

FUNCTION aws_efcli2_cf()
    define p_head,p_body om.domnode
    define p_body1        om.domnode
    define p_body2        om.domnode
    define p_body3        om.domnode
    define p_body4        om.domnode
    define p_body5        om.domnode
    define n_field        om.domnode
    define n_record       om.domnode
    define lnode_item     om.domnode
    define n_combo_child  om.domnode
    define n_combo        om.domnode
    define nl_field       om.nodelist
    define nl_record      om.nodelist
    define nl_combo_child om.nodelist
    define nl_combo       om.nodelist
    define cnt_field      like type_file.num10   #no.fun-680130 integer
    define cnt_record     like type_file.num10   #no.fun-680130 integer
    define cnt_combo      like type_file.num10   #no.fun-680130 integer
    define p_window       string
    define l_value        string,
        l_combo_value  string,
        l_name         string,
        l_wsh04        like wsh_file.wsh04,
        l_wsh05        like wsh_file.wsh05,
        l_wsh06        like wsh_file.wsh06,
        l_wsh07        like wsh_file.wsh07,
        l_wsh08        like wsh_file.wsh08,
        l_reference    like type_file.chr1000,#no.fun-680130 varchar(1000)
        l_refvalue     like type_file.chr1000,#no.fun-680130 varchar(1000)
        l_wsi02        like wsi_file.wsi02,
        l_wsi03        like wsi_file.wsi03,
        l_wsi04        like wsi_file.wsi04,
        l_wsi06        like wsi_file.wsi06,
        l_sql          string,
        i,j,k          like type_file.num10,  #no.fun-680130 integer
        l_cnt          like type_file.num10   #no.fun-680130 integer
    define l_gae04        like gae_file.gae04
    define l_gae02        like gae_file.gae02
    define l_window       ui.window 
    define l_wse13        like wse_file.wse13
    #tqc-720066
    define ln_w           om.domnode
    define nl_node        om.nodelist
    define l_i            like type_file.num5
    #end tqc-720066
    define ln_strbuff     base.stringbuffer    #mod-ba0203
    define l_num_value    string               #fun-bb0061 
    define l_type         like type_file.chr1  #fun-bb0061
    define l_format       string               #fun-bb0061
    define l_cnode_item   om.domnode           #fun-bb0061
    define l_format_c     char(50)             #chi-bc0010
    define l_program      char(50)             #chi-bc0010
    define l_tag          char(50)             #chi-bc0010
    define n1,n2,n3       om.domnode
    define nl1,nl2,nl3    om.nodelist
    define l_oea        record like oea_file.*
    define l_oeb    dynamic array of record like oeb_file.*

    initialize l_oea.* to null
    select * into l_oea.* from oea_file where oea01 = g_formNum
    declare get_axmt400_dummy cursor for select * from oeb_file where oeb01 = l_oea.oea01
    call l_oeb.clear()
    let l_cnt = 1
    foreach get_axmt400_dummy into l_oeb[l_cnt].*
    if sqlca.sqlcode then
        let g_success = 'N'
        return
    end if
    let l_cnt = l_cnt + 1
    end foreach
    call l_oeb.deleteElement(l_cnt)

    let p_head = base.TypeInfo.create(l_oea)
    let p_body1 = base.TypeInfo.create(l_oeb)


    call aws_dummy_XMLHeader(p_head)

    # run "echo ' line 87 "||g_strXMLInput||"' >> /u1/out/darcy.log"
    #組單頭  資料
    DECLARE window_cs_dummy CURSOR FOR 
        SELECT wsh04,wsh05,wsh06,wsh07,wsh08 FROM wsh_file 
        WHERE wsh01=g_prog AND wsh02='M' ORDER BY wsh04

    FOREACH window_cs_dummy INTO l_wsh04,l_wsh05,l_wsh06,l_wsh07,l_wsh08  
        LET l_type = "0"   #FUN-BB0061
        LET l_value = ""
        let nl_node = p_head.selectByTagName("Field")

        let l_cnt = nl_node.getLength()
        FOR l_i = 1 TO l_cnt
            LET lnode_item = nl_node.item(l_i)
            LET l_name = lnode_item.getAttribute("name")
            # run "echo ' line 105 l_name "||l_name||"' >> /u1/out/darcy.log"
            # run "echo ' line 106 l_wsh05 "||l_wsh05||"' >> /u1/out/darcy.log"
            IF l_name = l_wsh05 CLIPPED THEN
                LET l_value = lnode_item.getAttribute("value")
                # LET l_value = aws_efcli2_getdata( l_wsh05 ,l_value)
                if not cl_null(l_value) then
                    LET g_strXMLInput = g_strXMLInput CLIPPED,
                    #"       <",l_wsh05 CLIPPED,">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                                      #FUN-BB0061 mark
                    #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value, "</",l_wsh05 CLIPPED,">", ASCII 10                                 #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                    "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol(l_value), "</",l_wsh05 CLIPPED,">", ASCII 10
                    exit for
                end if
            end if
        end for
    end foreach

    LET g_strXMLInput = g_strXMLInput CLIPPED,
               "    </head>", ASCII 10
    # run "echo ' line 120 "||g_strXMLInput||"' >> /u1/out/darcy.log"
    # 单身资料

    FOR k = 1 TO 5 
        CASE  k
           WHEN 1
             LET p_body = p_body1
           WHEN 2
             LET p_body = p_body2
           WHEN 3
             LET p_body = p_body3
           WHEN 4
             LET p_body = p_body4
           WHEN 5
             LET p_body = p_body5
        END CASE
        IF p_body IS NULL THEN
            # run "echo ' line 137 "||g_strXMLInput||"' >> /u1/out/darcy.log"
            IF k = 1 THEN
                LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                                  "    <body>", ASCII 10,
                                  "    </body>", ASCII 10

            END IF
            EXIT FOR
        END IF
        LET g_strXMLInput = g_strXMLInput CLIPPED,
                               "    <body>", ASCII 10
        LET nl_record = p_body.selectByTagName("Record")
        LET cnt_record = nl_record.getLength()
        # run "echo ' line 150 "||g_strXMLInput||"' >> /u1/out/darcy.log"
        FOR i=1 to cnt_record 
            LET g_strXMLInput = g_strXMLInput CLIPPED,
                                  "      <record>", ASCII 10
            LET n_record = nl_record.item(i)
            LET nl_field = n_record.selectByTagName("Field")
            LET cnt_field = nl_field.getLength()
            # run "echo ' line 160 cnt_field "||cnt_field||"' >> /u1/out/darcy.log"
            FOR j =1 to cnt_field
                # 每个栏位开始
                LET l_type = "0"   #FUN-BB0061
                LET n_field  = nl_field.item(j)
                LET l_value = n_field.getAttribute("value")
                LET l_name = n_field.getAttribute("name")
                LET l_wsh05 = l_name CLIPPED
                SELECT count(*) INTO l_cnt FROM wsh_file
                    WHERE wsh01 = g_prog AND wsh02='D' AND wsh05 = l_wsh05
                IF l_cnt > 0 THEN
                    SELECT wsh05,wsh06,wsh07,wsh08 INTO l_wsh05,l_wsh06,l_wsh07,l_wsh08 FROM wsh_file
                        WHERE wsh01 = g_prog AND wsh02='D' AND wsh05 = l_wsh05
                    # run "echo ' line 168 "||g_strXMLInput||"' >> /u1/out/darcy.log"
                    LET l_gae04 = NULL
                    let nl1 = p_body.selectByTagName("Record")
                    # run "echo ' line 171 "||"' >> /u1/out/darcy.log"
                    let n2 = nl1.item(1)
                    # run "echo ' line 173 "||"' >> /u1/out/darcy.log"
                    let nl_node = n2.selectByTagName("Field")
                    # run "echo ' line 175 "||"' >> /u1/out/darcy.log"
                    LET l_cnt = nl_node.getLength()
                    # run "echo ' line 177 l_cnt "||l_cnt||"' >> /u1/out/darcy.log"
                    FOR l_i = 1 TO l_cnt
                        LET lnode_item = nl_node.item(l_i)
                        LET l_name = lnode_item.getAttribute("name")
                        IF l_name = l_wsh05 CLIPPED THEN
                            let l_value = lnode_item.getAttribute("value")
                            exit for
                        END IF
                    END FOR
                    # run "echo ' line 183 l_name"||l_name||"' >> /u1/out/darcy.log"
                    # run "echo ' line 184 l_wsh05"||l_wsh05||"' >> /u1/out/darcy.log"
                    # run "echo ' line 185 l_value"||l_value||"' >> /u1/out/darcy.log"
                    IF l_wsh06 IS NULL THEN
                        
                        IF l_gae04 IS NOT NULL THEN
                            LET l_value = l_value ,":",l_gae04
                        END IF
                        # run "echo ' line 202 "||g_strXMLInput||"' >> /u1/out/darcy.log"
                        LET g_strXMLInput = g_strXMLInput CLIPPED,
                            #"       <",l_wsh05 CLIPPED,">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                                      #FUN-BB0061 mark
                            #"       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", l_value , "</",l_wsh05 CLIPPED,">", ASCII 10                                #FUN-BB0061 在tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                            "       <",l_wsh05 CLIPPED, " type=\"", l_type, "\">", aws_efcli2_eol( l_value) , "</",l_wsh05 CLIPPED,">", ASCII 10   #FUN-C40061
                    END IF
                    LET l_reference = l_refvalue
                    IF l_gae04 IS NOT NULL THEN
                        LET l_value = l_value ,":",l_gae04
                    END IF
                END IF
            END FOR
            LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                               "    </record>", ASCII 10
            # run "echo ' line 205 "||g_strXMLInput||"' >> /u1/out/darcy.log"
        END FOR
        LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
                               "    </body>", ASCII 10
        # run "echo ' line 209 "||g_strXMLInput||"' >> /u1/out/darcy.log"
    END FOR

    #呼叫 aws_efcli2_XMLTrailer() 組出 XML Trailer 資訊
    -- CALL aws_efcli2_XMLTrailer()
    LET g_strXMLInput = aws_xml_replace(g_strXMLInput)   #MOD-890161
    CALL aws_efcli2_attach()   #是否有附件
    LET g_strXMLInput = g_strXMLInput CLIPPED,   #組 XML Trailer
        "   </ContentText>", ASCII 10,
        "  </Form>", ASCII 10,
        " </RequestContent>", ASCII 10,
        "</Request>"
    # run "echo ' line 221 "||g_strXMLInput||"' >> /u1/out/darcy.log"
END FUNCTION
 
FUNCTION aws_spccli_cf(p_filed,p_key1,p_key2,p_key3,p_key4,p_key5)
DEFINE p_filed     STRING
DEFINE p_key1      STRING
DEFINE p_key2      STRING
DEFINE p_key3      STRING
DEFINE p_key4      STRING
DEFINE p_key5      STRING
 
  RETURN ''
END FUNCTION

function aws_dummy_XMLHeader(p_head)
    define p_head                om.domnode
    define l_client         string,
        l_efsiteip    string,
        l_efsitename  string,
        l_i           like type_file.num5,    #No.FUN-680130 SMALLINT
    #END TQC-5A0129
        l_lang         string                 #FUN-B30160 增加l_lang節點
    define l_wse12       like wse_file.wse12
    define l_wse13       like wse_file.wse13
    define l_wsj02       like wsj_file.wsj02
    define l_wsj03       like wsj_file.wsj03
    define l_wsj04       like wsj_file.wsj04
    define l_wse12_value string
    define l_wse13_value string,
            l_title       like type_file.chr1000 #no.fun-680130 varchar(100)
    define lnode_item    om.domnode
    define l_window      ui.window 
    define l_value       string
    define l_sql         like type_file.chr1000 #no.fun-680130 varchar(200)
    define l_wsi02       like wsi_file.wsi02
    #tqc-720066
    define ln_w          om.domnode
    define nl_node       om.nodelist
    define l_name        string
    define l_cnt         like type_file.num5
    #end tqc-720066
    #no.fun-750113 --start--
    define l_cnt2        like type_file.num10
    define l_gen01       like gen_file.gen01
    define l_gen03       like gen_file.gen03
    define l_zx01        like zx_file.zx01
    define l_zx03        like zx_file.zx03
    define l_orgunitid   string
    #no.fun-750113 --end--
    define l_tpip        string,   #fun-960137
            l_tpenv       string    #fun-960137
    define l_creator_tag string    #fun-c40086

    SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04 
      FROM wsj_file where wsj01 = 'E' AND wsj06 = g_plant 
        AND wsj05 = '*' AND wsj07 = '*'
    IF l_wsj02 IS NULL THEN
      SELECT wsj02,wsj03,wsj04 INTO l_wsj02,l_wsj03,l_wsj04 
        FROM wsj_file where wsj01 = 'S' AND wsj06 = '*' 
         AND wsj05 = '*' AND wsj07 = '*'
    END IF
 
    LET l_client = cl_getClientIP()       #Client IP
    LET g_efsoap = l_wsj03 CLIPPED       #EasyFlow SOAP
    LET l_efsiteip = l_wsj02 CLIPPED     #EasyFlow server IP
    LET l_efsitename = l_wsj04 CLIPPED   #EasyFlow server name
    LET l_tpip = cl_get_tpserver_ip()    #TIPTOP IP   #FUN-960137
    LET l_tpenv = cl_get_env()           #TIPTOP ENV  #FUN-960137

    let g_lang = '2'
    CASE g_lang                                   # FUN-B30160 #指定語言別
         WHEN '0' LET l_lang = "Big5"             # FUN-B30160
         WHEN '1' LET l_lang = "ISO8859"          # FUN-B30160
         WHEN '2' LET l_lang = "GB"               # FUN-B30160
         OTHERWISE LET l_lang = "ISO8859"         # FUN-B30160
    END CASE

    SELECT wse12,wse13 INTO l_wse12,l_wse13 FROM wse_file where wse01= g_prog

    LET nl_node = p_head.selectByTagName("Field")
    let l_cnt = nl_node.getLength()
    FOR l_i = 1 TO l_cnt
         LET lnode_item = nl_node.item(l_i)
         LET l_name = lnode_item.getAttribute("name")
         IF cl_null(l_name) THEN
            continue FOR
         END IF
         IF l_name = l_wse12 CLIPPED THEN
            LET l_wse12_value = lnode_item.getAttribute("value")
            EXIT FOR
         END IF
    END FOR

    LET l_wse13_value = ""
    FOR l_i = 1 TO l_cnt
         LET lnode_item = nl_node.item(l_i)
         LET l_name = lnode_item.getAttribute("name")
         IF cl_null(l_name) THEN
            continue FOR
         END IF
         IF l_name = l_wse13 CLIPPED THEN
            LET l_wse13_value = lnode_item.getAttribute("value")
            EXIT FOR
         END IF
    END FOR

    IF cl_null(l_wse13_value) THEN
            SELECT * INTO g_wsi.* FROM wsi_file WHERE wsi01 = g_prog 
               AND wsi02 = l_wse13 AND wsi05 = g_wse03
            IF g_wsi.wsi06 IS NULL OR g_wsi.wsi06 = ""THEN
               LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
                        " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
            ELSE
               LET l_sql = "SELECT ",g_wsi.wsi02 CLIPPED," FROM ",g_wsi.wsi03 CLIPPED,
                        " WHERE ",g_wsi.wsi04 CLIPPED," = '", g_formNum CLIPPED,"'"
                        ," AND ",g_wsi.wsi06 CLIPPED
            END IF
          DECLARE wsi_cs_dummy CURSOR FROM l_sql
          FOREACH wsi_cs_dummy INTO l_wsi02 
          END FOREACH   
          LET l_wse13_value = l_wsi02
    END IF

    # LET l_wse13_value = aws_efcli2_getdata(l_wse13 , l_wse13_value)

    LET l_gen01 = l_wse13_value
    LET l_zx01 = l_wse13_value

    #darcy:2022/10/17 add s---
    # 通过接口获取BPM接口组织架构
    call cws_bpm_getGem(l_wse13_value) returning l_gen03
    let l_orgUnitID = l_gen03
    if cl_null(l_gen03) then
    #darcy:2022/10/17 add e---
      SELECT COUNT(*) INTO l_cnt2 FROM gen_file where gen01=l_gen01
      IF l_cnt2 > 0 THEN
         # get dept ID by employee ID
         SELECT gen03 INTO l_gen03 FROM gen_file where gen01=l_gen01
         LET l_orgUnitID = l_gen03 CLIPPED
      ELSE
         # get dept ID by user ID
         SELECT zx03 INTO l_zx03 FROM zx_file where zx01=l_zx01
         LET l_orgUnitID = l_zx03 CLIPPED
      END IF
      #No.FUN-750113 --end--
    end if #darcy:2022/10/17 add

    IF g_wse04 IS NOT NULL THEN
        LET g_formNum = g_formNum CLIPPED,"{+}", g_wse04 CLIPPED,"=", g_key1
       IF g_wse05 IS NOT NULL THEN
           LET g_formNum = g_formNum CLIPPED,"{+}", g_wse05 CLIPPED ,"=", g_key2
           IF g_wse06 IS NOT NULL THEN
               LET g_formNum = g_formNum CLIPPED ,"{+}", g_wse06 CLIPPED ,"=",g_key3 
               IF g_wse07 IS NOT NULL THEN
                   LET g_formNum = g_formNum CLIPPED,"{+}", g_wse07 CLIPPED,"=", g_key4
               END IF
           END IF
       END IF
    END IF

    SELECT gaz03 INTO l_title FROM gaz_file 
          where gaz01= g_prog AND gaz02 = g_lang 
 
    LET g_formid = s_get_doc_no(g_formNum)           #MOD-590183

    #FUN-C40086 start
    LET l_creator_tag = SFMT("<FormCreatorID%1>%2" , aws_efcli2_scrtyitem(g_prog,l_wse12)
                                                      , l_wse12_value)
    #FUN-C40086 end
 
    LET g_strXMLInput =                           #組 XML Header
        "    <Request>", ASCII 10,
        "    <RequestMethod>CreateForm</RequestMethod>", ASCII 10,
        "    <LogOnInfo>", ASCII 10,
        "    <SenderIP>", l_client CLIPPED, "</SenderIP>", ASCII 10,
        "    <ReceiverIP>", l_efsiteip CLIPPED, "</ReceiverIP>", ASCII 10,
        "    <EFSiteName>", l_efsitename CLIPPED, "</EFSiteName>", ASCII 10,
        "    <EFLogonID>", g_user CLIPPED, "</EFLogonID>", ASCII 10,
        #"   <OrgUnitID>", g_grup CLIPPED, "</OrgUnitID>", ASCII 10, #No.FUN-710010 #No.FUN-750113 
        "    <OrgUnitID>", l_orgUnitID CLIPPED, "</OrgUnitID>", ASCII 10, #No.FUN-750113
        "    <TPServerIP>",l_tpip CLIPPED, "</TPServerIP>", ASCII 10,    #FUN-960137
        "    <TPServerEnv>",l_tpenv CLIPPED, "</TPServerEnv>", ASCII 10, #FUN-960137
        "    </LogOnInfo>", ASCII 10,
        "    <RequestContent>", ASCII 10,
        "    <Form>", ASCII 10,
        "    <Language>", l_lang CLIPPED, "</Language>", ASCII 10,        #FUN-B30160
        "    <PlantID>", g_plant CLIPPED, "</PlantID>", ASCII 10,
        "    <ProgramID>", g_prog CLIPPED, "</ProgramID>", ASCII 10,
        "    <SourceFormID>",  g_formid, "</SourceFormID>", ASCII 10, #MOD-590183
        "    <SourceFormNum>", g_formNum CLIPPED, "</SourceFormNum>", ASCII 10,
        #"    <FormCreatorID>", l_wse12_value CLIPPED, "</FormCreatorID>", ASCII 10, #FUN-C40086  #FUN-560007
        "   ", l_creator_tag , "</FormCreatorID>", ASCII 10,   #FUN-C40086
        "    <FormOwnerID>", l_wse13_value  CLIPPED, "</FormOwnerID>", ASCII 10,
        "    <ContentText>", ASCII 10,
        "    <title>", l_title CLIPPED, "</title>", ASCII 10,
        "    <head>", ASCII 10

    
end function
