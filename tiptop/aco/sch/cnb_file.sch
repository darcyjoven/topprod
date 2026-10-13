/*
================================================================================
檔案代號:cnb_file
檔案名稱:海关-公司基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cnb_file
(
cnb01       varchar2(10) NOT NULL,   /*公司代码                               */
cnb02       varchar2(1),             /*No Use                                 */
cnb03       date,                    /*成立时间                               */
cnb04       varchar2(40),            /*公司简称                               */
cnb05       varchar2(10),            /*海关编号                               */
cnb06       varchar2(80),            /*公司名称                               */
cnb061      varchar2(80),            /*公司名称                               */
cnb07       varchar2(255),           /*公司地址                               */
cnb071      varchar2(255),           /*公司地址                               */
cnb08       varchar2(80),            /*香港对应公司名称                       */
cnb081      varchar2(255),           /*香港对应公司地址                       */
cnb09       number(20,6),            /*注册资本                               */
cnb10       varchar2(4),             /*注册资本币种                           */
cnb11       number(20,6),            /*投资总额                               */
cnb12       number(20,6),            /*进口设备免税额度                       */
cnb13       varchar2(15),            /*营业执照号码                           */
cnb14       varchar2(15),            /*批准证书号码                           */
cnb15       varchar2(15),            /*自理报关注册证书号码                   */
cnb16       varchar2(15),            /*税务登记证明号码                       */
cnb17       varchar2(20),            /*企业性质                               */
cnb18       varchar2(10),            /*法人代表                               */
cnb19       varchar2(10),            /*法人代码                               */
cnb20       varchar2(1),             /*No Use                                 */
cnbacti     varchar2(1),             /*资料有效码                             */
cnbuser     varchar2(10),            /*资料所有者                             */
cnbgrup     varchar2(10),            /*资料所有部门                           */
cnbmodu     varchar2(10),            /*资料更改者                             */
cnbdate     date,                    /*最近更改日                             */
cnboriu     varchar2(10),            /*资料建立者                             */
cnborig     varchar2(10)             /*资料建立部门                           */
);

alter table cnb_file add  constraint cnb_pk primary key  (cnb01) enable validate;
grant select on cnb_file to tiptopgp;
grant update on cnb_file to tiptopgp;
grant delete on cnb_file to tiptopgp;
grant insert on cnb_file to tiptopgp;
grant index on cnb_file to public;
grant select on cnb_file to ods;
