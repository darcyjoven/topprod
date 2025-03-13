# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: cws_check_put_set.4gl
# Descriptions...: 检查当站委外入库数量
# Date & Author..:darcy:2023/05/08

{
    request
    --------------------------
<Request>
    <Access>
        <Authentication user="tiptop" password="tiptop" />
        <Connection application="MES" source="127.0.0.1" />
        <Organization name="FOREWIN" />
        <Locale language="zh_cn" />
    </Access>
    <RequestContent>
        <Parameter></Parameter>
        <Document>
            <RecordSet id="1">
                <Master name="CheckPutSet">
                    <Record>
                        <!-- 以下是参数 -->
                        <Field name="lot_no" value="MRA-22080866-007-00" />
                        <Field name="job_order" value="360" />
                        <Field name="job_no" value="F04060" />
                        <Field name="num" value="400" />
                    </Record>
                </Master>
            </RecordSet>
        </Document>
    </RequestContent>
</Request>
    response 
    ----------------------------
<Response>
  <Execution>
    <Status code="0" sqlcode="0" description=""/>
  </Execution>
  <ResponseContent>
    <Parameter/>
    <Document>
      <RecordSet id="1">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="2">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="3">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="4">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="5">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="6">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="7">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="8">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="9">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
      <RecordSet id="10">
        <Master name="Master">
          <Record>
            <Field name="item_no" value="MRA-22080866-007-00"/>
            <Field name="want" value="7200.000"/>
            <Field name="got" value="6000.000"/>
          </Record>
        </Master>
      </RecordSet>
    </Document>
  </ResponseContent>
</Response>

}
 
database ds
 
 
globals "../../config/top.global" 
globals "../../../tiptop/aws/4gl/aws_ttsrv_global.4gl"

define l_return record
        flag        like type_file.chr1,
        subnum      like type_file.num20_6,
        dtsnum      like type_file.num20_6
        end record

function cws_check_put_set()
     
    whenever error continue
 
    call aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #fun-860037 
    #--------------------------------------------------------------------------#
    # 查詢 erp 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    if g_status.code = "0" then
       call cws_check_put_set_process()
    end if
 
    call aws_ttsrv_postprocess()   #呼叫服務後置處理程序
end function

function cws_check_put_set_process()
    define param record
        lot_no      like sgm_file.sgm01,
        job_order   like sgm_file.sgm01,
        job_no      like sgm_file.sgm04,
        num         like sgm_file.sgm313
        end record

    define l_node,l_node1           om.DomNode
    define l_sql    string
    define l_cnt1        like type_file.num5

    define l_return record
        item_no     like ima_file.ima01,
        want        like type_file.num15_3,
        got         like type_file.num15_3
        end record
    
    define l_i,l_j  integer
    define sr record
          sfa01 like sfa_file.sfa01,
          sfa03 like sfa_file.sfa03,
          sfa08 like sfa_file.sfa08,
          sfa12 like sfa_file.sfa12,
          sfa26 like sfa_file.sfa26,
          sfa27 like sfa_file.sfa27,
          sfa11 like sfa_file.sfa11
      end record
    define l_str  string

    

    let l_cnt1 = aws_ttsrv_getmasterrecordlength("CheckPutSet")
    if l_cnt1 = 0 then
        let g_status.code = "-1"
        let g_status.description = "无资料!"
        return
    end if 
    
    let l_node1 = aws_ttsrv_getMasterRecord(1, "CheckPutSet")

    # 获取第一个 Master 
    let param.lot_no = aws_ttsrv_getRecordField(l_node1,"lot_no")
    let param.job_order = aws_ttsrv_getRecordField(l_node1,"job_order")
    let param.job_no = aws_ttsrv_getRecordField(l_node1,"job_no")
    let param.num = aws_ttsrv_getRecordField(l_node1,"num")
    

    if cl_null(param.job_order) then
        select sgm03 into param.job_order from sgm_file
         where sgm01 = param.lot_no and sgm04 = param.job_no
        if cl_null(param.job_order) then
            let g_status.code = "-1"
            let g_status.description = "无资料"
            let g_success = 'N'
        end if
    end if

    let l_cnt1 = 0
    select count(1) into l_cnt1 from sgm_file
     where sgm01 = param.lot_no and sgm03 = param.job_order
    if l_cnt1 <= 0 then
        let g_status.code = "-1"
        let g_status.description = "未查询到指定lot单",param.lot_no,param.job_order,param.job_no
        let g_success = 'N'
    end if

    let l_str = param.lot_no
    let param.lot_no = l_str.subString(1,12)
    ## 计算逻辑 s---
    declare get_sfa_list cursor for
      select sfa01,sfa03,sfa08,sfa12,sfa26,sfa27,sfa11 from sfa_file
       where sfa01 = param.lot_no and sfa08 = param.job_no
         and sfa26 not in ('S','U')
    
    initialize sr to null
    foreach get_sfa_list into sr.*
      if sqlca.sqlcode then
        let g_status.code = sqlca.sqlcode
        let g_status.description = "无资料处理!"
        exit foreach
      end if
      let l_return.item_no = sr.sfa03
      -- 消耗性料件不需要检查
      if sr.sfa11 ='E' then
        let l_return.want = 0
        let l_return.got = 0
      else
        call cs_get_want(
          sr.sfa01,
          sr.sfa03,
          sr.sfa08,
          sr.sfa12,
          sr.sfa26,
          sr.sfa27,
          param.num
        )
          returning l_return.want,l_return.got
      end if
      
      let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")
    end foreach

    # for l_i = 1 to 10
    #     let l_return.item_no = param.lot_no
    #     let l_return.want = 18*param.num
    #     let l_return.got = 15*param.num

    #     let l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_return), "Master")   #加入此筆單檔資料至 Response 中
    # end for
    ## 计算逻辑 e---

end function
