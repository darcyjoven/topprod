/*
================================================================================
檔案代號:npp_file
檔案名稱:分录底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npp_file
(
nppsys      varchar2(2) NOT NULL,    /*系统                                   */
                                     /*系統別                                 */
                                     /*NM/AP/LC/AR/FA/GF/PY/CF/CC/CD          */
npp00       number(5) NOT NULL,      /*类型                                   */
                                     /*NM(1.A/P 2.A/R 3.Bank)(4.Certificate of Deposit Pledge 5.Certificate of Deposit Remove Pledge )(6.Pay Interest 7. Pay Principal 8.Exchange Delivery 9.Exchange )(10.Interest Received Amount 11.Deposit Received Aomunt 12.Certificate of Deposit add)13.Cash in Bank EoM Revalu.14.N/R End of Month Revalu.15.N/P End of Month Revalu.16.Short Term Loan 17. Term Loan18. 19. 20. 21.Conglomerate Funds Transfer22.Conglomerate Funds Pay Principal23.Conglomerate Funds Pay Interest24.Financing Interest Temp. Estimate  AP(1.A/P 2.Direct Payment 3.Payment 4.Cost Apportionment5.Final Change Exchange)  LC(4.Foreign Purchase 5.Foreign Purchase Payment 6.Foreign Purchase Modify 7.Payment Modify 9.Close) AR(1.Delivery 2.A/R 3.Collection) 4.Final Change Exchange)  FA(x.Sheet 0.Acquire 1.Capitalization(faq) 2.Dept. Trans.7.Improve(fay) 8.Revaluate(fba) 4.Sale(fbe) 5.Retire(fbg) 6.Charge off(fbg) 9.Adjust(fbc) 10.Depreciation 11.Interest Capitalization(fcx) 12.Insurance 13.Devalue Preparative)   PY(1.Payable 2.Pension Reserve 3.Pay Held)   CF(1.Remittance Doc.)  */
                                     /*pic08                                  */
                                     /*  CD(1.Long-term Investments Recognized)*/
npp01       varchar2(30) NOT NULL,   /*单号                                   */
                                     /*單號  modify 98/08/31 for ala01        */
                                     /*若為人事之單號為計薪指標+公司代碼      */
npp011      number(5) NOT NULL,      /*异动序号                               */
                                     /*異動序號                               */
                                     /*AP =1                                  */
                                     /*AR =1                                  */
                                     /*NM 應收/應付依序號,銀行收支=1,         */
                                     /*   質押=2,解除質押=3                   */
                                     /*   外匯交易=0,外匯交割=序號            */
                                     /*PY =1                                  */
npp02       date,                    /*异动日期                               */
                                     /*異動日期                               */
npp03       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
npp04       number(5),               /*是否已经统计更新                       */
                                     /*0:done                                 */
                                     /*1:processing                           */
npp05       varchar2(2),             /*抛转种类                               */
                                     /*拋轉種類                               */
                                     /*如開票時,票況由0-1 ,其值為 '01'        */
npp06       varchar2(10),            /*总账营运中心                           */
                                     /*营运中心编号                           */
npp07       varchar2(5),             /*帐套                                   */
                                     /*帳別                                   */
nppglno     varchar2(20),            /*已抛转凭证编号                         */
                                     /*已拋轉傳票編號                         */
npptype     varchar2(1) NOT NULL,    /*分录底稿类型                           */
                                     /*0.Main Book No.                        */
                                     /*1.Sub Book No.                         */
npplegal    varchar2(10) NOT NULL,   /*所属法人                               */
npp08       varchar2(3)              /*附件张数                               */
);

create        index npp_02 on npp_file (npp02);
create        index npp_03 on npp_file (nppglno);
alter table npp_file add  constraint npp_pk primary key  (npp01,npp011,nppsys,npp00,npptype) enable validate;
grant select on npp_file to tiptopgp;
grant update on npp_file to tiptopgp;
grant delete on npp_file to tiptopgp;
grant insert on npp_file to tiptopgp;
grant index on npp_file to public;
grant select on npp_file to ods;
