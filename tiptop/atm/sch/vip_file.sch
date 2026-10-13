/*
================================================================================
檔案代號:vip_file
檔案名稱:vip资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vip_file
(
vip01       varchar2(20) NOT NULL,   /*VIP卡号                                */
vip02       varchar2(10),            /*VIP种类编号                            */
vip03       date,                    /*生效日期                               */
vip04       date,                    /*失效日期                               */
vip05       varchar2(1),             /*状态                                   */
vip06       varchar2(80),            /*姓名                                   */
vip07       date,                    /*生日                                   */
vip08       varchar2(80),            /*手机                                   */
vip09       varchar2(255),           /*地址                                   */
vip10       varchar2(10),            /*性别                                   */
vip11       varchar2(80),            /*电话                                   */
vip12       varchar2(80),            /*e-mail                                 */
vip13       number(20,6),            /*累计消费额                             */
vip14       number(10),              /*累计消费积分                           */
vip15       number(10),              /*当前积分                               */
vipacti     varchar2(1),             /*资料有效码                             */
vipdate     date,                    /*最近更改日                             */
vipgrup     varchar2(10),            /*资料所有部门                           */
vipmodu     varchar2(10),            /*资料更改者                             */
vipuser     varchar2(10),            /*资料所有者                             */
vipplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
viplegal    varchar2(10) NOT NULL,   /*所属法人                               */
viporig     varchar2(10),            /*资料建立部门                           */
viporiu     varchar2(10)             /*资料建立者                             */
);

alter table vip_file add  constraint vip_pk primary key  (vip01) enable validate;
grant select on vip_file to tiptopgp;
grant update on vip_file to tiptopgp;
grant delete on vip_file to tiptopgp;
grant insert on vip_file to tiptopgp;
grant index on vip_file to public;
grant select on vip_file to ods;
