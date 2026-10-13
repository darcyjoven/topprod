/*
================================================================================
檔案代號:ofd_file
檔案名稱:潜在客户主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ofd_file
(
ofd01       varchar2(10) NOT NULL,   /*潜在客户编号                           */
                                     /*潛在客戶編號                           */
ofd02       varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                               */
ofd03       varchar2(4),             /*潜在客户来源                           */
                                     /*潛在客戶來源                           */
ofd04       varchar2(10),            /*客户分类                               */
                                     /*客戶分類                               */
ofd05       varchar2(10),            /*区域编号                               */
                                     /*區域編號                               */
ofd06       date,                    /*创业日                                 */
                                     /*創業日                                 */
ofd07       number(20,6),            /*资本额                                 */
                                     /*資本額                                 */
ofd08       number(20,6),            /*年营业额                               */
                                     /*年營業額                               */
ofd09       number(5),               /*员工人数                               */
                                     /*員工人數                               */
ofd10       varchar2(1),             /*潜在客户等级                           */
                                     /*潛在客戶等級                           */
ofd11       date,                    /*等级调整日                             */
                                     /*等級調整日                             */
ofd12       varchar2(255),           /*等级调整原因                           */
                                     /*等級調整原因                           */
ofd13       varchar2(40),            /*负责人                                 */
                                     /*負責人                                 */
ofd14       varchar2(20),            /*身份证号                               */
                                     /*身份証號                               */
ofd15       varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
ofd16       varchar2(255),           /*主要营业项目-1                         */
                                     /*主要營業項目-1                         */
ofd161      varchar2(255),           /*主要营业项目-2                         */
                                     /*主要營業項目-2                         */
ofd162      varchar2(255),           /*主要营业项目-3                         */
                                     /*主要營業項目-3                         */
ofd17       varchar2(80),            /*公司全名-1                             */
ofd171      varchar2(80),            /*公司全名-2                             */
ofd18       varchar2(255),           /*地址-1                                 */
ofd19       varchar2(255),           /*地址-2                                 */
ofd20       varchar2(255),           /*地址-3                                 */
ofd21       varchar2(255),           /*地址-4                                 */
ofd22       varchar2(1),             /*状态                                   */
                                     /*狀態                                   */
                                     /* 0.登錄(Entry)                         */
                                     /* 1.指派(Assigned)                      */
                                     /* 2.開放(Open)                          */
                                     /* 3.成交(Sign contract)                 */
                                     /* 4.結案(Close)                         */
ofd23       varchar2(10),            /*负责业务员编号                         */
                                     /*負責業務員編號                         */
ofd24       date,                    /*分配日期                               */
ofd25       date,                    /*首次接触日期                           */
                                     /*首次接觸日期                           */
ofd26       date,                    /*最后追踪日期                           */
                                     /*最后追蹤日期                           */
ofd27       date,                    /*预计签约日                             */
                                     /*預計簽約日                             */
ofd28       number(20,6),            /*预估成交金额                           */
                                     /*預估成交金額                           */
ofd29       number(9,4),             /*成交机率                               */
                                     /*成交機率                               */
ofd30       varchar2(10),            /*正式客户编号                           */
                                     /*正式客戶代號                           */
ofd31       varchar2(40),            /*联络人                                 */
                                     /*聯絡人                                 */
ofd32       varchar2(40),            /*联络人职称                             */
                                     /*聯絡人職稱                             */
ofd33       varchar2(40),            /*联络人电话                             */
                                     /*聯絡人電話                             */
ofd34       varchar2(80),            /*联络人Email                            */
                                     /*聯絡人Email                            */
ofd35       varchar2(40),            /*联络人Fax no                           */
                                     /*聯絡人Fax no                           */
ofd36       varchar2(10),            /*邮递区号                               */
                                     /*郵遞區號                               */
ofd37       varchar2(40),            /*潜在客户电话                           */
                                     /*潛在客戶電話                           */
ofd38       varchar2(40),            /*潜在客户传真                           */
                                     /*潛在客戶傳真                           */
ofd39       date,                    /*结案日期                               */
                                     /*結案日期                               */
ofd40       varchar2(10),            /*成交竞争厂商编号                       */
                                     /*成交競爭廠商代號                       */
ofd41       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
ofdacti     varchar2(1),             /*资料有效码                             */
ofduser     varchar2(10),            /*资料所有者                             */
ofdgrup     varchar2(10),            /*资料所有群                             */
ofdmodu     varchar2(10),            /*资料更改者                             */
ofddate     date,                    /*最近更改日                             */
ofdoriu     varchar2(10),            /*资料建立者                             */
ofdorig     varchar2(10)             /*资料建立部门                           */
);

create        index ofd_02 on ofd_file (ofd02);
create        index ofd_04 on ofd_file (ofd17);
create        index ofd_03 on ofd_file (ofd15);
alter table ofd_file add  constraint ofd_pk primary key  (ofd01) enable validate;
grant select on ofd_file to tiptopgp;
grant update on ofd_file to tiptopgp;
grant delete on ofd_file to tiptopgp;
grant insert on ofd_file to tiptopgp;
grant index on ofd_file to public;
grant select on ofd_file to ods;
