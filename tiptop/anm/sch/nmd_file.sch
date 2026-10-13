/*
================================================================================
檔案代號:nmd_file
檔案名稱:应付票据资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmd_file
(
nmd01       varchar2(20) NOT NULL,   /*开票单号                               */
                                     /*應付票據單號                           */
nmd02       varchar2(20),            /*票号                                   */
                                     /*票號                                   */
nmd03       varchar2(20),            /*付款银行                               */
                                     /*付款銀行                               */
nmd04       number(20,6),            /*票面金额                               */
                                     /*票面金額                               */
nmd05       date,                    /*到期日                                 */
nmd06       varchar2(2),             /*票别一                                 */
                                     /*票別一                                 */
nmd07       date,                    /*开票日                                 */
                                     /*開票日                                 */
nmd08       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
nmd09       varchar2(80),            /*厂商全名                               */
                                     /*廠商全名                               */
nmd10       varchar2(20),            /*付款单号                               */
                                     /*付款單號                               */
nmd101      number(5),               /*付款单项次                             */
                                     /*付款單項次                             */
nmd11       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
nmd12       varchar2(1),             /*当前票况                               */
                                     /*目前票況                               */
                                     /*1:開立 6:撤票 7:退票 8:兌現 9:作廢     */
                                     /*X:開立 由付款單拋轉而成                */
nmd13       date,                    /*最近异动日期                           */
                                     /*最近異動日期                           */
nmd14       varchar2(1),             /*寄领方式                               */
                                     /*寄領方式  1:寄出 2:自領 3.其它         */
nmd15       date,                    /*寄领日期                               */
                                     /*寄領日期                               */
nmd16       varchar2(30),            /*经办人                                 */
                                     /*經辦人(寄領)                           */
nmd17       varchar2(10),            /*付款理由                               */
nmd18       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
nmd19       number(20,10),           /*最近异动汇率                           */
                                     /*最近異動匯率                           */
nmd20       varchar2(2),             /*票别二                                 */
                                     /*票別二                                 */
nmd21       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
nmd22       varchar2(30),            /*厂商收件人/寄领方式为'其它'            */
                                     /*廠商收件人/寄領方式為'其它'時的處理人  */
nmd23       varchar2(24),            /*开票贷方科目                           */
                                     /*開票貸方科目                           */
nmd24       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
nmd25       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
nmd26       number(20,6),            /*本币金额                               */
                                     /*本幣金額                               */
nmd27       varchar2(20),            /*开票凭证编号                           */
                                     /*開票傳票編號                           */
                                     /*此資料由付款單產生或自行輸入           */
nmd28       date,                    /*开票凭证日期                           */
                                     /*開票傳票日期(97/04/18 NO USE)          */
                                     /*此資料由付款單產生或自行輸入           */
nmd29       date,                    /*结案日期                               */
                                     /*結案日期                               */
nmd30       varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X)                          */
nmd31       number(5),               /*簿号                                   */
                                     /*簿號                                   */
nmd32       varchar2(1),             /*代付生成否                             */
                                     /*代付產生否(Y/N)                        */
nmd33       number(20,10),           /*重估汇率                               */
nmd34       varchar2(10),            /*付款单营运中心                         */
                                     /*付款單工廠                             */
nmd50       varchar2(1),             /*签回否                                 */
                                     /*簽回否(Y/N)                            */
nmd51       varchar2(1),             /*信贷区分                               */
                                     /*信貸區分  1.短期融資 2.中長貸款        */
nmd52       varchar2(20),            /*参考单号                               */
                                     /*參考單號                               */
nmd53       varchar2(1),             /*还本兑现                               */
                                     /*還本兌現                               */
nmduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmdgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmd231      varchar2(24),            /*开票贷方科目二                         */
nmdud01     varchar2(255),           /*自订字段-Textedit                      */
nmdud02     varchar2(40),            /*自订字段-文字                          */
nmdud03     varchar2(40),            /*自订字段-文字                          */
nmdud04     varchar2(40),            /*自订字段-文字                          */
nmdud05     varchar2(40),            /*自订字段-文字                          */
nmdud06     varchar2(40),            /*自订字段-文字                          */
nmdud07     number(15,3),            /*自订字段-数值                          */
nmdud08     number(15,3),            /*自订字段-数值                          */
nmdud09     number(15,3),            /*自订字段-数值                          */
nmdud10     number(10),              /*自订字段-整数                          */
nmdud11     number(10),              /*自订字段-整数                          */
nmdud12     number(10),              /*自订字段-整数                          */
nmdud13     date,                    /*自订字段-日期                          */
nmdud14     date,                    /*自订字段-日期                          */
nmdud15     date,                    /*自订字段-日期                          */
nmd40       varchar2(1),             /*类型                                   */
nmdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmdoriu     varchar2(10),            /*资料建立者                             */
nmdorig     varchar2(10),            /*资料建立部门                           */
nmd54       date,                    /*取票日期                               */
nmd55       number(20,6) DEFAULT '0' NOT NULL /*已冲金额*/
);

create        index nmd_06 on nmd_file (nmd27);
create        index nmd_03 on nmd_file (nmd05);
create        index nmd_04 on nmd_file (nmd07);
create        index nmd_02 on nmd_file (nmd02);
create        index nmd_05 on nmd_file (nmd10);
alter table nmd_file add  constraint nmd_pk primary key  (nmd01) enable validate;
grant select on nmd_file to tiptopgp;
grant update on nmd_file to tiptopgp;
grant delete on nmd_file to tiptopgp;
grant insert on nmd_file to tiptopgp;
grant index on nmd_file to public;
grant select on nmd_file to ods;
