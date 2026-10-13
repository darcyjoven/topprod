/*
================================================================================
檔案代號:npq_file
檔案名稱:分录底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npq_file
(
npqsys      varchar2(2) NOT NULL,    /*系统                                   */
                                     /*系統別                                 */
npq00       number(5) NOT NULL,      /*类型                                   */
                                     /*類別                                   */
npq01       varchar2(30) NOT NULL,   /*单号                                   */
                                     /*單號 modify 98/08/31 for ala01         */
npq011      number(5) NOT NULL,      /*异动序号                               */
                                     /*異動序號                               */
npq02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
npq03       varchar2(24),            /*科目                                   */
npq04       varchar2(80),            /*摘要                                   */
npq05       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
npq06       varchar2(1),             /*借贷别                                 */
                                     /*借貸別 (1.借 2.貸)                     */
npq07f      number(20,6) NOT NULL,   /*原币金额                               */
                                     /*原幣金額                               */
npq07       number(20,6) NOT NULL,   /*本币金额                               */
                                     /*本幣金額                               */
npq08       varchar2(15),            /*项目编号                               */
                                     /*專案編號                               */
npq11       varchar2(30),            /*核算项-1                               */
                                     /*異動碼-1                               */
npq12       varchar2(30),            /*核算项-2                               */
                                     /*異動碼-2                               */
npq13       varchar2(30),            /*核算项-3                               */
                                     /*異動碼-3                               */
npq14       varchar2(30),            /*核算项-4                               */
                                     /*異動碼-4                               */
npq15       varchar2(10),            /*预算编号                               */
                                     /*預算編號                               */
npq21       varchar2(10),            /*客户编号/厂商编号                      */
                                     /*客戶編號/廠商編號                      */
npq22       varchar2(40) DEFAULT ' ',/*客户简称/厂商简称                      */
                                     /*客戶簡稱/廠商簡稱                      */
npq23       varchar2(20),            /*立冲单号                               */
                                     /*立沖單號                               */
npq24       varchar2(4),             /*原币币种                               */
                                     /*原幣幣別                               */
npq25       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
npq26       varchar2(1),             /*No Use                                 */
npq27       number(5),               /*No Use                                 */
npq28       varchar2(10),            /*No Use                                 */
npq29       number(5),               /*No Use                                 */
npq30       varchar2(10),            /*资料来源营运中心                       */
                                     /*工廠編號                               */
npq31       varchar2(30),            /*核算项-5                               */
                                     /*#FUN-5C0015                            */
npq32       varchar2(30),            /*核算项-6                               */
                                     /*#FUN-5C0015                            */
npq33       varchar2(30),            /*核算项-7                               */
                                     /*#FUN-5C0015                            */
npq34       varchar2(30),            /*核算项-8                               */
                                     /*#FUN-5C0015                            */
npq35       varchar2(30),            /*核算项-9                               */
                                     /*#FUN-5C0015                            */
npq36       varchar2(30),            /*核算项-10                              */
                                     /*#FUN-5C0015                            */
npq37       varchar2(30),            /*核算项-关系人                          */
                                     /*#FUN-5C0015                            */
npq930      varchar2(6),             /*No Use                                 */
npqtype     varchar2(1) NOT NULL,    /*分录底稿类型                           */
npqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index npq_02 on npq_file (npq11);
create        index npq_03 on npq_file (npq15);
create        index npq_04 on npq_file (npq03);
alter table npq_file add  constraint npq_pk primary key  (npq01,npq011,npq02,npqsys,npq00,npqtype) enable validate;
grant select on npq_file to tiptopgp;
grant update on npq_file to tiptopgp;
grant delete on npq_file to tiptopgp;
grant insert on npq_file to tiptopgp;
grant index on npq_file to public;
grant select on npq_file to ods;
