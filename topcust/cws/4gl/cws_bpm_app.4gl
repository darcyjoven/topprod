# auther :darcy
# date :2022/09/01
# describe: bpm送签各程序调用函数，主要功能为组成formfield函数

import xml
database ds
globals "../../../tiptop/config/top.global"

# apmt420请购单送签
function cws_bpm_apmt420(l_pmk01)
    define l_pmk01      like pmk_file.pmk01

    define l_status     like type_file.num10
    define l_response   string
    define l_request    string
    define l_detail     string
    define l_cnt        like type_file.num5
    define qgdh         like pmk_file.pmk01
    define qgrq         like pmk_file.pmk04
    define qgdxz        like pmk_file.pmk02
    define qgy          varchar(100)
    define qgbm         varchar(100)
    define records  dynamic array of record
                serialNo    like pml_file.pml02,
                ljbh        like pml_file.pml04,
                pm          like ima_file.ima02,
                gg          like ima_file.ima021,
                qgdw        like pml_file.pml07,
                qgl         like pml_file.pml20,
                zcgl        like pml_file.pml21,
                dkrq_txt    like pml_file.pml35,
                dcrq_txt    like pml_file.pml34,
                jhrq_txt    like pml_file.pml33,
                bz          like pml_file.pml06,
                sfjl        like pml_file.pml91
        end record
    define cnts             integer
    define doc              xml.DomDocument
    define bpm_no           string


    # 检查是否是合法单据
    if cl_null(l_pmk01) then
        return
    end if
    let l_cnt = 0
    select count(1) into l_cnt from pmk_file,pml_file where pmk01 =l_pmk01 and pmk18='N' and pml01 = pmk01
    --and pmk25='0' and pmkmksg='Y' #mark 暂时不再增加此条件
    if l_cnt = 0 then
        return
    end if

    # formfield 单头设置
    select pmk01,pmk04,pmk02 into qgdh,qgrq,qgdxz from pmk_file  where pmk01 = l_pmk01
    let qgy = g_user
    let qgbm = g_grup

    let l_request = '<![CDATA[<qgd>
                        <qgdh id="qgdh" dataType="java.lang.String" perDataProId="">',qgdh,'</qgdh>
                        <qgrq id="qgrq" dataType="java.util.Date">',qgrq,'</qgrq>
                        <qgdxz id="qgdxz" dataType="java.lang.String" perDataProId="">',qgdxz,'</qgdxz>
                        <qgy id="qgy" dataType="java.lang.String" hidden="">',qgy,'</qgy>
                        <qgbm id="qgbm" dataType="java.lang.String" hidden="">',qgbm,'</qgbm>
                        <ljbh id="ljbh" dataType="java.lang.String" perDataProId=""></ljbh>
                        <pm id="pm" dataType="java.lang.String" perDataProId=""></pm>
                        <gg id="gg" dataType="java.lang.String" perDataProId=""></gg>
                        <qgdw id="qgdw" dataType="java.lang.String" perDataProId=""></qgdw>
                        <qgl id="qgl" dataType="java.lang.String" perDataProId=""></qgl>
                        <zcgl id="zcgl" dataType="java.lang.String" perDataProId=""></zcgl>
                        <dkrq id="dkrq" dataType="java.util.Date">2022/08/30</dkrq>
                        <dcrq id="dcrq" dataType="java.util.Date">2022/08/30</dcrq>
                        <jhrq id="jhrq" dataType="java.util.Date">2022/08/30</jhrq>
                        <bz id="bz" dataType="java.lang.String" perDataProId=""></bz>
                        <sfjl id="sfjl" dataType="java.lang.String"></sfjl>
                        <bg1 id="bg1">
                            <records>'
    
    # formfield 单身设置
    declare apmt420_d cursor for 
     select pml02,pml04,ima02,ima021,pml07,pml20,pml21,pml35,pml34,pml33,pml06,pml91 from pml_file,ima_file
      where pml01 = l_pmk01 and ima01= pml04
    
    let cnts = 1
    foreach apmt420_d into records[cnts].*
        if sqlca.sqlcode then
            call cl_err("apmt420_d","!",10)
        end if
        let l_request = l_request, '<record id="',cnts,'">
                            <item id="serialNo" dataType="java.lang.String" perDataProId="">',records[cnts].serialNo,'</item>
                            <item id="ljbh" dataType="java.lang.String" perDataProId="">',records[cnts].ljbh,'</item>
                            <item id="pm" dataType="java.lang.String" perDataProId="">',records[cnts].pm,'</item>
                            <item id="gg" dataType="java.lang.String" perDataProId="">',records[cnts].gg,'</item>
                            <item id="qgdw" dataType="java.lang.String" perDataProId="">',records[cnts].qgdw,'</item>
                            <item id="qgl" dataType="java.lang.String" perDataProId="">',records[cnts].qgl,'</item>
                            <item id="zcgl" dataType="java.lang.String" perDataProId="">',records[cnts].zcgl,'</item>
                            <item id="dkrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].dkrq_txt,'</item>
                            <item id="dcrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].dcrq_txt,'</item>
                            <item id="jhrq_txt" dataType="java.lang.String" perDataProId="">',records[cnts].jhrq_txt,'</item>
                            <item id="bz" dataType="java.lang.String" perDataProId="">',records[cnts].bz,'</item>
                            <item id="sfjl" dataType="java.lang.String" perDataProId="">',records[cnts].sfjl,'</item>
                        </record>'
        let cnts = cnts + 1
    end foreach
    let l_request = l_request, "
                            </records>
                        </bg1>
                    </qgd>]]>" 
    #pSubject 
    # call cimi999_invokProcess(
    #     "PKG16582113889266",
    #     l_pmk01,
    #     l_request
    # ) returning l_response

    call cws_bpm_invoke_by_go(
        cws_bpm_set_invoke_request(
            "PKG16582113889266",
            l_pmk01,
            l_request
        )
    ) returning l_response
    
    #解析回传的资料内容
    let doc = xml.DomDocument.create()
    call doc.loadFromString(l_response)
    let bpm_no = cws_bpm_selectByXPath(doc,"//invokeProcessReturn")
    
    if cl_null(bpm_no) then
        #报错
        let bpm_no = cws_bpm_selectByXPath(doc,"//faultstring")
        return false,bpm_no
    else
        return true,bpm_no
    end if
end function
