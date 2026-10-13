/*
================================================================================
檔案代號:tc_dhy_file
檔案名稱:项目陪审单
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_dhy_file
(
tc_dhy00    varchar2(1) NOT NULL,    /*项目类型                               */
                                     /*1：新增；2：版本升级                   */
tc_dhy01    varchar2(40),            /*升级厂内料号                           */
tc_dhy02    date,                    /*评审日期                               */
tc_dhy03    varchar2(10),            /*客户名称                               */
tc_dhy04    varchar2(40),            /*客户料号                               */
tc_dhy05    varchar2(40) NOT NULL,   /*厂内料号                               */
tc_dhy06    number(15,3),            /*订单数量                               */
tc_dhy07    date,                    /*出货日期                               */
tc_dhy08    varchar2(1),             /*产品类型                               */
                                     /*1：单面板；2：双面板；3：多层板；4：软硬结合版；5：组合版；6：其他*/
tc_dhy09    varchar2(1),             /*客户是否支持样品费用                   */
tc_dhy10    varchar2(1),             /*前版本处理方式                         */
                                     /*1：报废；2：保留                       */
tc_dhy11    varchar2(1),             /*样品性质                               */
                                     /*1：样品；2：重复样品；3：小批量；4：样品转量产*/
tc_dhy12    varchar2(1),             /*Drawing（图纸）                        */
tc_dhy13    varchar2(1),             /*Gerber file                            */
tc_dhy14    varchar2(1),             /*SPEC(客户规范)                         */
tc_dhy15    varchar2(1),             /*Sample（客户提供样品，需要颜           */
tc_dhy16    varchar2(1),             /*是否需要SMT                            */
tc_dhy17    varchar2(1),             /*光板电测方式                           */
                                     /*1：飞针；2：治具                       */
tc_dhy18    varchar2(1),             /*组装板电测方式                         */
                                     /*1：ICT测试；2：功能测试；3：其他       */
tc_dhy19    varchar2(1),             /*外形成型方式                           */
                                     /*1：激光；2：蚀刻刀模；3：简易钢模；4：量产钢模*/
tc_dhy20    varchar2(1),             /*客供                                   */
tc_dhy21    varchar2(1),             /*自购                                   */
tc_dhy22    varchar2(1),             /*出货方式                               */
                                     /*1：单片方式；2：连片出货               */
tc_dhy23    varchar2(1),             /*包装方式                               */
                                     /*1：PET袋；2：微粘膜；3：托盘；4：其他  */
tc_dhy24    varchar2(1),             /*是否符合法规要求                       */
tc_dhy241   varchar2(255),           /*否原因                                 */
tc_dhy25    varchar2(1),             /*UL要求                                 */
tc_dhy26    varchar2(1),             /*是否满足厂内制程能力                   */
tc_dhy261   varchar2(255),           /*否要求                                 */
tc_dhy27    varchar2(1),             /*厂内原材料是否满足                     */
tc_dhy271   varchar2(255),           /*否要求                                 */
tc_dhy28    varchar2(1),             /*SMT组装方式                            */
                                     /*1：单pes；2：连板；3：其他模板         */
tc_dhy29    varchar2(1),             /*SMT组装是否需要外发                    */
tc_dhy291   varchar2(255),           /*是原因                                 */
tc_dhy30    varchar2(1),             /*SMT组装资料是否齐全                    */
tc_dhy301   varchar2(255),           /*否原因                                 */
tc_dhy31    varchar2(1),             /*物料供应是否满足（见MI）               */
tc_dhy311   varchar2(255),           /*否原因                                 */
tc_dhy32    varchar2(1),             /*是否需要外协加工（见MI）               */
tc_dhy321   varchar2(255),           /*是原因                                 */
tc_dhy33    varchar2(1),             /*交货期限是否满足                       */
tc_dhy331   varchar2(255),           /*否原因                                 */
tc_dhy34    varchar2(255),           /*业务备注                               */
tc_dhy35    varchar2(255),           /*工程备注                               */
tc_dhy36    varchar2(255),           /*生管备注                               */
tc_dhy37    varchar2(1),             /*交货地点                               */
                                     /*1：对方公司所在地；2：订单注明交货地点；3：对方指定交货地点*/
tc_dhy38    varchar2(1),             /*是否通过                               */
tc_dhy39    varchar2(255),           /*否原因                                 */
tc_dhy40    varchar2(1),             /*审核否                                 */
tc_dhy41    date,                    /*审核日期                               */
tc_dhyacti  varchar2(1),             /*资料有效码                             */
tc_dhyuser  varchar2(10),            /*资料所有者                             */
tc_dhygrup  varchar2(10),            /*资料所有部门                           */
tc_dhymodu  varchar2(10),            /*资料更改者                             */
tc_dhydate  date,                    /*最近更改者                             */
tc_dhyud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_dhyud02  varchar2(40) NOT NULL,   /*评审单号                               */
tc_dhyud03  varchar2(40),            /*自订栏位-文本                          */
tc_dhyud04  varchar2(40),            /*自订栏位-文本                          */
tc_dhyud05  varchar2(40),            /*自订栏位-文本                          */
tc_dhyud06  varchar2(40),            /*自订栏位-文本                          */
tc_dhyud07  number(15,3),            /*自订栏位-数值                          */
tc_dhyud08  number(15,3),            /*自订栏位-数值                          */
tc_dhyud09  number(15,3),            /*自订栏位-数值                          */
tc_dhyud10  number(10),              /*层数                                   */
tc_dhyud11  number(10),              /*自订栏位-整数                          */
tc_dhyud12  number(10),              /*自订栏位-整数                          */
tc_dhyud13  date,                    /*自订栏位-日期                          */
tc_dhyud14  date,                    /*自订栏位-日期                          */
tc_dhyud15  date                     /*自订栏位-日期                          */
);

alter table tc_dhy_file add  constraint tpc_dhy_pk primary key  (tc_dhyud02) enable validate;
grant select on tc_dhy_file to tiptopgp;
grant update on tc_dhy_file to tiptopgp;
grant delete on tc_dhy_file to tiptopgp;
grant insert on tc_dhy_file to tiptopgp;
grant index on tc_dhy_file to public;
grant select on tc_dhy_file to ods;
