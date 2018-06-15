## Copyright (c) 2015 SONATA-NFV, 2017 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Neither the name of the SONATA-NFV, 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote
## products derived from this software without specific prior written
## permission.
##
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the SONATA
## partner consortium (www.sonata-nfv.eu).
##
## This work has been performed in the framework of the 5GTANGO project,
## funded by the European Commission under Grant number 761493 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the 5GTANGO
## partner consortium (www.5gtango.eu).
# frozen_string_literal: true
# encoding: utf-8
require_relative '../spec_helper'
require 'uri'

RSpec.describe FetchVNFDsService do
  describe '.call' do
    let(:site)  {FetchVNFDsService.class_variable_get(:@@site)}
    let(:uuid_1) {SecureRandom.uuid}
    let(:function_1_metadata) {{uuid: uuid_1, vnfd: {vendor: '5gtango', name: 'whatever', version: '0.0.1'}}}
    context 'without UUID' do
      let(:uuid_2) {SecureRandom.uuid}
      let(:function_2_metadata) {{uuid: uuid_2, vnfd: {vendor: '5gtango', name: 'whatever', version: '0.0.2'}}}
      let(:functions_metadata) {[function_1_metadata, function_2_metadata]}
      let(:headers) {{'content-type' => 'application/json'}}
      let(:default_page_size) {ENV.fetch('DEFAULT_PAGE_SIZE', '100')}
      let(:default_page_number) {ENV.fetch('DEFAULT_PAGE_NUMBER', '0')}
      let(:page_number) {'page_number='+default_page_number}
      let(:page_size) {'page_size='+default_page_size}
      let(:vendor_1) {function_1_metadata[:vnfd][:vendor]}
      let(:vendor_2) {function_2_metadata[:vnfd][:vendor]}
      let(:name_1) {function_1_metadata[:vnfd][:name]}
      let(:name_2) {function_2_metadata[:vnfd][:name]}
      let(:version_1) {function_1_metadata[:vnfd][:version]}
      let(:version_2) {function_2_metadata[:vnfd][:version]}
      let(:param_1) {{vendor: vendor_1, name: name_1, version: version_1}}
      let(:param_2) {{vendor: vendor_2, name: name_2, version: version_2}}
      let(:call_params) {[param_1, param_2]}
      let(:headers) do
        uri = URI(site)
        {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>"#{uri.host}:#{uri.port}", 'User-Agent'=>'Ruby'}
      end

      it 'returns the requested functions meta-data when no restriction is passed' do
        stub_request(:get, site+'?'+page_number+'&'+page_size+'&vendor='+vendor_1+'&name='+name_1+'&version='+version_1).
          with(headers: headers).to_return(status: 200, body: [function_1_metadata].to_json, headers: headers)
        expect(described_class.call(param_1)).to eq([function_1_metadata])
      end
      
=begin
      it 'returns the requested services meta-data when no restriction is passed' do
        stub_request(:get, catalogue_url+'/network-services?page_number='+default_page_number+'&page_size='+default_page_size).
          with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'example.com', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: services_metadata.to_json, headers: headers)
        expect(described_class.call({})).to eq(services_metadata)
      end
      it 'calls the Catalogue with default params' do      
        stub_request(:get, catalogue_url+'/network-services?page_number='+default_page_number+'&page_size='+default_page_size).to_return(status: 200, body: services_metadata.to_json, headers: headers)
        expect(described_class.call({})).to eq(services_metadata)
      end
      it 'calls the Catalogue with default page_size when only page_number is passed' do      
        stub_request(:get, catalogue_url+'/network-services?page_number=1&page_size='+default_page_size).to_return(status: 200, body: [].to_json, headers: headers)
        expect(described_class.call({page_number: 1})).to eq([])
      end
      it 'calls the Catalogue with default page_number when only page_size is passed' do      
        stub_request(:get, catalogue_url+'/network-services?page_number='+default_page_number+'&page_size=1').to_return(status: 200, body: [service_1_metadata].to_json, headers: headers)
        expect(described_class.call({page_size: 1})).to eq([service_1_metadata])
      end
      it 'calls the Catalogue with default page_number and page_size, returning existing services' do      
        stub_request(:get, catalogue_url+'/network-services?page_number='+default_page_number+'&page_size='+default_page_size).
          to_return(status: 200, body: services_metadata.to_json, headers: {'content-type' => 'application/json'})
        expect(described_class.call({page_size: default_page_size, page_number: default_page_number})).to eq(services_metadata)
      end
=end
    end
  end
end
