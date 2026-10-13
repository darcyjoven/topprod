/*
================================================================================
檔案代號:rus_file
檔案名稱:盘点计划资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rus_file
(
rus01       varchar2(20) DEFAULT ' ' NOT NULL, /*盘点计划单号*/
rus02       varchar2(40),            /*盘点计划名称                           */
rus03       date,                    /*设置日期                               */
rus04       date,                    /*盘点日期                               */
rus05       varchar2(255),           /*盘点仓库                               */
rus06       varchar2(1),             /*限定品类                               */
rus07       varchar2(255),           /*品类代码                               */
rus08       varchar2(1),             /*限定品牌                               */
rus09       varchar2(255),           /*品牌编号                               */
rus10       varchar2(1),             /*限定厂商                               */
rus11       varchar2(255),           /*厂商代码                               */
rus12       varchar2(1),             /*限定产品                               */
rus13       varchar2(255),           /*产品编号                               */
rus14       varchar2(255),           /*备注                                   */
rus15       varchar2(1),             /*已产生费用                             */
rus16       varchar2(1),             /*结案码                                 */
rus900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rusacti     varchar2(1),             /*资料有效码                             */
ruscond     date,                    /*审核日期                               */
rusconf     varchar2(1),             /*审核码                                 */
ruscont     varchar2(8),             /*审核时间                               */
rusconu     varchar2(10),            /*审核人员                               */
ruscrat     date,                    /*资料创建日                             */
rusdate     date,                    /*最近更改日                             */
rusdays     number(5),               /*签核完成天数                           */
rusgrup     varchar2(10),            /*资料所有部门                           */
ruslegal    varchar2(10) NOT NULL,   /*所属法人                               */
rusmksg     varchar2(1),             /*是否签核                               */
rusmodu     varchar2(10),            /*资料更改者                             */
rusplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruspos      varchar2(1) DEFAULT '1', /*已传POS否                              */
rusprit     number(5),               /*签核优先等级                           */
russign     varchar2(4),             /*签核等级                               */
russmax     number(5),               /*应签核顺序                             */
russseq     number(5),               /*已签核顺序                             */
rususer     varchar2(10),            /*资料所有者                             */
rusoriu     varchar2(10),            /*资料建立者                             */
rusorig     varchar2(10)             /*资料建立部门                           */
);

alter table rus_file add  constraint rus_pk primary key  (rus01) enable validate;
grant select on rus_file to tiptopgp;
grant update on rus_file to tiptopgp;
grant delete on rus_file to tiptopgp;
grant insert on rus_file to tiptopgp;
grant index on rus_file to public;
grant select on rus_file to ods;
