require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Server' do
  it "should get home page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hullo')
  end
end
