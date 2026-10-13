/*
================================================================================
檔案代號:rti_file
檔案名稱:策略变更单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rti_file
(
rti01       varchar2(20) DEFAULT ' ' NOT NULL, /*策略变更单号*/
rti02       varchar2(1),             /*生效方式                               */
                                     /*生效方式 1:立即变更 2:指定日期         */
rti03       date,                    /*生效日期                               */
rti04       number(5,2),             /*标准售价预调价比例                     */
rti05       number(5,2),             /*标准会员价预调价比例                   */
rti06       number(5,2),             /*标准最低价预调价比例                   */
rti07       varchar2(255),           /*备注                                   */
rti900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rtiacti     varchar2(1),             /*资料有效码                             */
rticond     date,                    /*审核日期                               */
rticonf     varchar2(1),             /*审核码                                 */
rticonu     varchar2(10),            /*审核人员                               */
rticrat     date,                    /*资料创建日                             */
rtidate     date,                    /*最近更改日                             */
rtidays     number(15,3),            /*签核完成天数                           */
rtigrup     varchar2(10),            /*资料所有部门                           */
rtilegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtimksg     varchar2(1),             /*是否签核                               */
rtimodu     varchar2(10),            /*资料更改者                             */
rtiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rtiprit     varchar2(1),             /*签核优先等级                           */
rtisign     varchar2(1),             /*签核等级                               */
rtismax     varchar2(1),             /*应签核顺序                             */
rtisseq     varchar2(1),             /*已签核顺序                             */
rtiuser     varchar2(10),            /*资料所有者                             */
rtiorig     varchar2(10),            /*资料建立部门                           */
rtioriu     varchar2(10)             /*资料建立者                             */
);

alter table rti_file add  constraint rti_pk primary key  (rti01) enable validate;
grant select on rti_file to tiptopgp;
grant update on rti_file to tiptopgp;
grant delete on rti_file to tiptopgp;
grant insert on rti_file to tiptopgp;
grant index on rti_file to public;
grant select on rti_file to ods;
